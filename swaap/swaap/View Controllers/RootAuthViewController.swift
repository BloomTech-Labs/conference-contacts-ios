//
//  ViewController.swift
//  LoginHorizontalScroll
//
//  Created by Marlon Raskin on 11/12/19.
//

import UIKit
import ChevronAnimatable

protocol RootAuthViewControllerDelegate: AnyObject {
	func controllerWillScroll(_ controller: RootAuthViewController)
}

class RootAuthViewController: UIViewController {
	let profileController: ProfileController
	let authManager: AuthManager

	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var stackView: UIStackView!
	@IBOutlet private weak var loginView: UIView!
	@IBOutlet private weak var chevron: ChevronView!

	let feedback = UIImpactFeedbackGenerator(style: .rigid)
	weak var delegate: RootAuthViewControllerDelegate?

	init?(coder: NSCoder, authManager: AuthManager, profileController: ProfileController) {
		self.authManager = authManager
		self.profileController = profileController
		super.init(coder: coder)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("this vc requires an auth manager")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.isPagingEnabled = true
		scrollView.delegate = self
		updateChevron()
		feedback.prepare()

		distributeControllers()
	}

	private func distributeControllers() {
		children.forEach {
			if let delegate = $0 as? RootAuthViewControllerDelegate {
				self.delegate = delegate
			}
			if let authAccessor = $0 as? AuthAccessor {
				authAccessor.authManager = authManager
			}
			if let profileAccess = $0 as? ProfileAccessor {
				profileAccess.profileController = profileController
			}
		}
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
			chevron.curviness = CGFloat(1 - abs(normalizedCurrentValue) + 0.1)
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

extension RootAuthViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		updateChevron()
	}

	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		delegate?.controllerWillScroll(self)
	}
}
