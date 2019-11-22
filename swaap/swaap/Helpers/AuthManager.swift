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


class AuthManager: NSObject {

	// MARK: - Properties
	let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
	let keychain = A0SimpleKeychain()

	private(set) var credentials: Credentials?

	// MARK: - Lifecycle
	override init() {
		super.init()
		tryRenewAuth { credentials, error in
			if let error = error {
				NSLog("Unable to renew authorization: \(error)")
				return
			}
			DispatchQueue.main.async {
				guard let credentials = credentials else {
					print("Failed restoring credentials")
					return
				}
				print("restored saved credentials: \(credentials)")
			}
		}
	}

	// MARK: - Auth Methods (The Guts)
	func showWebAuth() {
		Auth0.webAuth().scope("openid profile").audience("https://api.swaap.co/").start { result in
			switch result {
			case .failure(let error):
				NSLog("Error: \(error)")
			case .success(let credentials):
				#warning("Fix me")
//				self.keychain.setString(appleIDCredential.user, forKey: .userIDKey)
//				self.credentials = credentials
//				_ = self.credentialsManager.store(credentials: credentials)
				NSLog("Credentials: \(credentials)")
			}
		}
	}

	func signInWithApple() {
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.email, .fullName]

		let authController = ASAuthorizationController(authorizationRequests: [request])
		authController.delegate = self
		authController.presentationContextProvider = self
		authController.performRequests()
	}

	func tryRenewAuth(_ callback: @escaping (Credentials?, Error?) -> Void) {
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
					self.credentials = credentials
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
	}

	func clearSession() {
		Auth0.webAuth().clearSession(federated: false) { success in
			print("Successful logout: \(success)")
		}
	}

	// MARK: - Utilities
	private func storeCredentials() {
		// Add stuff
	}
}


// MARK: - Sign in with Apple Delegate
extension AuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	#warning("Fix me?")
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
				self.keychain.setString(appleIDCredential.user, forKey: .userIDKey)
				self.credentials = credentials
				_ = self.credentialsManager.store(credentials: credentials)
			case .failure(let error):
				NSLog("Exchange failed: \(error)")
			}
		}
	}
}

fileprivate extension String {
	static let userIDKey = "userID"
}
