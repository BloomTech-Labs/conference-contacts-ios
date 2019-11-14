//
//  SignUpViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 11/14/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController {


	@IBOutlet private weak var nameTextField: UITextField!
	@IBOutlet private weak var nameLine: UIView!
	@IBOutlet private weak var emailTextField: UITextField!
	@IBOutlet private weak var emailLine: UIView!
	@IBOutlet private weak var passwordTextField: UITextField!
	@IBOutlet private weak var passwordLine: UIView!
	@IBOutlet private weak var passwordButton: UIButton!
	@IBOutlet private weak var signupButton: UIButton!
	@IBOutlet private weak var mainStackView: UIStackView!

	override func viewDidLoad() {
        super.viewDidLoad()
		[nameTextField, emailTextField, passwordTextField].forEach { $0?.delegate = self }
		[nameLine, emailLine, passwordLine, passwordButton].forEach { $0?.alpha = 0 }
		signupButton.layer.cornerRadius = 8
		signupButton.layer.cornerCurve = .continuous
		signupButton.backgroundColor = UIColor(red: 0.40, green: 0.45, blue: 0.88, alpha: 1.00)
    }

	@IBAction func signUpTapped(_ sender: UIButton) {
		animateSignUpbutton()
	}

	private func animateTextFieldLines(textField: UITextField, line: UIView) {
		if textField.becomeFirstResponder() {
			UIView.animate(withDuration: 0.3) {
				line.isHidden = false
			}
		} else if textField.resignFirstResponder() {
			UIView.animate(withDuration: 0.3) {
				line.isHidden = true
			}
		}
	}

	private func animateSignUpbutton() {
		if signupButton.isHighlighted {
			UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0, options: [.allowUserInteraction], animations: {
				self.signupButton.transform = self.signupButton.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
			}, completion: nil)
		}
	}
}

extension SignUpViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == nameTextField {
			UIView.animate(withDuration: 0.5) {
				self.nameLine.alpha = 1
			}
		} else if textField == emailTextField {
			UIView.animate(withDuration: 0.5) {
				self.emailLine.alpha = 1
			}
		} else {
			UIView.animate(withDuration: 0.5) {
				self.passwordLine.alpha = 1
				self.passwordButton.alpha = 1
			}
		}
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == nameTextField {
			UIView.animate(withDuration: 0.5) {
				self.nameLine.alpha = 0
			}
		} else if textField == emailTextField {
			UIView.animate(withDuration: 0.5) {
				self.emailLine.alpha = 0
			}
		} else {
			UIView.animate(withDuration: 0.5) {
				self.passwordLine.alpha = 0
				self.passwordButton.alpha = 0
			}
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
	}
}
