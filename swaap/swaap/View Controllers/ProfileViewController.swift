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
	@IBOutlet private weak var birthdayImageContainerView: UIView!
	@IBOutlet private weak var bioImageViewContainer: UIView!
	@IBOutlet private weak var contactModesImageViewContainer: UIView!

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
		setupNotifications()
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

		birthdayImageContainerView.isVisible = birthdayLabel.text?.isEmpty ?? true
		bioImageViewContainer.isVisible = bioLabel.text?.isEmpty ?? true
		contactModesImageViewContainer.isVisible = birthdayLabel.text?.isEmpty ?? true

		socialButtonsStackView.isHidden = socialButtonsStackView.arrangedSubviews.isEmpty
	}

	private func populateSocialButtons() {
		guard let profileNuggets = profileController?.userProfile?.profileContactMethods else { return }
		socialButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		profileNuggets.forEach {
			guard !$0.preferredContact else { return }
			let socialButton = SocialButton()
			socialButton.infoNugget = ProfileInfoNugget(type: $0.type, value: $0.value)
			socialButton.translatesAutoresizingMaskIntoConstraints = false
			socialButton.height = 50
			socialButton.setContentHuggingPriority(.init(rawValue: 251), for: .vertical)
			socialButtonsStackView.addArrangedSubview(socialButton)
		}
	}

	private func setupNotifications() {
		let updateClosure = { (_: Notification) in
			DispatchQueue.main.async {
				self.updateViews()
			}
		}
		profileChangedObserver = NotificationCenter.default.addObserver(forName: .userProfileChanged, object: nil, queue: nil, using: updateClosure)
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

	@IBSegueAction func editButtonTappedSegue(_ coder: NSCoder) -> UINavigationController? {
		return SwipeBackNavigationController(coder: coder, profileController: profileController)
	}
	
}
