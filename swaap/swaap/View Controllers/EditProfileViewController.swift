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
	@IBOutlet private weak var jobTitleLabel: UILabel!
	@IBOutlet private weak var contactModeDescLabel: UILabel!

	@IBOutlet private weak var contactMethodsStackView: UIStackView!

	let haptic = UIImpactFeedbackGenerator(style: .medium)

	var contactMethods: [ProfileContactMethod] {
		contactMethodCellViews.map { $0.contactMethod }
	}
	var deletedContactMethods: [ProfileContactMethod] = []

	var contactMethodCellViews: [ContactMethodCellView] = [] {
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
		isModalInPresentation = true
		setupUI()
		updateViews()
		navigationController?.presentationController?.delegate = self
		haptic.prepare()
    }

	private func setupUI() {
		profileImageView.layer.cornerRadius = 20
		profileImageView.layer.cornerCurve = .continuous
		let rawString = """
						• The  lets others know the best way to reach you.
						• Long press a contact method to select privacy options.
						"""
		let string = NSMutableAttributedString(string: rawString, attributes: [.foregroundColor: UIColor.secondaryLabel])
		let checkmarkSealImage = UIImage(systemName: "checkmark.seal.fill")!
		let greenCheckmarkImage = checkmarkSealImage.withTintColor(.systemGreen)
		let checkmarkAttachment = NSTextAttachment(image: greenCheckmarkImage)
		let checkmarkString = NSAttributedString(attachment: checkmarkAttachment)
		let style = NSMutableParagraphStyle()
		style.lineHeightMultiple = 1.2
		string.insert(checkmarkString, at: 6)
		string.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: string.length))
		contactModeDescLabel.attributedText = string
	}

	private func updateViews() {
		UIView.animate(withDuration: 0.3) {
			self.contactMethodsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
			for cellView in self.contactMethodCellViews {
				self.contactMethodsStackView.addArrangedSubview(cellView)
			}
			self.contactMethodsStackView.layoutSubviews()
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
		userProfile.profileContactMethods.forEach { addContactMethod(contactMethod: $0, checkForPreferred: false) }
		assurePreferredContactExists()
		nameLabel.text = userProfile.name
		industryLabel.text = userProfile.industry
		locationLabel.text = userProfile.location
		bioLabel.text = userProfile.bio
		jobTitleLabel.text = userProfile.jobtitle
		birthdateLabel.text = userProfile.birthdate
		if let imageData = userProfile.photoData {
			profileImageView.image = UIImage(data: imageData)
		}
		updateViews()
	}

	// MARK: - Actions
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		saveProfile()
	}

	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true)
	}

	@IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
		imageActionSheet()
	}


	// MARK: - Helper Methods
	private func saveProfile() {
		//no image handling
		guard let name = nameLabel.text else { return }
		guard var newProfile = profileController?.userProfile else { return }
		newProfile.name = name
		newProfile.industry = industryLabel.text
		newProfile.location = locationLabel.text
		newProfile.bio = bioLabel.text
		newProfile.birthdate = birthdateLabel.text
		newProfile.jobtitle = jobTitleLabel.text
		newProfile.profileContactMethods = contactMethods

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

		var contactMethodUpdates = [ConcurrentOperation]()
		for (index, contactMethod) in contactMethods.enumerated() {
			let contactMethodUpdate = ConcurrentOperation { [weak self] in
				guard let self = self else { return }
				let semaphore = DispatchSemaphore(value: 0)
				self.profileController?.modifyProfileContactMethod(contactMethod, completion: { (result: Result<GQLMutationResponse, NetworkError>) in
					switch result {
					case .success:
						break
					case .failure(let error):
						print(error)
					}
					semaphore.signal()
				})
				semaphore.wait()
				print("contact method update \(index) update finished")
			}
			contactMethodUpdates.append(contactMethodUpdate)
		}

		var contactMethodDeletions = [ConcurrentOperation]()
		for contactMethod in deletedContactMethods {
			let contactMethodUpdate = ConcurrentOperation { [weak self] in
				guard let self = self else { return }
				let semaphore = DispatchSemaphore(value: 0)
				self.profileController?.deleteProfileContactMethod(contactMethod, completion: { (result: Result<GQLMutationResponse, NetworkError>) in
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
			contactMethodDeletions.append(contactMethodUpdate)
		}

		let dismissSelf = ConcurrentOperation { [weak self] in
			self?.dismiss(animated: true)
		}

		profileUpdate.addDependency(imageUpdate)
		profileRefresh.addDependency(profileUpdate)
		contactMethodUpdates.forEach { profileRefresh.addDependency($0) }
		contactMethodDeletions.forEach { profileRefresh.addDependency($0) }
		dismissSelf.addDependency(profileRefresh)

		let queue = OperationQueue()
		queue.addOperations([profileUpdate, profileRefresh, imageUpdate] + contactMethodDeletions + contactMethodUpdates, waitUntilFinished: false)
		OperationQueue.main.addOperation(dismissSelf)

		saveButton.isEnabled = false
		cancelButton.isEnabled = false
	}

	private func dismissalActionSheet() {
		let dismissActionSheet = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .actionSheet)
		let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
			self.saveProfile()
		}

		let dontSaveAction = UIAlertAction(title: "Don't Save", style: .default) { _ in
			self.dismiss(animated: true, completion: nil)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		[saveAction, dontSaveAction, cancelAction].forEach { dismissActionSheet.addAction($0) }
		present(dismissActionSheet, animated: true, completion: nil)
	}

	// MARK: - Contact Method Management
	func addContactMethod(contactMethod: ProfileContactMethod, checkForPreferred: Bool = true) {
		let contactMethodView = ContactMethodCellView(frame: .zero, contactMethod: contactMethod)
		contactMethodView.delegate = self
		contactMethodCellViews.append(contactMethodView)
		if checkForPreferred {
			assurePreferredContactExists()
		}
	}

	func removeContactMethod(contactMethod: ProfileContactMethod) {
		guard let index = contactMethodCellViews.firstIndex(where: { $0.contactMethod == contactMethod }) else { return }
		deletedContactMethods.append(contactMethods[index])
		contactMethodCellViews.remove(at: index)
		assurePreferredContactExists()
	}

	private func assurePreferredContactExists() {
		if contactMethods.preferredContact == nil {
			contactMethodCellViews.first?.contactMethod.preferredContact = true
		}
	}

	// MARK: - Segues
	@IBSegueAction func nameTextFieldViewController(coder: NSCoder) -> UIViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.nameLabel.text = infoNugget.value
		}, enableSaveButtonHandler: { _, value -> Bool in
			!value.isEmpty
		})
		inputVC?.placeholderStr = "Enter your full name"
		inputVC?.labelText = nameLabel.text
		inputVC?.autoCapitalizationType = .words
		return inputVC
	}
	
	@IBSegueAction func locationTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.locationLabel.text = infoNugget.value
		})
		inputVC?.placeholderStr = "Name of city"
		inputVC?.labelText = locationLabel.text
		inputVC?.autoCapitalizationType = .words
		return inputVC
	}

	@IBSegueAction func industryTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.industryLabel.text = infoNugget.value
		})
		inputVC?.placeholderStr = "Add the industry you're in"
		inputVC?.labelText = industryLabel.text
		inputVC?.autoCapitalizationType = .words
		return inputVC
	}

	@IBSegueAction func birthdateTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.birthdateLabel.text = infoNugget.value
		})
		inputVC?.placeholderStr = "MM/DD/YYYY"
		inputVC?.labelText = birthdateLabel.text
		inputVC?.autoCapitalizationType = .none
		return inputVC
	}

	@IBSegueAction func bioTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.bioLabel.text = infoNugget.value
		})
		inputVC?.placeholderStr = "Add a short bio"
		inputVC?.labelText = bioLabel.text
		inputVC?.autoCapitalizationType = .sentences
		return inputVC
	}

	@IBSegueAction func editJobTitleSegue(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.jobTitleLabel.text = infoNugget.value
		})
		inputVC?.placeholderStr = "Add your job title"
		inputVC?.labelText = jobTitleLabel.text
		inputVC?.autoCapitalizationType = .none
		return inputVC
	}


	@IBSegueAction func createContactMethodTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: true, successfulCompletion: { infoNugget in
			guard let contactMethod = infoNugget.contactMethod else { return }
			self.addContactMethod(contactMethod: contactMethod)
		}, enableSaveButtonHandler: { type, value in
			type != nil && !value.isEmpty
		})
		inputVC?.autoCapitalizationType = .none
		return inputVC
	}

}

