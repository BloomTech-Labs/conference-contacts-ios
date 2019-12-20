//
//  ConnectViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/19/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, ProfileAccessor {

	@IBOutlet private weak var smallProfileCard: ProfileCardView!
	@IBOutlet private weak var qrCodeButton: UIButton!
	@IBOutlet private weak var scanQRButton: UIButton!

	var profileController: ProfileController?

    override func viewDidLoad() {
        super.viewDidLoad()
		smallProfileCard.isSmallProfileCard = true
		qrCodeButton.layer.cornerRadius = qrCodeButton.frame.height / 2
		scanQRButton.layer.cornerRadius = scanQRButton.frame.height / 2
		setupProfileCard()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		smallProfileCard.setupImageView()
	}

	private func setupProfileCard() {
		guard let profileController = profileController else { return }
		smallProfileCard.userProfile = profileController.userProfile
	}
}
