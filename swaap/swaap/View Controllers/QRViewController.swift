//
//  QRViewController.swift
//  swaap
//
//  Created by Michael Redig on 12/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import CoreLocation
import QRettyCode

class QRViewController: UIViewController, ProfileAccessor {
	private static let baseURL: URL = {
		if ReleaseState.current == .appStore {
			return URL(string: "https://swaap.co/")!
		} else {
			return URL(string: "https://staging.swaap.co/")!
		}
	}()

	lazy var qrGen = QRettyCodeImageGenerator(data: QRViewController
		.baseURL
		.absoluteString
		.data(using: .utf8), correctionLevel: .H, size: 212, style: .dots)

	var profileController: ProfileController? {
		didSet {
			updateViews()
		}
	}

	@IBOutlet private weak var qrImageView: UIImageView!

	var locationManager: LocationHandler? {
		profileController?.locationManager
	}

	private func updateViews() {
		guard let id = profileController?.userProfile?.qrCodes.first?.id else { return }
		guard isViewLoaded else { return }
		let data = QRViewController.baseURL
			.appendingPathComponent("qrLink")
			.appendingPathComponent(id)
			.absoluteString
			.data(using: .utf8)

		// variable properties
		qrGen.data = data
		qrGen.size = qrImageView.bounds.maxX

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

		qrImageView.image = qrGen.image
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateViews()
		locationManager?.startTrackingLocation()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		locationManager?.stopTrackingLocation()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager?.requestAuth()
	}
}
