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
	var socialType: ProfileFieldType?
	let successfulCompletion: ProfileInfoNuggetCompletion
	// `floatingTextFieldView` needs to be initialized before we can pass this through
	private let enableSaveButtonHandler: FloatingTextFieldView.EnableSaveButtonHandler
	
	typealias ProfileInfoNuggetCompletion = (ProfileInfoNugget) -> Void

	init?(coder: NSCoder,
		  needsSocialTextField: Bool = true,
		  successfulCompletion: @escaping ProfileInfoNuggetCompletion,
		  enableSaveButtonHandler: @escaping FloatingTextFieldView.EnableSaveButtonHandler = { _, _ in true }) {
		self.needsSocialTextField = needsSocialTextField
		self.successfulCompletion = successfulCompletion
		self.enableSaveButtonHandler = enableSaveButtonHandler
		super.init(coder: coder)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Init coder not implemented")
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		view.accessibilityIdentifier = "InputTextFieldVC"
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
		floatingTextFieldView.makeFirstResponder(needsSocialTextField: needsSocialTextField,
												 placeholderText: placeholderStr,
												 labelText: labelText,
												 capitalizationType: autoCapitalizationType,
												 socialType: socialType)
		floatingTextFieldView.delegate = self
		tapToDismissGesture.delegate = self
		floatingTextFieldView.enableSaveButtonClosure = enableSaveButtonHandler
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		_ = floatingTextFieldView.becomeFirstResponder()
	}

	@objc func keyboardFrameWillChange(notification: NSNotification) {
		if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			let duration: NSNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber ?? 0.2

			UIView.animate(withDuration: TimeInterval(truncating: duration)) {
				self.floatingViewBottomAnchor.constant = keyboardRect.height
				self.view.layoutSubviews()
			}
		}
	}

	@IBAction func tapToDismiss(_ sender: UITapGestureRecognizer) {
		dismiss(animated: true)
	}
}

extension InputTextFieldViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return touch.view == gestureRecognizer.view
	}
}

extension InputTextFieldViewController: FloatingTextFieldViewDelegate {
	func didFinishEditing(_ view: FloatingTextFieldView, infoNugget: ProfileInfoNugget) {
		dismiss(animated: true)
		successfulCompletion(infoNugget)
	}

	func didCancelEditing(_ view: FloatingTextFieldView) {
		dismiss(animated: true)
	}
}
