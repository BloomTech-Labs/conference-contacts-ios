//
//  SwipeBackNavigationController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/3/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class SwipeBackNavigationController: UINavigationController {
	var popRecognizer: InteractivePopRecognizer?

	override func viewDidLoad() {
		super.viewDidLoad()
		fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack()
	}

	private func fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack() {
		popRecognizer = InteractivePopRecognizer(controller: self)
		interactivePopGestureRecognizer?.delegate = popRecognizer
	}
}
