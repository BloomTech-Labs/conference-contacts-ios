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

	enum SocialPlatform: CaseIterable {
		case phone
		case email
		case text
		case twitter
		case linkedIn
		case instagram
		case facebook
	}

	private var contentHeightAnchor: NSLayoutConstraint?

	var height: CGFloat {
		get {
			contentHeightAnchor?.constant ?? 0
		}
		set {
			contentHeightAnchor?.constant = newValue
		}
	}

	var socialPlatform: (socialPlatform: SocialPlatform, info: String) = (.twitter, "@marlonjames") {
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
		contentHeightAnchor?.isActive = true
		handleLabel.font = .roundedFont(ofSize: handleLabel.font?.pointSize ?? 15.0, weight: .regular)

		updateSocialPlatformType()

		cornerRadius = 8
		layer.cornerCurve = .continuous
		clipsToBounds = true

		depressFadeView.isHidden = true
	}

	private func updateSocialPlatformType() {
		let platform = socialPlatform.socialPlatform
		let info = socialPlatform.info
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
		case .text:
			mainColorBackgroundView.backgroundColor = .systemBlue
			translucentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
			iconView.image = .socialTextIcon
			iconView.tintColor = .systemBlue
		case .twitter:
			mainColorBackgroundView.backgroundColor = .socialButtonTwitterMain
			translucentView.backgroundColor = .socialButtonTwitterSecondary
			iconView.image = .socialTwitterIcon
		case .linkedIn:
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
		}
		handleLabel.text = info
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
		sendActions(for: .touchDown)
		return true
	}

	override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		let location = touch.location(in: self)
		if bounds.contains(location) {
			sendActions(for: .touchDragInside)
			if !isDepressed { animateDepress() }
		} else {
			sendActions(for: .touchDragOutside)
			if isDepressed { animateRelease() }
		}
		return true
	}

	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		animateRelease()
		guard let touch = touch else { return }
		let location = touch.location(in: self)
		if bounds.contains(location) {
			sendActions(for: .touchUpInside)
		} else {
			sendActions(for: .touchUpOutside)
		}
	}

	override func cancelTracking(with event: UIEvent?) {
		animateRelease()
		sendActions(for: .touchCancel)
	}
}
