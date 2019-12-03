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
	@IBOutlet private weak var visualFXView: UIVisualEffectView!
	@IBOutlet private weak var backButton: UIButton!

	override func viewDidLoad() {
        super.viewDidLoad()

		profileCardView.layer.cornerRadius = 20
		profileCardView.layer.cornerCurve = .continuous

		setupCardShadow()
		setupFXView()
		updateViews()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
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

	@IBAction func backbuttonTapped(_ sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}

	private func setupCardShadow() {
		profileCardView.layer.shadowPath = UIBezierPath(rect: profileCardView.bounds).cgPath
		profileCardView.layer.shadowRadius = 14
		profileCardView.layer.shadowOffset = .zero
		profileCardView.layer.shadowOpacity = 0.3
	}

	private func setupFXView() {
		visualFXView.layer.cornerRadius = visualFXView.frame.height / 2
		visualFXView.clipsToBounds = true
		visualFXView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
	}

	private func updateViews() {
		if let count = navigationController?.viewControllers.count, count > 1 {
			visualFXView.isHidden = false
		} else {
			visualFXView.isHidden = true
		}
	}

	@IBAction func testButtonPressed(_ sender: UIButton) {
		print("tested")
	}
}
