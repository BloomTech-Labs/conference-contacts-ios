//
//  BasicInfoView.swift
//  swaap
//
//  Created by Marlon Raskin on 12/17/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview

@IBDesignable
class BasicInfoView: IBPreviewControl {

	@IBOutlet private var contentView: UIView!
	@IBOutlet private weak var iconImageView: UIImageView!
	@IBOutlet private weak var headerLabel: UILabel!
	@IBOutlet private weak var valueLabel: LabelPlaceholder!
	@IBOutlet private weak var containerView: UIView!
	@IBOutlet private weak var containerViewHeightConstraint: NSLayoutConstraint!

	@IBInspectable
	var icon: UIImage? {
		get { iconImageView?.image }
		set {
			iconImageView?.image = newValue
			updateViews()
		}
	}

	@IBInspectable
	var headerText: String {
		get { headerLabel?.text ?? "" }
		set { headerLabel?.text = newValue.uppercased() }
	}

	var valueText: String? {
		get { valueLabel.text }
		set { valueLabel.text = newValue }
	}

	@IBInspectable
	var valuePlaceholder: String? {
		get { valueLabel?.placeholderText }
		set { valueLabel?.placeholderText = newValue }
	}

	var customSubview: UIView? {
		didSet {
			updateCustomView(oldView: oldValue)
		}
	}

	var customViewMaxHeight: CGFloat? {
		get {
			guard containerViewHeightConstraint.isActive else { return nil }
			return containerViewHeightConstraint.constant
		}
		set {
			guard let newValue = newValue else {
				containerViewHeightConstraint.isActive = false
				return
			}
			containerViewHeightConstraint.constant = newValue
		}
	}

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
		let nib = UINib(nibName: "BasicInfoView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.layer.masksToBounds = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		self.backgroundColor = .clear

		updateViews()
	}

	private func updateCustomView(oldView: UIView?) {
		oldView?.removeFromSuperview()
		guard let customView = customSubview else {
			containerView.isHidden = true
			return
		}
		containerView.isVisible = true
		customView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(customView)
		[customView.topAnchor.constraint(equalTo: containerView.topAnchor),
		 customView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
		 customView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
		 customView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
			].forEach { $0.isActive = true }
	}

	private func updateViews() {
		guard !isInterfaceBuilder else { return }
		iconImageView.isVisible = icon != nil
	}
}
