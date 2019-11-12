//
//  Window2.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class MyWindow: UIWindow {
	override var rootViewController: UIViewController? {
		didSet {
			rootViewController?.didMoveToWindow(self)
		}
	}
}

extension UIViewController {
	@objc func didMoveToWindow(_ window: UIWindow) {
		print("test")
	}
}

