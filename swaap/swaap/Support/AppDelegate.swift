//
//  AppDelegate.swift
//  swaap
//
//  Created by Marlon Raskin on 11/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.


		window = MyWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.rootViewController = RootTabBarController()

		return true
	}

}
