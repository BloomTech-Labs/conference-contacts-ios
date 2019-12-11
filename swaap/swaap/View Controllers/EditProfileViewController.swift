//
//  EditProfileViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/3/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import Photos
import NetworkHandler

struct SocialLink {
	var socialType: ProfileFieldType?
	var value: String
}

class EditProfileViewController: UIViewController, ProfileAccessor {

	// MARK: - Properties
	var profileController: ProfileController? {
		didSet {
			populateFromUserProfile()
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
	var deletedNuggets: [ProfileNugget] = []

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
		nameLabel.text = userProfile.name
		industryLabel.text = userProfile.industry
		locationLabel.text = userProfile.location
		if let imageData = userProfile.photoData {
			profileImageView.image = UIImage(data: imageData)
		}
	}

	// MARK: - Actions
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		//no image handling
		guard let name = nameLabel.text,
			let industry = industryLabel.text,
			let location = locationLabel.text else { return }
		guard var newProfile = profileController?.userProfile else { return }
		newProfile.name = name
		newProfile.industry = industry
		newProfile.location = location

		newProfile.profileNuggets = socialNuggets

		let profileUpdate = ConcurrentOperation { [weak self] in
			let semaphore = DispatchSemaphore(value: 0)
			self?.profileController?.updateProfile(newProfile, completion: { (result: Result<GQLMutationResponse, NetworkError>) in
				switch result {
				case .success:
					break
				case .failure(let error):
					// FIXME: show error
					print(error)
				}
				semaphore.signal()
			})
			semaphore.wait()
			print("profile update finished")
		}

		let profileRefresh = ConcurrentOperation { [weak self] in
			let semaphore = DispatchSemaphore(value: 0)
			self?.profileController?.fetchProfileFromServer(completion: { (result: Result<UserProfile, NetworkError>) in
				switch result {
				case .success:
					break
				case .failure(let error):
					// FIXME: show error
					print(error)
				}
				semaphore.signal()
			})
			semaphore.wait()
			print("profile refresh finished")
		}

		var nuggetUpdates = [ConcurrentOperation]()
		for (index, nugget) in socialNuggets.enumerated() {
			let nuggetUpdate = ConcurrentOperation { [weak self] in
				guard let self = self else { return }
				let semaphore = DispatchSemaphore(value: 0)
				self.profileController?.modifyProfileNugget(nugget, completion: { (result: Result<GQLMutationResponse, NetworkError>) in
					switch result {
					case .success:
						break
					case .failure(let error):
						// FIXME: show error
						print(error)
					}
					semaphore.signal()
				})
				semaphore.wait()
				print("nugget update \(index) update finished")
			}
			nuggetUpdates.append(nuggetUpdate)
		}

		var nuggetDeletions = [ConcurrentOperation]()
		for nugget in deletedNuggets {
			let nuggetUpdate = ConcurrentOperation { [weak self] in
				guard let self = self else { return }
				let semaphore = DispatchSemaphore(value: 0)
				self.profileController?.deleteProfileNugget(nugget, completion: { (result: Result<GQLMutationResponse, NetworkError>) in
					switch result {
					case .success:
						break
					case .failure(let error):
						// FIXME: show error
						print(error)
					}
					semaphore.signal()
				})
				semaphore.wait()
			}
			nuggetDeletions.append(nuggetUpdate)
		}

		let dismissSelf = ConcurrentOperation { [weak self] in
			self?.dismiss(animated: true)
		}

		profileRefresh.addDependency(profileUpdate)
		nuggetUpdates.forEach { profileRefresh.addDependency($0) }
		nuggetDeletions.forEach { profileRefresh.addDependency($0) }
		dismissSelf.addDependency(profileRefresh)

		let queue = OperationQueue()
		queue.addOperations([profileUpdate, profileRefresh] + nuggetDeletions + nuggetUpdates, waitUntilFinished: false)
		OperationQueue.main.addOperation(dismissSelf)

		sender.isEnabled = false
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
		deletedNuggets.append(socialNuggets[index])
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
