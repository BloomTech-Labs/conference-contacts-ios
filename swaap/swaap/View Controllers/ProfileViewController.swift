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
	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var backButtonVisualFXContainerView: UIVisualEffectView!
	@IBOutlet private weak var editProfileButtonVisualFXContainerView: UIVisualEffectView!
	@IBOutlet private weak var backButton: UIButton!
	@IBOutlet private weak var socialButtonsStackView: UIStackView!
	@IBOutlet private weak var birthdayLabel: UILabel!
	@IBOutlet private weak var bioLabel: UILabel!
	@IBOutlet private weak var locationViewContainer: UIView!
	@IBOutlet private weak var locationView: BasicInfoView!
	@IBOutlet private weak var birthdayImageContainerView: UIView!
	@IBOutlet private weak var bioImageViewContainer: UIView!
	@IBOutlet private weak var contactModePreviewStackView: UIStackView!
	@IBOutlet private weak var bottomFadeView: UIView!
	@IBOutlet private weak var bottomFadeviewBottomConstraint: NSLayoutConstraint!

	var profileController: ProfileController?
	var profileChangedObserver: NSObjectProtocol?

	override var prefersStatusBarHidden: Bool {
		profileCardView?.isAtTop ?? false
	}

	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		.slide
	}

	var userProfile: UserProfile? {
		didSet { updateViews() }
	}
	var isCurrentUser = false

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.delegate = self

		configureProfileCard()
		setupCardShadow()
		setupFXView()
		updateViews()
		setupNotifications()

		if UIScreen.main.bounds.height <= 667 {
			locationViewContainer.isHidden = false
		} else {
			locationViewContainer.isHidden = true
		}

		if let appearance = tabBarController?.tabBar.standardAppearance.copy() {
			appearance.backgroundImage = UIImage()
			appearance.shadowImage = UIImage()
			appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
			appearance.shadowColor = .clear
			tabBarItem.standardAppearance = appearance
		}
		updateFadeViewPosition()
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
		profileCardView.setupImageView()
		updateViews()
		tabBarController?.delegate = self
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		tabBarController?.delegate = nil
	}

	private func configureProfileCard() {
		profileCardView.layer.cornerRadius = 20
		profileCardView.layer.cornerCurve = .continuous
		profileCardView.delegate = self
	}

	private func updateViews() {
		guard isViewLoaded else { return }
		profileCardView.userProfile = userProfile
		birthdayLabel.text = userProfile?.birthdate
		bioLabel.text = userProfile?.bio

		locationView.valueText = userProfile?.location
		locationView.customSubview = nil


		editProfileButtonVisualFXContainerView.isVisible = isCurrentUser

		populateSocialButtons()
		if let count = navigationController?.viewControllers.count, count > 1 {
			backButtonVisualFXContainerView.isHidden = false
		} else {
			backButtonVisualFXContainerView.isHidden = true
		}

		birthdayImageContainerView.isVisible = birthdayLabel.text?.isEmpty ?? true
		bioImageViewContainer.isVisible = bioLabel.text?.isEmpty ?? true

		socialButtonsStackView.isHidden = socialButtonsStackView.arrangedSubviews.isEmpty
		contactModePreviewStackView.isHidden = !socialButtonsStackView.arrangedSubviews.isEmpty

		if !isCurrentUser, userProfile?.photoData == nil, let imageURL = userProfile?.pictureURL {
			profileController?.fetchImage(url: imageURL, completion: { [weak self] result in
				do {
					let imageData = try result.get()
					DispatchQueue.main.async {
						self?.userProfile?.photoData = imageData
					}
				} catch {
					NSLog("Error updating contact image: \(error)")
				}
			})
		}
	}

	private func populateSocialButtons() {
		guard let profileContactMethods = userProfile?.profileContactMethods else { return }
		socialButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		profileContactMethods.forEach {
			guard !$0.preferredContact else { return }
			let contactMethodCell = ContactMethodCellView(contactMethod: $0, mode: .display)
			contactMethodCell.contactMethod = $0
			socialButtonsStackView.addArrangedSubview(contactMethodCell)
		}
	}

	private func setupNotifications() {
		guard isCurrentUser else { return }
		let updateClosure = { [weak self] (_: Notification) in
			DispatchQueue.main.async {
				guard self?.isCurrentUser == true else { return }
				self?.userProfile = self?.profileController?.userProfile
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

	// MARK: - Actions
	@IBAction func backbuttonTapped(_ sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}

	@IBSegueAction func editButtonTappedSegue(_ coder: NSCoder) -> UINavigationController? {
		return SwipeBackNavigationController(coder: coder, profileController: profileController)
	}
}

extension ProfileViewController: ProfileCardViewDelegate {
	func updateFadeViewPosition() {
		let currentProgress = max(profileCardView.currentSlidingProgress, 0)
		bottomFadeviewBottomConstraint.constant = CGFloat(currentProgress * -120)
	}

	func profileCardDidFinishAnimation(_ card: ProfileCardView) {
		UIView.animate(withDuration: 0.3) {
			self.setNeedsStatusBarAppearanceUpdate()
		}
	}

	func positionDidChange(on view: ProfileCardView) {
		updateFadeViewPosition()
	}
}

extension ProfileViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y <= -120 {
			scrollView.isScrollEnabled = false
			HapticFeedback.produceRigidFeedback()
			profileCardView.animateToPrimaryPosition()
			scrollView.isScrollEnabled = true
		}
	}
}

extension ProfileViewController: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		guard viewController == self.navigationController else { return }
		profileController?.fetchProfileFromServer(completion: { _ in })
	}
}
