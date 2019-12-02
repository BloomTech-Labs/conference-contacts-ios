//
//  DummyViewController.swift
//  swaap
//
//  Created by Michael Redig on 12/2/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class DummyViewController: UIViewController {

	var coordinator: ProfileCoordinator?

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	@IBAction func buttonPressed(_ sender: UIButton) {
		coordinator?.showThing()
	}
}
