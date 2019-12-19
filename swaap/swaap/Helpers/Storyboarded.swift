//
//  Storyboarded.swift
//  swaap
//
//  Created by Marlon Raskin on 11/22/19.
//  Copyright © 2019 swaap. All rights reserved.

import UIKit

protocol Storyboarded {
	static func instantiate(storyboardName name: String, with customInitializer: ((NSCoder) -> UIViewController?)?) -> Self
}

extension Storyboarded where Self: UIViewController {
	static func instantiate(storyboardName name: String = "Main", with customInitializer: ((NSCoder) -> UIViewController?)? = nil) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)

		// instantiate a view controller with that identifier, and force cast as the type that was requested
		if let customInitializer = customInitializer {
			guard let storyboardedVC = storyboard.instantiateViewController(identifier: className, creator: customInitializer) as? Self
				else { fatalError("Storyboard \(name) has no view controller identified as \(className)") }
			return storyboardedVC
		} else {
			guard let storyboardedVC = storyboard.instantiateViewController(withIdentifier: className) as? Self
				else { fatalError("Storyboard \(name) has no view controller identified as \(className)") }
			return storyboardedVC
		}

    }
}
