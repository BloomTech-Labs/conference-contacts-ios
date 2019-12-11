//
//  EditProfileViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/3/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import Photos

struct SocialLink {
	var socialType: ProfileFieldType?
	var value: String
}

class EditProfileViewController: UIViewController, ProfileAccessor {

	// MARK: - Properties
	var profileController: ProfileController? {
		didSet {
			//populateFromUserProfile()
		}
	}

	// MARK: Outlets
	@IBOutlet private weak var cancelButton: UIBarButtonItem!
	@IBOutlet private weak var saveButton: UIBarButtonItem!
	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var profileImageView: UIImageView!
	@IBOutlet private weak var choosePhotoButton: UIButton!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var locationLabel: UILabel!
	@IBOutlet private weak var industryLabel: UILabel!
	@IBOutlet private weak var socialNuggetsStackView: UIStackView!

	var socialNuggets: [ProfileNugget] {
		socialLinkCellViews.map { $0.nugget }
	}

	var socialLinkCellViews: [SocialLinkCellView] = [] {
		didSet {
			updateViews()
		}
	}

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.setNavigationBarHidden(false, animated: false)
		navigationController?.navigationBar.installBlurEffect()
		setupUI()
    }

	private func setupUI() {
		profileImageView.layer.cornerRadius = 20
		profileImageView.layer.cornerCurve = .continuous
	}

	private func updateViews() {
		UIView.animate(withDuration: 0.3) {
			self.socialNuggetsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
			for nugget in self.socialLinkCellViews {
				self.socialNuggetsStackView.addArrangedSubview(nugget)
			}
			self.socialNuggetsStackView.layoutSubviews()
		}
	}

	private func populateFromUserProfile() {
		guard let userProfile = profileController?.userProfile else { return }
		userProfile.profileNuggets.forEach { addSocialNugget(nugget: $0) }
	}

	// MARK: - Actions
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {

	}

	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true)
	}

	@IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
		imageActionSheet()
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		profileImageView.image = image
		choosePhotoButton.setImage(nil, for: .normal)
		picker.dismiss(animated: true)
	}

	// MARK: - Helper Methods
	func addSocialNugget(nugget: ProfileNugget) {
		let nuggetView = SocialLinkCellView(frame: .zero, nugget: nugget)
		nuggetView.delegate = self
		socialLinkCellViews.append(nuggetView)
		assurePreferredContactExists()
	}

	func removeNugget(nugget: ProfileNugget) {
		guard let index = socialLinkCellViews.firstIndex(where: { $0.nugget == nugget }) else { return }
		socialLinkCellViews.remove(at: index)
		assurePreferredContactExists()
	}

	private func assurePreferredContactExists() {
		if socialNuggets.preferredContact == nil {
			socialLinkCellViews.first?.nugget.preferredContact = true
		}
	}

	private func passLabelText(from label: UILabel) -> String? {
		if let text = label.text {
			if text.contains("Tap to add") {
				return nil
			} else {
				return text
			}
		}
		return nil
	}

	@IBSegueAction func nameTextFieldViewController(coder: NSCoder) -> UIViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false) { socialLink in
			self.nameLabel.text = socialLink.value
		}
		inputVC?.placeholderStr = "Enter your full name"
		inputVC?.labelText = passLabelText(from: nameLabel)
		inputVC?.autoCapitalizationType = .words
		return inputVC
	}
	
	@IBSegueAction func locationTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false) { socialLink in
			self.locationLabel.text = socialLink.value
		}
		inputVC?.placeholderStr = "Name of city"
		inputVC?.labelText = passLabelText(from: locationLabel)
		inputVC?.autoCapitalizationType = .words
		return inputVC
	}

	@IBSegueAction func industryTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false) { socialLink in
			self.industryLabel.text = socialLink.value
		}
		inputVC?.placeholderStr = "Add the industry you're in"
		inputVC?.labelText = passLabelText(from: industryLabel)
		inputVC?.autoCapitalizationType = .words
		return inputVC
	}

	@IBSegueAction func socialLinkTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: true) { socialLink in
			guard let type = socialLink.socialType else { return }
			let nugget = ProfileNugget(value: socialLink.value, type: type)
			self.addSocialNugget(nugget: nugget)
		}
		inputVC?.autoCapitalizationType = .none
		return inputVC
	}
}

extension EditProfileViewController: SocialLinkCellViewDelegate {
	func deleteButtonPressed(on cellView: SocialLinkCellView) {
		guard socialLinkCellViews.count >= 2 else {
			let alert = UIAlertController(title: "At least one preferred mode of contact is needed",
										  message: """
			This is the contact button that shows on your profile card and it's how others will try and reach out to you first
			""", preferredStyle: .alert)
			let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(alertAction)
			present(alert, animated: true, completion: nil)
			return
		}
		removeNugget(nugget: cellView.nugget)
	}

	func starButtonPressed(on cellView: SocialLinkCellView) {
		socialLinkCellViews.forEach { $0.nugget.preferredContact = false }
		cellView.nugget.preferredContact = true
	}

	func editCellInvoked(on cellView: SocialLinkCellView) {
		let inputVCCompletion = { (socialLink: SocialLink) in
			guard let type = socialLink.socialType else { return }
			let nugget = ProfileNugget(id: cellView.nugget.id, value: socialLink.value, type: type, privacy: cellView.nugget.privacy, preferredContact: cellView.nugget.preferredContact)
			cellView.nugget = nugget
		}
		let inputVC = InputTextFieldViewController.instantiate(storyboardName: "Profile") { coder -> UIViewController? in
			InputTextFieldViewController(coder: coder, needsSocialTextField: true, successfulCompletion: inputVCCompletion)
		}
		inputVC.socialType = .twitter
		inputVC.labelText = cellView.nugget.value
		inputVC.modalPresentationStyle = .overFullScreen
		present(inputVC, animated: true)
	}
}
