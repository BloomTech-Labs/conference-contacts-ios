//
//  ProfileViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 11/22/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, Storyboarded {

	@IBOutlet private weak var profileCardView: UIView!

	override func viewDidLoad() {
        super.viewDidLoad()
//		navigationController?.navigationBar.isHidden = true

		profileCardView.layer.cornerRadius = 20
		profileCardView.layer.cornerCurve = .continuous

		setupCardShadow()
		updateViews()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupCardShadow()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		profileCardView.setNeedsUpdateConstraints()
		updateViews()
	}

	private func setupCardShadow() {
		profileCardView.layer.shadowPath = UIBezierPath(rect: profileCardView.bounds).cgPath
		profileCardView.layer.shadowRadius = 14
		profileCardView.layer.shadowOffset = .zero
		profileCardView.layer.shadowOpacity = 0.3
	}

	private func updateViews() {

	}

	@IBAction func testButtonPressed(_ sender: UIButton) {
		print("tested")
	}
}
