//
//  FormInput.swift
//  swaap
//
//  Created by Michael Redig on 11/19/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview

enum ValidationState {
	case pass
	case fail
	case hidden
	case custom(image: UIImage, color: UIColor)
}

@IBDesignable
class FormInputView: IBPreviewControl {
	@IBOutlet private var contentView: UIView!
	@IBOutlet private weak var iconImageView: UIImageView!
	@IBOutlet private weak var textField: UITextField!
	@IBOutlet private weak var bottomBorderView: UIView!
	@IBOutlet private weak var validationContainer: UIView!
	@IBOutlet private weak var validationImage: UIImageView!

	@IBInspectable var text: String? {
		get { textField?.text }
		set { textField?.text = newValue }
	}
	@IBInspectable var placeholderText: String? {
		get { textField?.placeholder }
		set { textField?.placeholder = newValue }
	}
	@IBInspectable var iconImage: UIImage? {
		get { iconImageView?.image }
		set { iconImageView?.image = newValue }
	}
	var keyboardType: UIKeyboardType {
		get { textField.keyboardType }
		set { textField.keyboardType = newValue }
	}
	var contentType: UITextContentType {
		get { textField.textContentType }
		set { textField.textContentType = newValue }
	}
	@IBInspectable var isSecure: Bool {
		get { textField?.isSecureTextEntry ?? false }
		set { textField?.isSecureTextEntry = newValue }
	}
	var validationState = ValidationState.hidden {
		didSet {
			updateValidationState()
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

	private func commonInit() {
		#if TARGET_INTERFACE_BUILDER
		return
		#endif
		let nib = UINib(nibName: "FormInputView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		addSubview(contentView)
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		bottomBorderView.alpha = 0

		try? forwardTargetActionsFrom(subviewControl: textField)

		updateValidationState()
	}

	private func updateValidationState() {
		validationContainer.isHidden = false
		switch validationState {
		case .pass:
			validationImage.image = UIImage(systemName: "checkmark.circle")
			validationImage.tintColor = .systemGreen
		case .fail:
			validationImage.image = UIImage(systemName: "exclamationmark.octagon")
			validationImage.tintColor = .systemRed
		case .hidden:
			validationContainer.isHidden = true
		case .custom(let image, let color):
			validationImage.image = image
			validationImage.tintColor = color
		}
	}

	// This is the only method called when light & dark mode is toggled
	override func tintColorDidChange() {
		super.tintColorDidChange()
		guard let style = window?.traitCollection.userInterfaceStyle else { return }
		switch style {
		case .dark:
			textField.keyboardAppearance = .dark
		case .light:
			textField.keyboardAppearance = .light
		default:
			break
		}
	}

	@IBAction func textFieldTouched(_ sender: UITextField) {
		fadeBorderIn()
	}

	@IBAction func textFieldFinished(_ sender: UITextField) {
		fadeBorderOut()
	}

	// MARK: - Utilities
	private func fadeBorderIn() {
		UIView.animate(withDuration: 0.5) {
			self.bottomBorderView.alpha = 1
		}
	}

	private func fadeBorderOut() {
		UIView.animate(withDuration: 0.5) {
			self.bottomBorderView.alpha = 0
		}
	}
}

extension FormInputView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