// MARK: - ContactMethodCellViewDelegate conformance
extension EditProfileViewController: ContactMethodCellViewDelegate {
	func deleteButtonPressed(on cellView: ContactMethodCellView) {
		guard contactMethodCellViews.count >= 2 else {
			let alert = UIAlertController(title: "At least one preferred mode of contact is needed",
										  message: """
			This is the contact button that shows on your profile card and it's how others will try and reach out to you first
			""", preferredStyle: .alert)
			let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(alertAction)
			present(alert, animated: true, completion: nil)
			return
		}
		removeContactMethod(contactMethod: cellView.contactMethod)
	}

	func starButtonPressed(on cellView: ContactMethodCellView) {
		contactMethodCellViews.forEach { $0.contactMethod.preferredContact = false }
		cellView.contactMethod.preferredContact = true
	}

	func editCellInvoked(on cellView: ContactMethodCellView) {
		let inputVCCompletion = { (infoNugget: ProfileInfoNugget) in
			guard let type = infoNugget.type else { return }
			let contactMethod = ProfileContactMethod(id: cellView.contactMethod.id,
									   value: infoNugget.value,
									   type: type,
									   privacy: cellView.contactMethod.privacy,
									   preferredContact: cellView.contactMethod.preferredContact)
			cellView.contactMethod = contactMethod
		}
		let inputVC = InputTextFieldViewController.instantiate(storyboardName: "Profile") { coder -> UIViewController? in
			InputTextFieldViewController(coder: coder, needsSocialTextField: true, successfulCompletion: inputVCCompletion, enableSaveButtonHandler: { type, value in
				type != nil && !value.isEmpty
			})
		}
		inputVC.socialType = cellView.contactMethod.type
		inputVC.labelText = cellView.contactMethod.value
		inputVC.modalPresentationStyle = .overFullScreen
		present(inputVC, animated: true)
	}

