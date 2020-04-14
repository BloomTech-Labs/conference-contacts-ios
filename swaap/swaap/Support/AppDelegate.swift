//
//  AppDelegate.swift
//  swaap
//
//  Created by Marlon Raskin on 11/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import Auth0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	let userDefaults: UserDefaultsProtocol = UserDefaults.standard

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		if userDefaults.objectForKey("InitialLaunch") == nil {
			let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
			let onboardingVC = storyboard.instantiateInitialViewController()
			window?.rootViewController = onboardingVC
			window?.makeKeyAndVisible()
		}
		return true
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
		Auth0.resumeAuth(url, options: options)
	}
}
