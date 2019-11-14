//
//  ViewController.swift
//  LoginHorizontalScroll
//
//  Created by Marlon Raskin on 11/12/19.
//

import UIKit

class LoginViewController: UIViewController {


	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var chevronButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.isPagingEnabled = true
		scrollView.delegate = self
	}

	@IBAction func chevronTapped(_ sender: UIButton) {
		let loginRect = scrollView.convert(loginView.bounds, from: loginView)
		scrollView.scrollRectToVisible(loginRect, animated: true)
	}
}

extension LoginViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let startRotationAt = scrollView.frame.height * 0.45
		let endRotationAt = scrollView.frame.height * 0.55


		if scrollView.contentOffset.y < startRotationAt {
			chevronButton.transform = CGAffineTransform(rotationAngle: 0)
		} else if scrollView.contentOffset.y >= startRotationAt && scrollView.contentOffset.y <= endRotationAt {
			let total = endRotationAt - startRotationAt
			let currentValue = scrollView.contentOffset.y - startRotationAt
			let normalizedCurrentValue = currentValue / total
			let radians = normalizedCurrentValue * CGFloat.pi
			chevronButton.transform = CGAffineTransform(rotationAngle: radians)
		} else {
			chevronButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
		}
		print(scrollView.contentOffset, chevronButton.transform)
	}
}
