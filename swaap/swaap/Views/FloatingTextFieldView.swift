//
//  FloatingTextFieldView.swift
//  swaap
//
//  Created by Marlon Raskin on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview

class FloatingTextFieldView: IBPreviewView {
	
	@IBOutlet private var contentView: UIView!
	@IBOutlet private weak var textField: UITextField!
	@IBOutlet private weak var socialButton: SocialButton!
	@IBOutlet private weak var separator: UIView!
	@IBOutlet private weak var horizontalSeparator: UIView!
	/// "@" symbol ("aapstert" means monkey tail in Afrikaans)
	@IBOutlet private weak var aapstertSymbol: UILabel!
	@IBOutlet private weak var cancelButton: ButtonHelper!
	@IBOutlet private weak var saveButton: ButtonHelper!

	var socialType: SocialButton.SocialPlatform = .email {
		didSet {
			socialButton.socialPlatform = (socialType, "")
			shouldShowAtSymbol()
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
		let nib = UINib(nibName: "FloatingTextFieldView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.layer.masksToBounds = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		socialButton.smallButton = true
		socialButton.socialPlatform = (socialType, "")
		horizontalSeparator.backgroundColor = .systemGray5

		self.backgroundColor = .clear
	}

	@objc func hideKeyboardAction() {
		textField.resignFirstResponder()
	}

	private func shouldShowAtSymbol() {
		switch socialType {
		case .email:
			showHideAtSymbol(false)
		case .facebook:
			showHideAtSymbol(true)
		case .instagram:
			showHideAtSymbol(true)
		case .linkedIn:
			showHideAtSymbol(false)
		case .phone:
			showHideAtSymbol(false)
		case .text:
			showHideAtSymbol(false)
		case .twitter:
			showHideAtSymbol(true)
		}
	}

	private func showHideAtSymbol(_ shouldShowSymbol: Bool) {
		if shouldShowSymbol {
			UIView.animate(withDuration: 0.3) {
				self.aapstertSymbol.isHidden = true
			}
		} else {
			UIView.animate(withDuration: 0.3) {
				self.aapstertSymbol.isHidden = false
			}
		}
	}

	func setupFirstResponder() {
		textField.becomeFirstResponder()
	}

	@IBAction func cancelTapped(_ sender: ButtonHelper) {

	}

	@IBAction func saveTapped(_ sender: ButtonHelper) {

	}
}
