//
//  ConnectViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/19/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, ProfileAccessor, ContactsAccessor {

	@IBOutlet private weak var connectLabel: UILabel!
	@IBOutlet private weak var swaapLogo: UIImageView!
	@IBOutlet private weak var smallProfileCard: ProfileCardView!
	@IBOutlet private weak var buttonContainer: UIView!
	@IBOutlet private weak var qrCodeButton: UIButton!
	@IBOutlet private weak var scanQRButton: UIButton!
	@IBOutlet private weak var swipeUpLabelBottomConstraint: NSLayoutConstraint!
	@IBOutlet private weak var buttonContainerBottomConstraint: NSLayoutConstraint!
	@IBOutlet private weak var instructionsLabel: UILabel!

	var profileController: ProfileController?
	var contactsController: ContactsController?

	override var prefersStatusBarHidden: Bool {
		true
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		smallProfileCard.isSmallProfileCard = true
		setupUI()
		setupProfileCard()

    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		smallProfileCard.setupImageView()
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
		qrCodeButton.layer.cornerRadius = qrCodeButton.frame.height / 2
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
	}

	private func setupProfileCard() {
		guard let profileController = profileController else { return }
		smallProfileCard.userProfile = profileController.userProfile
	}
}
