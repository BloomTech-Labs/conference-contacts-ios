//
//  EditProfileViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/3/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable function_body_length

import UIKit
import Photos
import NetworkHandler
import LoadinationIndicator

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
	@IBOutlet private weak var birthdateLabel: UILabel!
	@IBOutlet private weak var bioLabel: UILabel!
	@IBOutlet private weak var contactModeDescLabel: UILabel!

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
	private var newPhoto: UIImage?
	var photo: UIImage? {
		get { newPhoto ?? profileImageView.image }
		set {
			newPhoto = newValue
			profileImageView.image = newPhoto
			updateViews()
		}
	}

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.setNavigationBarHidden(false, animated: false)
		navigationController?.navigationBar.installBlurEffect()
		isModalInPresentation = true
		setupUI()
		updateViews()
    }

	private func setupUI() {
		profileImageView.layer.cornerRadius = 20
		profileImageView.layer.cornerCurve = .continuous
		let rawString = """
						The  lets others know the best way to reach you
						Long press a contact method to select privacy options:
						  • Private (no one can view)
						  • Connected (only your connections can view)
						  • Public (everyone can view)
						"""
		let string = NSMutableAttributedString(string: rawString, attributes: [.foregroundColor: UIColor.secondaryLabel])
		let checkmarkSealImage = UIImage(systemName: "checkmark.seal.fill")!
		let greenCheckmarkImage = checkmarkSealImage.withTintColor(.systemGreen)
		let checkmarkAttachment = NSTextAttachment(image: greenCheckmarkImage)
		let checkmarkString = NSAttributedString(attachment: checkmarkAttachment)
		let style = NSMutableParagraphStyle()
		style.lineHeightMultiple = 1.2
		string.insert(checkmarkString, at: 4)
		string.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: string.length))
		contactModeDescLabel.attributedText = string
	}

	private func updateViews() {
		UIView.animate(withDuration: 0.3) {
			self.socialNuggetsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
			for nugget in self.socialLinkCellViews {
				self.socialNuggetsStackView.addArrangedSubview(nugget)
			}
			self.socialNuggetsStackView.layoutSubviews()
		}

		if photo != nil {
			choosePhotoButton.setImage(nil, for: .normal)
		} else {
			let image = UIImage(systemName: "camera.fill")
			choosePhotoButton.setImage(image, for: .normal)
		}
	}

	private func populateFromUserProfile() {
		guard let userProfile = profileController?.userProfile else { return }
		userProfile.profileNuggets.forEach { addSocialNugget(nugget: $0, checkForPreferred: false) }
		assurePreferredContactExists()
		nameLabel.text = userProfile.name
		industryLabel.text = userProfile.industry
		locationLabel.text = userProfile.location
		bioLabel.text = userProfile.bio
		birthdateLabel.text = userProfile.birthdate
		if let imageData = userProfile.photoData {
			profileImageView.image = UIImage(data: imageData)
		}
		updateViews()
	}

	// MARK: - Actions
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		//no image handling
		guard let name = nameLabel.text,
			let industry = industryLabel.text,
			let location = locationLabel.text,
			let bio = bioLabel.text,
			let birthdate = birthdateLabel.text
		else { return }
		guard var newProfile = profileController?.userProfile else { return }
		newProfile.name = name
		newProfile.industry = industry
		newProfile.location = location
		newProfile.bio = bio
		newProfile.birthdate = birthdate
		newProfile.profileNuggets = socialNuggets

		guard let panel = LoadinationAnimatorView.fullScreenPanel() else { return }
		panel.statusLabel.text = "Saving..."
		panel.animation = .bounce2
		panel.backgroundStyle = .fxBlur
		self.view.addSubview(panel)
		panel.beginAnimation()

		let imageUpdate = ConcurrentOperation { [weak self] in
			guard let self = self else { return }
			if let imageData = self.newPhoto?.jpegData(compressionQuality: 0.75) {
				if imageData != self.profileController?.userProfile?.photoData {
					let semaphore = DispatchSemaphore(value: 0)
					self.profileController?.uploadImageData(imageData, completion: { (result: Result<URL, NetworkError>) in
						switch result {
						case .success(let url):
							newProfile.pictureURL = url
						case .failure(let error):
							NSLog("Error uploading image: \(error)")
						}
						semaphore.signal()
					})
					semaphore.wait()
				}
			}
		}

		let profileUpdate = ConcurrentOperation { [weak self] in
			let semaphore = DispatchSemaphore(value: 0)
			self?.profileController?.updateProfile(newProfile, completion: { (result: Result<GQLMutationResponse, NetworkError>) in
				switch result {
				case .success:
					break
				case .failure(let error):
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

		profileUpdate.addDependency(imageUpdate)
		profileRefresh.addDependency(profileUpdate)
		nuggetUpdates.forEach { profileRefresh.addDependency($0) }
		nuggetDeletions.forEach { profileRefresh.addDependency($0) }
		dismissSelf.addDependency(profileRefresh)

		let queue = OperationQueue()
		queue.addOperations([profileUpdate, profileRefresh, imageUpdate] + nuggetDeletions + nuggetUpdates, waitUntilFinished: false)
		OperationQueue.main.addOperation(dismissSelf)

		saveButton.isEnabled = false
		cancelButton.isEnabled = false
	}

	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true)
	}

	@IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
		imageActionSheet()
	}

	// MARK: - Nugget Management
	func addSocialNugget(nugget: ProfileNugget, checkForPreferred: Bool = true) {
		let nuggetView = SocialLinkCellView(frame: .zero, nugget: nugget)
		nuggetView.delegate = self
		socialLinkCellViews.append(nuggetView)
		if checkForPreferred {
			assurePreferredContactExists()
		}
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

	// MARK: - Segues
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

	@IBSegueAction func birthdateTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false) { socialLink in
			self.birthdateLabel.text = socialLink.value
		}
		inputVC?.placeholderStr = "MM/DD/YYYY"
		inputVC?.labelText = passLabelText(from: birthdateLabel)
		inputVC?.autoCapitalizationType = .none
		return inputVC
	}

	@IBSegueAction func bioTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false) { socialLink in
			self.bioLabel.text = socialLink.value
		}
		inputVC?.placeholderStr = "Add a short bio"
		inputVC?.labelText = passLabelText(from: bioLabel)
		inputVC?.autoCapitalizationType = .sentences
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

