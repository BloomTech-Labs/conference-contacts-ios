//
//  ProfileCardView.swift
//  swaap
//
//  Created by Marlon Raskin on 11/22/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview
import ChevronAnimatable

@IBDesignable
class ProfileCardView: IBPreviewView {


	@IBOutlet private var contentView: UIView!
	@IBInspectable var imageCornerRadius: CGFloat = 12
	@IBOutlet private weak var profileImageView: UIImageView!
	@IBOutlet private weak var chevron: ChevronView!
	@IBOutlet private weak var leftImageOffsetConstraint: NSLayoutConstraint!
	@IBOutlet private weak var topImageOffsetConstraint: NSLayoutConstraint!
	@IBOutlet weak var stackView: UIStackView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	override func updateConstraints() {
		let constant = bounds.width * 0.214
		leftImageOffsetConstraint?.constant = constant
		topImageOffsetConstraint?.constant = -constant
		super.updateConstraints()
		setupImageView()
	}

	private func commonInit() {
		#if TARGET_INTERFACE_BUILDER
		return
		#endif
		let nib = UINib(nibName: "ProfileCardView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.layer.masksToBounds = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		setupImageView()

		for platform in SocialButton.SocialPlatform.allCases {
			let button = SocialButton()
			button.socialPlatform = (platform, "Lorem Ipsum")
			button.translatesAutoresizingMaskIntoConstraints = false
			button.heightAnchor.constraint(equalToConstant: 35).isActive = true
			stackView.addArrangedSubview(button)
		}
	}

	private func setupImageView() {
		profileImageView?.layer.cornerRadius = profileImageView.frame.width / 2
	}

	@IBAction func socialButtonTapped(_ sender: UIButton) {
		
	}
}
