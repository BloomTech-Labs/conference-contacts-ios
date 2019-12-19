//
//  SocialButtonCollectionViewCell.swift
//  swaap
//
//  Created by Marlon Raskin on 12/6/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class SocialButtonCollectionViewCell: UICollectionViewCell {

	let socialButton: SocialButton = SocialButton()
	var socialLink: SocialLink {
		get {
			socialButton.socialInfo
		}
		set {
			socialButton.socialInfo = newValue
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	func commonInit() {
		addSubview(socialButton)
		socialButton.smallButton = true
		socialButton.translatesAutoresizingMaskIntoConstraints = false
		socialButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
		socialButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		socialButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		socialButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
}