	func privacySelectionInvoked(on cellView: ContactMethodCellView) {
		let privateStr = NSMutableAttributedString(string: "Private",
												   attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
		let connectedStr = NSMutableAttributedString(string: "Connected",
													 attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
		let publicStr = NSMutableAttributedString(string: "Public",
												  attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
		let privacyAlertString = """
								 - only visible to you
								 - only visible to your connections
								 - visible to anyone
								"""
		let privacyAlertStringAttr = NSMutableAttributedString(string: privacyAlertString)
		privacyAlertStringAttr.addAttribute(.font,
											value: UIFont.systemFont(ofSize: 15, weight: .regular),
											range: NSRange(location: 0, length: privacyAlertStringAttr.length))
		privacyAlertStringAttr.insert(privateStr, at: 0)
		privacyAlertStringAttr.insert(connectedStr, at: 30)
		privacyAlertStringAttr.insert(publicStr, at: 75)
		let pStyle = NSMutableParagraphStyle()
		pStyle.alignment = NSTextAlignment.left
		privacyAlertStringAttr.addAttribute(.paragraphStyle, value: pStyle, range: NSRange(location: 0, length: privacyAlertStringAttr.length))

		let privacyAlert = UIAlertController(title: "Select Privacy Option", message: privacyAlertString, preferredStyle: .actionSheet)
		privacyAlert.setValue(privacyAlertStringAttr, forKey: "attributedMessage")

		let privateAction = UIAlertAction(title: "Private", style: .default) { _ in
			cellView.contactMethod.privacy = .private
		}
		let connectedAction = UIAlertAction(title: "Connected", style: .default) { _ in
			cellView.contactMethod.privacy = .connected
		}
		let publicAction = UIAlertAction(title: "Public", style: .default) { _ in
			cellView.contactMethod.privacy = .public
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		[privateAction, connectedAction, publicAction, cancel].forEach { privacyAlert.addAction($0) }
		present(privacyAlert, animated: true)
		haptic.impactOccurred()
	}
}

extension EditProfileViewController: UIAdaptivePresentationControllerDelegate {
	func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
		self.dismissalActionSheet()
	}
}
