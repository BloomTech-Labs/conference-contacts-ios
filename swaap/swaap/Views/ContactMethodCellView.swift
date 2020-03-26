//
//  ContactMethodCellView.swift
//  swaap
//
//  Created by Marlon Raskin on 12/9/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import IBPreview

protocol ContactMethodCellViewDelegate: AnyObject {
	func deleteButtonPressed(on cellView: ContactMethodCellView)
	func starButtonPressed(on cellView: ContactMethodCellView)
	func editCellInvoked(on cellView: ContactMethodCellView)
	func privacySelectionInvoked(on cellView: ContactMethodCellView)
}

class ContactMethodCellView: UIView {

	@IBOutlet private weak var contentView: UIView!
	@IBOutlet private weak var cellView: UIView!
	@IBOutlet private weak var starButton: UIButton!
	@IBOutlet private weak var socialButton: SocialButton!
	@IBOutlet private weak var valueLabel: UILabel!
	@IBOutlet private weak var deleteButton: UIButton!
	@IBOutlet private weak var privacySettingLabel: UILabel!

	weak var delegate: ContactMethodCellViewDelegate?

	let mode: Mode

	enum Mode {
		case edit
		case display
	}

	var contactMethod: ProfileContactMethod {
		didSet {
			updateViews()
		}
	}

	init(frame: CGRect = CGRect(origin: .zero, size: CGSize(width: 375, height: 60)),
		 contactMethod: ProfileContactMethod,
		 mode: Mode) {
		self.contactMethod = contactMethod
		self.mode = mode
		super.init(frame: frame)
		commonInit()
	}

	@available(*, unavailable)
	override init(frame: CGRect) {
		fatalError("Init frame not implemented")
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("Init coder not implemented")
	}

	private func commonInit() {
		#if TARGET_INTERFACE_BUILDER
		return
		#endif
		
		let nib = UINib(nibName: "ContactMethodCellView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.layer.masksToBounds = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		cellView.layer.cornerRadius = 12
		cellView.layer.cornerCurve = .continuous

		switch mode {
		case .display:
			starButton.isHidden = true
			deleteButton.isHidden = true
			privacySettingLabel.isHidden = true
		case .edit:
			starButton.isHidden = false
			deleteButton.isHidden = false
			privacySettingLabel.isHidden = false
		}

		self.backgroundColor = .clear

		updateViews()
	}

	private func updateViews() {
		socialButton.smallButton = true
		socialButton.infoNugget = contactMethod.infoNugget
		valueLabel.text = contactMethod.infoNugget.displayValue
		privacySettingLabel.text = contactMethod.privacy.rawValue.capitalized
		starButton.tintColor = contactMethod.preferredContact ? .systemGreen : .systemGray3
	}

	@IBAction func starButtonTapped(_ sender: UIButton) {
		delegate?.starButtonPressed(on: self)
	}

	@IBAction func deleteButtonTapped(_ sender: UIButton) {
		delegate?.deleteButtonPressed(on: self)
	}

	@IBAction func cellButtonTapped(_ sender: UIButton) {
		actOnTaP()
	}

	@IBAction func longPressTriggered(_ sender: UILongPressGestureRecognizer) {
		if sender.state == .began {
			delegate?.privacySelectionInvoked(on: self)
		}
	}

	// MARK: - Helper Methods
	func actOnTaP() {
		switch mode {
		case .edit:
			delegate?.editCellInvoked(on: self)
		case .display:
			socialButton.openLink()
		}
	}
}
