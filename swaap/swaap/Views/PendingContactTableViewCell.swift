//
//  PendingContactTableViewCell.swift
//  swaap
//
//  Created by Marlon Raskin on 1/2/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import UIKit

protocol PendingContactTableViewCellDelegate: AnyObject {
	func pendingContactRequestAccepted(on cell: PendingContactTableViewCell, contact: ConnectionContact)
	func pendingContactRequestCancelled(on cell: PendingContactTableViewCell, contact: ConnectionContact)
}

class PendingContactTableViewCell: UITableViewCell {

	@IBOutlet private weak var contactImageView: UIImageView!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var acceptButton: UIButton!
	@IBOutlet private weak var cancelButton: UIButton!

	var profileController: ProfileController?
	var connectionContact: ConnectionContact? {
		didSet {
			updateViews()
		}
	}

	var isIncoming: Bool = true {
		didSet {
			updateViews()
		}
	}

	weak var delegate: PendingContactTableViewCellDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		configureCellUI()
	}

	private func configureCellUI() {
		acceptButton.layer.borderWidth = 1.5
		acceptButton.layer.borderColor = UIColor.swaapAccentColorOne.cgColor
		acceptButton.layer.cornerRadius = acceptButton.frame.height / 2
		acceptButton.layer.cornerCurve = .continuous

		contactImageView.contentMode = .scaleAspectFill
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		enableButtons()
	}

	override func updateConstraints() {
		super.updateConstraints()
		contactImageView.layer.cornerRadius = contactImageView.frame.width / 2
	}

	private func updateViews() {
		acceptButton.isHidden = isIncoming ? false : true
		guard let contact = connectionContact else { return }
		nameLabel.text = contact.name

		guard let imageUrl = contact.pictureURL else { return }
		profileController?.fetchImage(url: imageUrl, completion: { [weak self] result in
			do {
				let imageData = try result.get()
				DispatchQueue.main.async {
					self?.contactImageView?.image = UIImage(data: imageData)
				}
			} catch {
				NSLog("Error fetching image data: \(error)")
			}
		})
	}

	func enableButtons(_ enabled: Bool = true) {
		[acceptButton, cancelButton].forEach { $0?.isEnabled = enabled }
	}

	// MARK: - IBActions
	@IBAction func acceptButtonTapped(_ sender: UIButton) {
		guard let contact = connectionContact else { return }
		delegate?.pendingContactRequestAccepted(on: self, contact: contact)
	}

	@IBAction func cancelButtonTapped(_ sender: UIButton) {
		guard let contact = connectionContact else { return }
		delegate?.pendingContactRequestCancelled(on: self, contact: contact)
	}
}
