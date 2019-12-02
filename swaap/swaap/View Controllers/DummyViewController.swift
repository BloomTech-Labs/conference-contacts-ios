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

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}


	@IBAction func buttonPressed(_ sender: UIButton) {

		coordinator?.showThing()
	}
}
