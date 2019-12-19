//
//  FloatingTextFieldView.swift
//  swaap
//
//  Created by Marlon Raskin on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview

protocol FloatingTextFieldViewDelegate: AnyObject {
	func didFinishEditing(_ view: FloatingTextFieldView, socialLink: SocialLink)
}

class FloatingTextFieldView: IBPreviewView, UICollectionViewDelegate, UICollectionViewDataSource {

	// MARK: - Outlets & Properties
	@IBOutlet private var contentView: UIView!
	@IBOutlet private weak var textField: UITextField!
	@IBOutlet private weak var socialButton: SocialButton!
	@IBOutlet private weak var plusButton: UIButton!
	@IBOutlet private weak var separator: UIView!
	@IBOutlet private weak var horizontalSeparator: UIView!
	@IBOutlet private weak var aapstertSymbol: UILabel!
	@IBOutlet private weak var cancelButton: ButtonHelper!
	@IBOutlet private weak var saveButton: ButtonHelper!
	@IBOutlet private weak var collectionView: UICollectionView!

	var socialType: ProfileFieldType? {
		didSet {
			updateViews()
		}
	}

	weak var delegate: FloatingTextFieldViewDelegate?

	// MARK: - Init
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

		horizontalSeparator.backgroundColor = .systemGray5

		aapstertSymbol.isHidden = true
		collectionView.isHidden = true
		socialButton.isHidden = true
		saveButton.isEnabled = false
		saveButton.alpha = 0.6
		socialButton.smallButton = true

		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(SocialButtonCollectionViewCell.self, forCellWithReuseIdentifier: "SocialButtonCell")

		self.backgroundColor = .clear
	}

	override func becomeFirstResponder() -> Bool {
		textField.becomeFirstResponder()
	}

	@objc func hideKeyboardAction() {
		textField.resignFirstResponder()
	}

	// MARK: - Textfield Formatting
	private func formatTextField() {
		guard let socialType = socialType else { return }
		switch socialType {
		case .email:
			textField.placeholder = "add an email address"
			changeKeyboard(type: .emailAddress)
		case .facebook:
			textField.placeholder = "add your Facebook username"
			changeKeyboard(type: .default)
		case .instagram:
			textField.placeholder = "add your Instagram username"
			changeKeyboard(type: .default)
		case .linkedin:
			textField.placeholder = "add your LinkedIn username"
			changeKeyboard(type: .default)
		case .phone:
			textField.placeholder = "add a phone number"
			changeKeyboard(type: .numberPad)
		case .sms:
			textField.placeholder = "add a phone number"
			changeKeyboard(type: .numberPad)
		case .twitter:
			textField.placeholder = "add your Twitter handle"
			changeKeyboard(type: .twitter)
		}
	}

	lazy var dummyTextField: UITextField = {
		let dummyTextField = UITextField()
		superview?.addSubview(dummyTextField)
		dummyTextField.isHidden = true
		return dummyTextField
	}()

	private func changeKeyboard(type: UIKeyboardType) {
		dummyTextField.keyboardType = type
		dummyTextField.becomeFirstResponder()
		textField.keyboardType = type
		textField.becomeFirstResponder()
	}


	// MARK: - IBActions
	@IBAction func textFieldDidChange(_ sender: UITextField) {
		if textField.text?.isEmpty == false {
			saveButton.isEnabled = true
			saveButton.alpha = 1
		} else {
			saveButton.isEnabled = false
			saveButton.alpha = 0.6
		}
	}

	@IBAction func cancelTapped(_ sender: ButtonHelper) {
		fireFirstResponder()
	}

	@IBAction func saveTapped(_ sender: ButtonHelper) {
		guard let text = textField.text else { return }
		delegate?.didFinishEditing(self, socialLink: SocialLink(socialType: socialType, value: text))
		fireFirstResponder()
	}

	@IBAction func addChangeSocialButton(_ sender: UIControl) {
		shouldShowCollectionView(!collectionView.isVisible)
	}


	// MARK: - Helper Methods
	private func updateViews() {
		shouldShowAtSymbol()
		formatTextField()
		if let socialType = socialType {
			socialButton.isVisible = true
			socialButton.socialInfo.socialType = socialType
		} else {
			socialButton.isVisible = false
		}
		plusButton.isVisible = !socialButton.isVisible
		plusButton.isEnabled = plusButton.isVisible
	}

	func makeFirstResponder(needsSocialTextField: Bool,
							placeholderText: String,
							labelText: String?,
							capitalizationType: UITextAutocapitalizationType,
							socialType: ProfileFieldType?) {
		textField.text = labelText
		textField.autocapitalizationType = capitalizationType
		textField.becomeFirstResponder()
		self.socialType = socialType
		if !needsSocialTextField {
			hideAllSocialElements()
			textField.placeholder = placeholderText
		}
	}

	func fireFirstResponder() {
		textField.resignFirstResponder()
	}

	private func hideAllSocialElements() {
		showAtSymbol(false)
		plusButton.isHidden = true
		socialButton.isHidden = true
		separator.isHidden = true
	}

	private func shouldShowAtSymbol() {
		guard let socialType = socialType else {
			showAtSymbol(false)
			return
		}

		switch socialType {
		case .instagram, .twitter:
			showAtSymbol(true)
		default:
			showAtSymbol(false)
		}
	}

	private func showAtSymbol(_ shouldShowSymbol: Bool) {
		if shouldShowSymbol {
			UIView.animate(withDuration: 0.3) {
				self.aapstertSymbol.isVisible = true
			}
		} else {
			UIView.animate(withDuration: 0.3) {
				self.aapstertSymbol.isVisible = false
			}
		}
	}

	private func shouldShowCollectionView(_ show: Bool) {
		UIView.animate(withDuration: 0.3) {
			self.collectionView.isVisible = show
			self.collectionView.superview?.layoutSubviews()
		}
		let image: UIImage?
		if self.collectionView.isVisible {
			image = UIImage(systemName: "minus.square.fill")
		} else {
			image = UIImage(systemName: "plus.app.fill")
		}
		plusButton.setImage(image, for: .normal)
	}


	// MARK: - CollectionView Methods

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return ProfileFieldType.allCases.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialButtonCell",
														for: indexPath) as? SocialButtonCollectionViewCell else { return UICollectionViewCell() }

		cell.socialLink.socialType = ProfileFieldType.allCases[indexPath.item]
		cell.socialButton.addTarget(self, action: #selector(didSelectSocialButton(_:)), for: .touchUpInside)
		return cell
	}

	@objc func didSelectSocialButton(_ sender: SocialButton) {
		socialType = sender.socialInfo.socialType
		shouldShowCollectionView(false)
	}
}
