//
//  SocialButton.swift
//  swaap
//
//  Created by Marlon Raskin on 11/27/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview

@IBDesignable
class SocialButton: IBPreviewControl {

	// MARK: - Properties & Outlets
	private var contentHeightAnchor: NSLayoutConstraint?

	var height: CGFloat {
		get {
			contentHeightAnchor?.constant ?? 0
		}
		set {
			contentHeightAnchor?.constant = newValue
		}
	}

	var smallButton: Bool = false {
		didSet {
			mainColorBackgroundView.isHidden = smallButton
		}
	}

	var infoNugget: ProfileInfoNugget = ProfileInfoNugget(type: .twitter, value: "@swaapApp") {
		didSet {
			updateSocialPlatformType()
		}
	}

	@IBInspectable var cornerRadius: CGFloat {
		get {
			layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}

	let twitterURL = URL(string: "https://twitter.com/")!
	let facebookURL = URL(string: "https://facebook.com/")!
	let instagramURL = URL(string: "https://instagram.com/")!
	let linkedInURL = URL(string: "https://linkedin.com/in/")!
	let emailURL = URL(string: "mailto:")!
	let phoneURL = URL(string: "tel:")!
	let smsURL = URL(string: "sms:")!

	@IBOutlet private var contentView: UIView!
	@IBOutlet private weak var mainColorBackgroundView: UIView!
	@IBOutlet private weak var translucentView: UIView!
	@IBOutlet private weak var iconView: UIImageView!
	@IBOutlet private weak var handleLabel: UILabel!
	@IBOutlet private weak var depressFadeView: UIView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	private func commonInit() {
		#if TARGET_INTERFACE_BUILDER
		return
		#endif
		let nib = UINib(nibName: "SocialButton", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		contentHeightAnchor = contentView.heightAnchor.constraint(equalToConstant: 35)
		contentHeightAnchor?.priority = UILayoutPriority(750)
		contentHeightAnchor?.isActive = true
		handleLabel.font = .rounded(from: handleLabel.font)

		updateSocialPlatformType()

		cornerRadius = 8
		layer.cornerCurve = .continuous
		clipsToBounds = true

		depressFadeView.isHidden = true
	}

	private func updateSocialPlatformType() {
		let platform = infoNugget.type
		let value = infoNugget.value
		switch platform {
		case .phone:
			mainColorBackgroundView.backgroundColor = .systemGreen
			translucentView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
			iconView.image = .socialPhoneIcon
			iconView.tintColor = .systemGreen
		case .email:
			mainColorBackgroundView.backgroundColor = .systemTeal
			translucentView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.3)
			iconView.image = .socialEmailIcon
			iconView.tintColor = .systemTeal
		case .sms:
			mainColorBackgroundView.backgroundColor = .systemBlue
			translucentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
			iconView.image = .socialTextIcon
			iconView.tintColor = .systemBlue
		case .twitter:
			mainColorBackgroundView.backgroundColor = .socialButtonTwitterMain
			translucentView.backgroundColor = .socialButtonTwitterSecondary
			iconView.image = .socialTwitterIcon
		case .linkedin:
			mainColorBackgroundView.backgroundColor = .socialButtonLinkedInMain
			translucentView.backgroundColor = .socialButtonLinkedInSecondary
			iconView.image = .socialLinkedinIcon
		case .instagram:
			mainColorBackgroundView.backgroundColor = .socialButtonInstagramMain
			translucentView.backgroundColor = .socialButtonInstagramSecondary
			iconView.image = .socialInstagramIconFill
		case .facebook:
			mainColorBackgroundView.backgroundColor = .socialButtonFacebookMain
			translucentView.backgroundColor = .socialButtonFacebookSecondary
			iconView.image = .socialFacebookIcon
		default:
			break
		}
		handleLabel.text = value
	}

	// MARK: - Helper Methods
	func openLink(infoNugget: ProfileInfoNugget) {
		guard let type = infoNugget.type else { return }
		let value = infoNugget.value
		let url: URL
		switch type {
		case .email:
			url = emailURL.appendingPathComponent(value)
		case .phone:
			url = phoneURL.appendingPathComponent(value)
		case .sms:
			url = smsURL.appendingPathComponent(value)
		case .facebook:
			url = facebookURL.appendingPathComponent(value)
		case .instagram:
			url = instagramURL.appendingPathComponent(value)
		case .linkedin:
			url = linkedInURL.appendingPathComponent(value)
		case .twitter:
			url = twitterURL.appendingPathComponent(value)
		}

		let application = UIApplication.shared
		if application.canOpenURL(url) {
			application.open(url, options: [:], completionHandler: nil)
		} else {
			print("Cannot open link with url: \(url)")
		}
	}

	// MARK: - Animation Properties
	private let animationTime = 0.07
	private var isDepressed = false

	// MARK: - Animation Logic
	private func animateDepress() {
		guard !isDepressed else { return }
		depressFadeView.isHidden = false
		depressFadeView.alpha = 0
		isDepressed = true
		UIView.animate(withDuration: animationTime) {
			let scale: CGFloat = 0.98
			self.transform = CGAffineTransform(scaleX: scale, y: scale)
			self.depressFadeView.alpha = 1
		}
	}

	private func animateRelease() {
		guard isDepressed else { return }
		depressFadeView.isHidden = false
		depressFadeView.alpha = 1
		isDepressed = false
		UIView.animate(withDuration: animationTime, animations: {
			self.transform = .identity
			self.depressFadeView.alpha = 0
		}) { _ in
			self.depressFadeView.isHidden = true
		}
	}

	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		animateDepress()
		return true
	}

	override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		if isTracking {
			animateDepress()
		} else {
			animateRelease()
		}
		return true
	}

	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		animateRelease()
		super.endTracking(touch, with: event)
	}

	override func cancelTracking(with event: UIEvent?) {
		animateRelease()
		super.cancelTracking(with: event)
	}
}
