//
//  LabelPlaceholder.swift
//  swaap
//
//  Created by Marlon Raskin on 12/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

@IBDesignable
class LabelPlaceholder: UILabel {

	private var placeholder = UILabel()

	override var intrinsicContentSize: CGSize {
		placeholder.isVisible ? placeholder.intrinsicContentSize : super.intrinsicContentSize
	}

	override var font: UIFont! {
		didSet {
			placeholder.font = font
		}
	}

	@IBInspectable
	var placeholderTextColor: UIColor {
		get { placeholder.textColor }
		set { placeholder.textColor = newValue }
	}

	@IBInspectable
	var placeholderText: String? {
		get { placeholder.text }
		set { placeholder.text = newValue }
	}

	override var text: String? {
		didSet {
			updateViews()
		}
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		commonInit()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	private func commonInit() {
		addSubview(placeholder)
		placeholder.translatesAutoresizingMaskIntoConstraints = false
		placeholder.topAnchor.constraint(equalTo: topAnchor).isActive = true
		placeholder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		placeholder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		placeholder.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

		passOnSettings()
		updateViews()
	}

	private func updateViews() {
		placeholder.isVisible = text?.isEmpty ?? true
	}

	private func passOnSettings() {
		placeholder.font = font
		placeholder.numberOfLines = numberOfLines
	}
}
