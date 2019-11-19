//
//  FormInput.swift
//  swaap
//
//  Created by Michael Redig on 11/19/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview

class FormInputView: IBPreviewView {
	@IBOutlet private var contentView: UIView!
	@IBOutlet private weak var iconImageView: UIImageView!
	@IBOutlet private weak var textField: UITextField!
	@IBOutlet private weak var bottomBorderView: UIView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	private func commonInit() {
		let nib = UINib(nibName: "FormInputView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		addSubview(contentView)
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
}
