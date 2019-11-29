//
//  ProfileCardView.swift
//  swaap
//
//  Created by Marlon Raskin on 11/22/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview
import ChevronAnimatable

@IBDesignable
class ProfileCardView: IBPreviewView {


	@IBOutlet private var contentView: UIView!
	@IBInspectable var imageCornerRadius: CGFloat = 12
	@IBOutlet private weak var profileImageView: UIImageView!
	@IBOutlet private weak var imageMaskView: UIView!
	@IBOutlet private weak var chevron: ChevronView!
	@IBOutlet private weak var leftImageOffsetConstraint: NSLayoutConstraint!
	@IBOutlet private weak var topImageOffsetConstraint: NSLayoutConstraint!
	@IBOutlet weak var stackView: UIStackView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	override func updateConstraints() {
		super.updateConstraints()
		setupImageView()
	}

	private func commonInit() {
		#if TARGET_INTERFACE_BUILDER
		return
		#endif
		let nib = UINib(nibName: "ProfileCardView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.layer.masksToBounds = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		contentView.layer.cornerCurve = .continuous
		contentView.layer.cornerRadius = 20

		setupImageView()
		profileImageView.mask = imageMaskView

		backgroundColor = .clear

		// FIXME: - just for testing - remove
		for platform in SocialButton.SocialPlatform.allCases {
			let button = SocialButton()
			button.socialPlatform = (platform, "Lorem Ipsum")
			button.translatesAutoresizingMaskIntoConstraints = false
			button.heightAnchor.constraint(equalToConstant: 35).isActive = true
			stackView.addArrangedSubview(button)
		}
	}

	private func setupImageView() {
		guard !isInterfaceBuilder else { return }
		let size = profileImageView.bounds.size * 1.25
		let position = (profileImageView.bounds.size * -0.25).toPoint
		imageMaskView.frame = CGRect(origin: position, size: size)
		imageMaskView.backgroundColor = .white
		imageMaskView.layer.cornerRadius = imageMaskView.frame.width / 2
	}

	private var slideOffset: CGFloat = 0
	private var maxTranslate: CGFloat {
		-0.9 * bounds.height
	}

	@IBAction func panGuesturePanning(_ sender: UIPanGestureRecognizer) {
		var translate = sender.translation(in: superview)

		if sender.state == .began {
			slideOffset = transform.ty
		}

		translate.y += slideOffset
		translate.y = max(maxTranslate, translate.y)
		translate.y = min(0, translate.y)
		transform.ty = translate.y

		if sender.state == .ended {
			let velocity = sender.velocity(in: self)
			if velocity.y < -550 {
				animateToTopPosition()
			} else {
				print("send back")
				animateToPrimaryPosition()
			}
			print(velocity)
		} else {
			layer.removeAllAnimations()
		}
	}

	private func animateToPrimaryPosition() {
		let range = 0...abs(maxTranslate)
		let currentProgress = range.normalizedIndex(-transform.ty)
		let duration = max(0.1, currentProgress * 0.2)
		print(duration)

		UIView.animate(withDuration: duration, delay: 0.0, options: .allowUserInteraction, animations: {
			self.transform = .identity
		}, completion: nil)
	}

	private func animateToTopPosition() {
		let range = 0...abs(maxTranslate)
		let currentProgress = range.normalizedIndex(-transform.ty)
		let duration = max(0.1, (1 - currentProgress) * 0.2)
		print(duration)

		UIView.animate(withDuration: duration, delay: 0.0, options: .allowUserInteraction, animations: {
			self.transform.ty = self.maxTranslate
		}, completion: nil)
	}
}
