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

protocol ProfileCardViewDelegate: AnyObject {
	func positionDidChange(on view: ProfileCardView)
	func profileCardDidFinishAnimation(_ card: ProfileCardView)
}

@IBDesignable
class ProfileCardView: IBPreviewView {

	// MARK: - User Info Properties
	var userProfile: UserProfile? {
		didSet {
			updateViews()
		}
	}

	var profileImage: UIImage? {
		get { profileImageView.image }
		set { profileImageView.image = newValue }
	}

	var name: String? {
		get { nameLabel.text }
		set { nameLabel.text = newValue }
	}

	var tagline: String? {
		get { taglineLabel.text }
		set { taglineLabel.text = newValue }
	}

	var jobTitle: String? {
		get { jobTitleLabel.text }
		set { jobTitleLabel.text = newValue }
	}

	var location: String? {
		get { locationLabel.text }
		set { locationLabel.text = newValue }
	}

	var industry: String? {
		get { industryLabel.text }
		set { industryLabel.text = newValue }
	}

	var preferredContact: ProfileInfoNugget? {
		get { socialButton.infoNugget }
		set {
			guard let newValue = newValue else { return }
			socialButton.infoNugget = newValue
		}
	}

	var isSmallProfileCard: Bool? {
		didSet {
			setupSmallCardVersion()
		}
	}

	weak var delegate: ProfileCardViewDelegate?


	// MARK: - Outlets
	@IBOutlet private var contentView: UIView!
	@IBInspectable var imageCornerRadius: CGFloat = 12
	@IBOutlet private weak var profileImageView: UIImageView!
	@IBOutlet private weak var imageMaskView: UIView!
	@IBOutlet private weak var chevron: ChevronView!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var jobTitleLabel: UILabel!
	@IBOutlet private weak var taglineContainer: UIView!
	@IBOutlet private weak var taglineLabel: UILabel!
	@IBOutlet private weak var locationLabel: UILabel!
	@IBOutlet private weak var industryLabel: UILabel!
	@IBOutlet private weak var socialButton: SocialButton!
	@IBOutlet private weak var locationStackView: UIStackView!
	@IBOutlet private weak var industryStackView: UIStackView!
	@IBOutlet private weak var lackOfInfoDescLabel: UILabel!


	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	private func commonInit() {
		guard !isInterfaceBuilder else { return }
		let nib = UINib(nibName: "ProfileCardView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		locationStackView.isVisible = UIScreen.main.bounds.height > 667

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.layer.masksToBounds = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		contentView.layer.cornerCurve = .continuous
		contentView.layer.cornerRadius = 20

		profileImageView.mask = imageMaskView
		setupImageView()

		backgroundColor = .clear

		updateViews()
	}

	/// This should be private and should be inherently called by resizing the view, but it's not.
	/// Call externally if needed for different size profilecardViews
	func setupImageView() {
		guard !isInterfaceBuilder else { return }
		guard profileImageView != nil else { return }
		let size = profileImageView.bounds.size * 1.25
		let position = CGPoint(x: 0, y: profileImageView.bounds.height * -0.25)
		imageMaskView.frame = CGRect(origin: position, size: size)
		imageMaskView.backgroundColor = .white
		imageMaskView.layer.cornerRadius = imageMaskView.frame.width / 2
	}

	private func setupSmallCardVersion() {
		guard let isSmallVersion = isSmallProfileCard else { return }
		if isSmallVersion {
			[socialButton,
			 jobTitleLabel,
			 locationStackView,
			 taglineContainer,
			 industryStackView].forEach { $0.isHidden = true }
		}
	}

	private func updateViews() {
		if let imageData = userProfile?.photoData {
			profileImage = UIImage(data: imageData)
		} else {
			profileImage = nil
		}
		name = userProfile?.name
		jobTitle = userProfile?.jobTitle
		location = userProfile?.location
		industry = userProfile?.industry
		tagline = userProfile?.tagline

		lackOfInfoDescLabel.isHidden = true
		hideUnhideElements()

		guard let pContact = userProfile?.profileContactMethods.preferredContact else { return }
		let nuggetInfo = ProfileInfoNugget(type: pContact.type, value: pContact.value)
		preferredContact = nuggetInfo
	}

	private func hideUnhideElements() {
		guard isSmallProfileCard == false else { return }
		jobTitleLabel.isVisible = jobTitle?.isNotEmpty ?? false
		industryStackView.isVisible = industry?.isNotEmpty ?? false
		taglineContainer.isVisible = tagline?.isNotEmpty ?? false
		locationStackView.isVisible = (location?.isNotEmpty ?? false) && (UIScreen.main.bounds.height > 667)

		lackOfInfoDescLabel.isVisible = [locationStackView, taglineContainer, industryStackView, jobTitleLabel].reduce(true) {
			($1?.isHidden ?? true) && $0
		}

		let name = userProfile?.name ?? "This user"
		lackOfInfoDescLabel.text = "\(name) hasn't added any info yet."
	}

	@IBAction func socialButtonTapped(_ sender: SocialButton) {
		sender.openLink()
	}

	// MARK: - Pan Gesture properties
	private var slideOffset: CGFloat = 0
	private var maxTranslate: CGFloat {
		-0.9 * bounds.height
	}

	var isAtTop: Bool = false {
		didSet {
			delegate?.profileCardDidFinishAnimation(self)
		}
	}

	private let swipeVelocity: CGFloat = 550
	/// 0 is when it's slid all the way down, 1.0 when it's slid all the way to its max sliding height
	var currentSlidingProgress: Double {
		let range = 0...abs(maxTranslate)
		return range.normalizedIndex(-transform.ty)
	}

	// MARK: - Pan Gesture Logic
	@IBAction func panGuesturePanning(_ sender: UIPanGestureRecognizer) {
		var translate = sender.translation(in: superview)

		if sender.state == .began {
			slideOffset = transform.ty
		}

		translate.y += slideOffset
		translate.y = max(maxTranslate, translate.y)
		// Positive value is for tug animation. A Value of 0 would result in locking into place.
		translate.y = min(10, translate.y)
		transform.ty = translate.y

		if sender.state == .ended {
			let velocity = sender.velocity(in: self)
			if velocity.y > swipeVelocity {
				animateToPrimaryPosition()
			} else if velocity.y < -swipeVelocity || currentSlidingProgress > 0.65 {
				animateToTopPosition()
			} else {
				animateToPrimaryPosition()
			}
		} else {
			layer.removeAllAnimations()
		}
		delegate?.positionDidChange(on: self)
	}

	func animateToPrimaryPosition() {
		UIView.animate(withDuration: 0.5,
					   delay: 0.0,
					   usingSpringWithDamping: 0.8,
					   initialSpringVelocity: 0.0,
					   options: [.allowUserInteraction, .curveEaseOut],
					   animations: {
						self.transform = .identity
						self.delegate?.positionDidChange(on: self)
		}, completion: { finished in
			guard finished else { return }
			self.isAtTop = false
		})
	}

	private func animateToTopPosition() {
		UIView.animate(withDuration: 0.5,
					   delay: 0.0,
					   usingSpringWithDamping: 0.8,
					   initialSpringVelocity: 0.0,
					   options: [.allowUserInteraction, .curveEaseOut],
					   animations: {
						self.transform.ty = self.maxTranslate
						self.delegate?.positionDidChange(on: self)
		}, completion: { finished in
			guard finished else { return }
			self.isAtTop = true
		})
	}
}
