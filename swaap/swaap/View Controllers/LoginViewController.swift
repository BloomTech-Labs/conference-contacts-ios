//
//  ViewController.swift
//  LoginHorizontalScroll
//
//  Created by Marlon Raskin on 11/12/19.
//

import UIKit
import ChevronAnimatable

class LoginViewController: UIViewController {


	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var chevron: ChevronView!

	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.isPagingEnabled = true
		scrollView.delegate = self
		updateChevron()
	}

	private func updateChevron() {
		chevron.lineWidth = 2
		let startRotationAt = scrollView.frame.height * 0.25
		let endRotationAt = scrollView.frame.height * 0.75

		if scrollView.contentOffset.y < startRotationAt {
			chevron.pointHeight = -1
		} else if scrollView.contentOffset.y >= startRotationAt && scrollView.contentOffset.y <= endRotationAt {
			let range = endRotationAt - startRotationAt
			let currentValue = scrollView.contentOffset.y - startRotationAt
			let normalizedCurrentValue = ((currentValue / range) * 2) - 1
			chevron.pointHeight = normalizedCurrentValue
		} else {
			chevron.pointHeight = 1
		}
	}

	@IBAction func chevronTapped(_ sender: UITapGestureRecognizer) {
		if scrollView.contentOffset.y == 0 {
			let loginRect = scrollView.convert(loginView.bounds, from: loginView)
			scrollView.scrollRectToVisible(loginRect, animated: true)
		} else {
			scrollView.setContentOffset(.zero, animated: true)
		}
	}
}

extension LoginViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		updateChevron()
//		print(scrollView.contentOffset, chevronButton.transform)
	}
}
