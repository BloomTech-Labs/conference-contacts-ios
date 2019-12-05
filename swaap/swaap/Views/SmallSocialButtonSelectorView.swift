//
//  SmallSocialButtonSelectorView.swift
//  swaap
//
//  Created by Marlon Raskin on 12/5/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview

class SmallSocialButtonSelectorView: IBPreviewView {

	@IBOutlet private var contentView: UIView!

	@IBOutlet private weak var phoneButton: SocialButton!
	@IBOutlet private weak var textButton: SocialButton!
	@IBOutlet private weak var emailButton: SocialButton!
	@IBOutlet private weak var linkedInButton: SocialButton!
	@IBOutlet private weak var twitterButton: SocialButton!
	@IBOutlet private weak var facebookButton: SocialButton!
	@IBOutlet private weak var instagramButton: SocialButton!

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		#if TARGET_INTERFACE_BUILDER
		return
		#endif
		let nib = UINib(nibName: "SmallSocialButtonSelectorView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		[phoneButton, textButton, emailButton, linkedInButton, twitterButton, facebookButton, instagramButton].forEach { $0?.smallButton = true }

		layer.cornerRadius = 20
		layer.cornerCurve = .continuous

		self.backgroundColor = .clear

	}
}
