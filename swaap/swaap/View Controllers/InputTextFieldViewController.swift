//
//  InputTextFieldViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class InputTextFieldViewController: UIViewController {

	@IBOutlet private weak var floatingTextFieldView: FloatingTextFieldView!
	@IBOutlet private weak var floatingViewBottomAnchor: NSLayoutConstraint!
	@IBOutlet private var tapToDismissGesture: UITapGestureRecognizer!


	override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		floatingTextFieldView.makeFirstResponder()

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
