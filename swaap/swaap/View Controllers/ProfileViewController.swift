//
//  ProfileViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 11/22/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, Storyboarded, ProfileAccessor {

	@IBOutlet private weak var profileCardView: ProfileCardView!
	@IBOutlet private weak var backButtonVisualFXContainerView: UIVisualEffectView!
	@IBOutlet private weak var editProfileButtonVisualFXContainerView: UIVisualEffectView!
	@IBOutlet private weak var backButton: UIButton!
	@IBOutlet private weak var socialButtonsStackView: UIStackView!
	@IBOutlet private weak var birthdayLabel: UILabel!
	@IBOutlet private weak var bioLabel: UILabel!

	var profileController: ProfileController?
	var profileChangedObserver: NSObjectProtocol?

	// Recommended size for Social Buttons in stack view is w 250 / h 40
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

	private func updateViews() {
		profileCardView.userProfile = profileController?.userProfile
		birthdayLabel.text = profileController?.userProfile?.birthdate
		bioLabel.text = profileController?.userProfile?.bio
		populateSocialButtons()

		if let count = navigationController?.viewControllers.count, count > 1 {
			backButtonVisualFXContainerView.isHidden = false
		} else {
			backButtonVisualFXContainerView.isHidden = true
		}

		if socialButtonsStackView.arrangedSubviews.count < 1 {
			socialButtonsStackView.isHidden = true
		}
	}

	private func populateSocialButtons() {
		guard let profileNuggets = profileController?.userProfile?.profileNuggets else { return }
		profileNuggets.forEach {
			let socialButton = SocialButton()
			socialButton.socialInfo = ($0.type, $0.value)
			socialButton.translatesAutoresizingMaskIntoConstraints = false
			socialButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
			socialButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
			socialButtonsStackView.addArrangedSubview(socialButton)
		}
	}

	private func setupNotifications() {
		profileChangedObserver = NotificationCenter.default.addObserver(forName: .userProfileChanged, object: nil, queue: nil, using: { _ in
			self.updateViews()
		})
	}

	private func setupCardShadow() {
		profileCardView.layer.shadowPath = UIBezierPath(rect: profileCardView.bounds).cgPath
		profileCardView.layer.shadowRadius = 14
		profileCardView.layer.shadowOffset = .zero
		profileCardView.layer.shadowOpacity = 0.3
	}

	private func setupFXView() {
		backButtonVisualFXContainerView.layer.cornerRadius = backButtonVisualFXContainerView.frame.height / 2
		backButtonVisualFXContainerView.clipsToBounds = true
		editProfileButtonVisualFXContainerView.layer.cornerRadius = editProfileButtonVisualFXContainerView.frame.height / 2
		editProfileButtonVisualFXContainerView.clipsToBounds = true
	}

	@IBAction func backbuttonTapped(_ sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}
}
