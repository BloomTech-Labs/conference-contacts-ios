//
//  InputTextFieldViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class InputTextFieldViewController: UIViewController, Storyboarded {

	@IBOutlet private weak var floatingTextFieldView: FloatingTextFieldView!
	@IBOutlet private weak var floatingViewBottomAnchor: NSLayoutConstraint!
	@IBOutlet private var tapToDismissGesture: UITapGestureRecognizer!

	let needsSocialTextField: Bool
	var autoCapitalizationType: UITextAutocapitalizationType = .sentences
	var placeholderStr: String = "enter info"
	var labelText: String?
	let successfulCompletion: SocialLinkCompletion
	typealias SocialLinkCompletion = (SocialLink) -> Void

	init?(coder: NSCoder, needsSocialTextField: Bool = true, successfulCompletion: @escaping SocialLinkCompletion) {
		self.needsSocialTextField = needsSocialTextField
		self.successfulCompletion = successfulCompletion
		super.init(coder: coder)
	}

	required init?(coder: NSCoder) {
		fatalError("Init coder not implemented")
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		floatingTextFieldView.makeFirstResponder(needsSocialTextField, placeholderStr, labelText: labelText, capitalizationType: autoCapitalizationType)
		floatingTextFieldView.delegate = self

		tapToDismissGesture.delegate = self
	}

	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			floatingViewBottomAnchor.constant = keyboardRect.height
		}
	}

	@objc func keyboardWillHide(notification: NSNotification) {

		dismiss(animated: true)
	}

	@IBAction func tapToDismiss(_ sender: UITapGestureRecognizer) {
		floatingTextFieldView.fireFirstResponder()
		dismiss(animated: true)
	}
}

extension InputTextFieldViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return touch.view == gestureRecognizer.view
	}
}

extension InputTextFieldViewController: FloatingTextFieldViewDelegate {
	func didFinishEditing(_ view: FloatingTextFieldView, socialLink: SocialLink) {
		successfulCompletion(socialLink)
	}
}
