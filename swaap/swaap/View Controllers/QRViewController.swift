//
//  QRViewController.swift
//  swaap
//
//  Created by Michael Redig on 12/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class QRViewController: UIViewController, ProfileAccessor {
	var profileController: ProfileController? {
		didSet {
			updateViews()
		}
	}

	@IBOutlet private weak var qrImageView: UIImageView!

	private func updateViews() {
		guard let id = profileController?.userProfile?.id else { return }
		guard isViewLoaded else { return }
		let data = URL(string: "https://swaap.co/qrLink/")!
			.appendingPathComponent(id)
			.absoluteString
			.data(using: .utf8)

		let filter = CIFilter(name: "CIQRCodeGenerator")
		filter?.setValue(data, forKey: "inputMessage")
		filter?.setValue("H", forKey: "inputCorrectionLevel")

		guard let image = filter?.outputImage?.convertedToCGImage else { return }

		UIGraphicsBeginImageContext(image.size * 20)
		guard let context = UIGraphicsGetCurrentContext() else { return }
		context.interpolationQuality = .none
		context.draw(image, in: CGRect(origin: .zero, size: image.size * 20))

		guard let cgimage = context.makeImage() else { return }
		let finalImage = UIImage(cgImage: cgimage)

		qrImageView.image = finalImage
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateViews()
	}
}