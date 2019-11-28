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
		clipsToBounds = true
		cornerRadius = 8
		layer.cornerCurve = .continuous
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

	func setSocialButton(socialPlatform: SocialPlatform) {

	}
}