// MARK: - SocialLinkCellViewDelegate conformance
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
			let nugget = ProfileNugget(id: cellView.nugget.id,
									   value: socialLink.value,
									   type: type,
									   privacy: cellView.nugget.privacy,
									   preferredContact: cellView.nugget.preferredContact)
			cellView.nugget = nugget
		}
		let inputVC = InputTextFieldViewController.instantiate(storyboardName: "Profile") { coder -> UIViewController? in
			InputTextFieldViewController(coder: coder, needsSocialTextField: true, successfulCompletion: inputVCCompletion)
		}
		inputVC.socialType = cellView.nugget.type
		inputVC.labelText = cellView.nugget.value
		inputVC.modalPresentationStyle = .overFullScreen
		present(inputVC, animated: true)
	}

	func privacySelectionInvoked(on cellView: SocialLinkCellView) {
		let privacyAlert = UIAlertController(title: "Select Privacy Option", message: nil, preferredStyle: .actionSheet)
		let privateAction = UIAlertAction(title: "Private", style: .default) { _ in
			cellView.nugget.privacy = .private
		}
		let connectedAction = UIAlertAction(title: "Connected", style: .default) { _ in
			cellView.nugget.privacy = .connected
		}
		let publicAction = UIAlertAction(title: "Public", style: .default) { _ in
			cellView.nugget.privacy = .public
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		[privateAction, connectedAction, publicAction, cancel].forEach { privacyAlert.addAction($0) }
		present(privacyAlert, animated: true)
	}
}
