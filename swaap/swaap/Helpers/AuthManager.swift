//
//  AuthManager.swift
//  swaap
//
//  Created by Marlon Raskin on 11/21/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation
import Auth0
import SimpleKeychain
import AuthenticationServices

protocol AuthAccessor: AnyObject {
	var authManager: AuthManager? { get set }
}

extension NSNotification.Name {
	static let swaapCredentialsChanged = NSNotification.Name("com.swaapapp.credentialsChanged")
}

class AuthManager: NSObject {

	typealias AuthCallbackHandler = (Error?) -> Void

	// MARK: - Properties
	let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
	let keychain = A0SimpleKeychain()

	private(set) var credentials: Credentials? {
		didSet {
			DispatchQueue.main.async {
				// send notification that credentials changed
				NotificationCenter.default.post(name: .swaapCredentialsChanged, object: nil)
			}
		}
	}
	let credentialsLoading = DispatchSemaphore(value: 0)

	// MARK: - Lifecycle
	override init() {
		super.init()

		tryRenewAuth { credentials, error in
			defer { self.credentialsLoading.signal() }
			if let error = error {
				NSLog("Unable to renew authorization: \(error)")
				return
			}
			guard let credentials = credentials else {
				print("Failed restoring credentials")
				return
			}
			self.credentials = credentials
			print("restored saved credentials: \(credentials)")
		}
	}

	// MARK: - Auth Methods (The Guts)
	func showWebAuth(completion: @escaping AuthCallbackHandler) {
		Auth0.webAuth().scope("openid profile").audience("https://api.swaap.co/").start { result in
			switch result {
			case .success(let credentials):
				self.storeCredentials(appleID: nil, credentials: credentials)
				completion(nil)
			case .failure(let error):
				NSLog("Error: \(error)")
				completion(error)
			}
		}
	}

	private var signInWithAppleCallbackHandler: AuthCallbackHandler?

	func signInWithApple(completion: @escaping AuthCallbackHandler) {
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.email, .fullName]

		signInWithAppleCallbackHandler = completion

		let authController = ASAuthorizationController(authorizationRequests: [request])
		authController.delegate = self
		authController.presentationContextProvider = self
		authController.performRequests()
	}

	func tryRenewAuth(_ callback: @escaping (Credentials?, Error?) -> Void) {
		guard let signInWithAppleUsed = keychain.string(forKey: .signInWithAppleOptionToggleKey) else {
			callback(nil, nil)
			return
		}

		if signInWithAppleUsed == "true" {
			let provider = ASAuthorizationAppleIDProvider()

			guard let userID = keychain.string(forKey: .userIDKey) else {
				return callback(nil, nil)
			}

			provider.getCredentialState(forUserID: userID) { state, error in
				switch state {
				case .authorized:
					self.credentialsManager.credentials { error, credentials in
						guard error == nil, let credentials = credentials else {
							return callback(nil, error)
						}
						callback(credentials, nil)
						print("Credentials state is Authorized: \(credentials)")
					}
				default:
					self.keychain.deleteEntry(forKey: .userIDKey)
					_ = self.credentialsManager.clear()
					print("Credential state is unauthorized")
					callback(nil, error)
				}
			}
		} else if signInWithAppleUsed == "false" {
			credentialsManager.credentials { error, credentials in
				guard error == nil, let credentials = credentials else {
					return callback(nil, error)
				}
				callback(credentials, nil)
				print("Credentials state is Authorized: \(credentials)")
			}
		}
	}

	func signUp(with email: String, password: String, completion: @escaping AuthCallbackHandler) {
		Auth0.authentication()
			.createUser(email: email,
						password: password,
						connection: "Username-Password-Authentication",
						userMetadata: ["first_name": "First", "last_name": "Last"])
			.start { result in
				switch result {
				case .success(let user):
					print("User Signed up: \(user)")
					completion(nil)
				case .failure(let error):
					print("Failed with \(error)")
					completion(error)
				}
		}
	}

	func clearSession() {
		Auth0.webAuth().clearSession(federated: false) { success in
			print("Successful logout: \(success)")
		}
		_ = self.credentialsManager.clear()
		keychain.deleteEntry(forKey: .signInWithAppleOptionToggleKey)
	}

	// MARK: - Utilities
	private func storeCredentials(appleID: String?, credentials: Credentials) {
		// Add stuff
		if let appleID = appleID {
			keychain.setString(appleID, forKey: .userIDKey)
			keychain.setString("true", forKey: .signInWithAppleOptionToggleKey)
		} else {
			keychain.setString("false", forKey: .signInWithAppleOptionToggleKey)
		}
		_ = self.credentialsManager.store(credentials: credentials)
	}
}


// MARK: - Sign in with Apple Delegate
extension AuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		guard let window = UIApplication.shared.delegate?.window as? UIWindow else { fatalError("No window") }
		return window
	}

	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		NSLog("Authorization failed: \(error)")
	}

	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
		guard let authCodeData = appleIDCredential.authorizationCode,
			let authCode = String(data: authCodeData, encoding: .utf8) else {
			NSLog("Problem with Auth Code: \(appleIDCredential.authorizationCode as Any)")
			return
		}

		Auth0.authentication().tokenExchange(withAppleAuthorizationCode: authCode).start { result in
			switch result {
			case .success(let credentials):
				print("Auth0 success: \(credentials)")
				self.credentials = credentials
				self.storeCredentials(appleID: appleIDCredential.user, credentials: credentials)
				self.signInWithAppleCallbackHandler?(nil)
			case .failure(let error):
				NSLog("Exchange failed: \(error)")
				self.signInWithAppleCallbackHandler?(error)
			}
			self.signInWithAppleCallbackHandler = nil
		}
	}
}

fileprivate extension String {
	static let userIDKey = "userID"
	static let signInWithAppleOptionToggleKey = "signInWithAppleUsed"
}
