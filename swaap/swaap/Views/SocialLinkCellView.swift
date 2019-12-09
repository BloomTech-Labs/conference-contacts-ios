//
//  SocialLinkCellView.swift
//  swaap
//
//  Created by Marlon Raskin on 12/9/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview

class SocialLinkCellView: UIView {

	@IBOutlet private weak var contentView: UIView!
	@IBOutlet private weak var cellView: UIView!
	@IBOutlet private weak var starButton: UIButton!
	@IBOutlet private weak var socialButton: SocialButton!
	@IBOutlet private weak var valueLabel: UILabel!
	@IBOutlet private weak var deleteButton: UIButton!

	var nugget: ProfileNugget {
		didSet {
			updateViews()
		}
	}

	init(frame: CGRect = CGRect(origin: .zero, size: CGSize(width: 375, height: 60)),
		 nugget: ProfileNugget) {
		self.nugget = nugget
		super.init(frame: frame)
		commonInit()
	}

	@available(*, unavailable)
	override init(frame: CGRect) {
		fatalError("Init frame not implemented")
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("Init coder not implemented")
	}

	private func commonInit() {
		#if TARGET_INTERFACE_BUILDER
		return
		#endif
		let nib = UINib(nibName: "SocialLinkCellView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.layer.masksToBounds = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		cellView.layer.cornerRadius = 20
		cellView.layer.cornerCurve = .continuous
		starButton.tintColor = .systemGray5

		self.backgroundColor = .clear

		updateViews()
	}

	private func updateViews() {
		socialButton.smallButton = true
		socialButton.socialPlatform.socialPlatform = nugget.socialType
		valueLabel.text = nugget.value
		starButton.tintColor = nugget.preferredContact ? .systemOrange : .systemGray5
	}

	@IBAction func starButtonTapped(_ sender: UIButton) {
		nugget.preferredContact.toggle()
	}

	@IBAction func deleteButtonTapped(_ sender: UIButton) {

	}

}
