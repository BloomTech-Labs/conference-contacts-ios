//
//  ConnectViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/19/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import QRettyCode

/// Originally we meant to have NFC to swap info when you swipe your card up. Definitely a good release canvas item.
class ConnectViewController: UIViewController, ProfileAccessor, ContactsAccessor {
	
	@IBOutlet private weak var connectLabel: UILabel!
	@IBOutlet private weak var swaapLogo: UIImageView!
	@IBOutlet private weak var smallProfileCard: ProfileCardView!
	@IBOutlet private weak var buttonContainer: UIView!
	@IBOutlet private weak var scanQRButton: UIButton!
	@IBOutlet private weak var swipeUpLabelBottomConstraint: NSLayoutConstraint!
	@IBOutlet private weak var buttonContainerBottomConstraint: NSLayoutConstraint!
	@IBOutlet private weak var instructionsLabel: UILabel!
	
	lazy var qrGen = QRettyCodeImageGenerator(data: self
												.profileController?
												.liveSiteBaseURL
												.absoluteString
												.data(using: .utf8),
											  correctionLevel: .H,
											  size: 212,
											  style: .dots)
	
	var profileController: ProfileController? {
		didSet {
			updateQRCode()
		}
	}
	
	var contactsController: ContactsController?

	/// '"push" notification timer - just refreshses frequently to give the appearance that there are push notifications
	/// to notifiy you when you get a request - should definitely get updated to use real push notifications

	var pushNotificationTimer: Timer?
	
	override var prefersStatusBarHidden: Bool {
		true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		smallProfileCard.isSmallProfileCard = true
		smallProfileCard.accessibilityIdentifier = "smallProfileCard"
		swaapLogo.accessibilityIdentifier = "QRCode"
		setupUI()
		updateProfileCard()
		updateQRCode()
		
		_ = NotificationCenter.default.addObserver(forName: .userProfileChanged, object: nil, queue: nil, using: { [weak self] _ in
			DispatchQueue.main.async {
				self?.updateProfileCard()
			}
		})
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		smallProfileCard.setupImageView()
		pushNotificationTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { [weak self] _ in
			self?.contactsController?.updateContactCache()
		})
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		pushNotificationTimer?.invalidate()
		pushNotificationTimer = nil
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let qrVC = segue.destination as? QRViewController {
			qrVC.profileController = profileController
		}
		
		if let swipebackVC = segue.destination as? SwipeBackNavigationController {
			swipebackVC.contactsController = contactsController
			swipebackVC.profileController = profileController
		}
	}
	
	private func setupUI() {
		[connectLabel, instructionsLabel].forEach { $0?.font = UIFont.rounded(from: $0?.font ?? UIFont()) }
		scanQRButton.layer.cornerRadius = scanQRButton.frame.height / 2
		buttonContainer.layer.cornerRadius = buttonContainer.frame.height / 2
		buttonContainer.layer.cornerCurve = .continuous
		
		smallProfileCard.layer.shadowPath = UIBezierPath(rect: smallProfileCard.bounds).cgPath
		smallProfileCard.layer.shadowRadius = 14
		smallProfileCard.layer.shadowOffset = .zero
		smallProfileCard.layer.shadowOpacity = 0.3
		
		if UIScreen.main.bounds.height <= 667 {
			swipeUpLabelBottomConstraint.constant = 40
			buttonContainerBottomConstraint.constant = 30
		}
		
		swaapLogo.translatesAutoresizingMaskIntoConstraints = false
		swaapLogo.centerYAnchor.constraint(equalTo: smallProfileCard.centerYAnchor).isActive = true
		swaapLogo.centerXAnchor.constraint(equalTo: smallProfileCard.centerXAnchor).isActive = true
		swaapLogo.widthAnchor.constraint(equalToConstant: 300).isActive = true
		swaapLogo.heightAnchor.constraint(equalTo: swaapLogo.widthAnchor, multiplier: 1).isActive = true
	}
	
	private func updateProfileCard() {
		guard let profileController = profileController else { return }
		smallProfileCard.userProfile = profileController.userProfile
	}
	
	private func updateQRCode() {
		guard let id = profileController?.userProfile?.qrCodes.first?.id else { return }
		guard isViewLoaded else { return }
		
		let data = profileController?
			.liveSiteBaseURL
			.appendingPathComponent("qrLink")
			.appendingPathComponent(id)
			.absoluteString
			.data(using: .utf8)

		// variable properties
		qrGen.data = data
		qrGen.size = swaapLogo.bounds.maxX

		// static properties
		qrGen.renderEffects = true
		qrGen.gradientStyle = .linear
		qrGen.gradientBackgroundVisible = false
		qrGen.gradientStartColor = .gradientBackgroundColorBlueTwo
		qrGen.gradientEndColor = .gradientBackgroundColorBlueOne
		qrGen.gradientStartPoint = .zero
		qrGen.gradientEndPoint = CGPoint(x: 1, y: 1)
		qrGen.iconImage = .swaapLogoIconOnly
		qrGen.iconImageScale = 0.7

		swaapLogo.image = qrGen.image
	}
}
