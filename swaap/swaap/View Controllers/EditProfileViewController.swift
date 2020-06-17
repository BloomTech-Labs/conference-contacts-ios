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
	@IBOutlet private weak var contactMethodsDescLabel: UILabel!
	
	@IBOutlet private weak var nameField: BasicInfoView!
	@IBOutlet private weak var taglineField: BasicInfoView!
	@IBOutlet private weak var jobTitleField: BasicInfoView!
	@IBOutlet private weak var locationField: BasicInfoView!
	@IBOutlet private weak var industryField: BasicInfoView!
	@IBOutlet private weak var birthdayField: BasicInfoView!
	@IBOutlet private weak var bioField: BasicInfoView!
    
	@IBOutlet private weak var contactMethodsStackView: UIStackView!
	
	@IBOutlet private weak var socialLinkButtonTopAnchor: NSLayoutConstraint!
	@IBOutlet private weak var socialLinkButtonBottomAnchor: NSLayoutConstraint!
	@IBOutlet private weak var contactModeDescLabel: UILabel!
	@IBOutlet private weak var onScreenAnchor: NSLayoutConstraint!
	@IBOutlet private weak var offScreenAnchor: NSLayoutConstraint!
	var buttonIsOnScreen: Bool = false
	
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
		scrollView.delegate = self
		if UIScreen.main.bounds.height <= 667 {
			socialLinkButtonTopAnchor.constant = 12
			socialLinkButtonBottomAnchor.constant = 16
		}
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
		
		let image = UIImage(systemName: "camera.fill")
		choosePhotoButton.setImage(image, for: .normal)
		choosePhotoButton.tintColor = .label
		choosePhotoButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
		choosePhotoButton.layer.cornerRadius = 20
		choosePhotoButton.layer.cornerCurve = .continuous
	}
	
	private func populateFromUserProfile() {
		guard let userProfile = profileController?.userProfile else { return }
		userProfile.profileContactMethods.forEach { addContactMethod(contactMethod: $0, checkForPreferred: false) }
		assurePreferredContactExists()
		nameField.valueText = userProfile.name
		taglineField.valueText = userProfile.tagline
		jobTitleField.valueText = userProfile.jobTitle
		locationField.valueText = userProfile.location
		industryField.valueText = userProfile.industry
		birthdayField.valueText = userProfile.birthdate
		bioField.valueText = userProfile.bio
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
	// MARK: Saving
	/// gathers all the saved values, configures operations to update everything, and prioritizes the operations so that
	/// the updates happen before fetching data from the server (otherwise you might get old data!)
	private func saveProfile() {
		//no image handling
		guard let name = nameField.valueText else { return }
		guard var newProfile = profileController?.userProfile else { return }
		newProfile.name = name
		newProfile.tagline = taglineField.valueText
		newProfile.jobTitle = jobTitleField.valueText
		newProfile.location = locationField.valueText
		newProfile.industry = industryField.valueText
		newProfile.birthdate = birthdayField.valueText
		newProfile.bio = bioField.valueText
		newProfile.profileContactMethods = contactMethods
		
		guard let panel = LoadinationAnimatorView.fullScreenPanel() else { return }
		panel.statusLabel.text = "Saving..."
		panel.animation = .bounce2
		panel.backgroundStyle = .fxBlur
		self.view.addSubview(panel)
		panel.beginAnimation()
		
		var imageUpdate: ImageUpdateOperation?
		if let imageData = self.newPhoto?.jpegData(compressionQuality: 0.75) {
			if imageData != profileController?.userProfile?.photoData {
				imageUpdate = ImageUpdateOperation(profileController: profileController, imageData: imageData)
			}
		}
		
		let profileUpdate = profileUpdateOperation(newProfile: newProfile, imageUpdateOperation: imageUpdate)
		
		let profileRefresh = profileRefreshOperation()
		
		let createdMethods = contactMethods.filter { $0.id == nil }
		let createContactMethods = createContactMethodsOperation(createdMethods: createdMethods)
		
		let updatedMethods = contactMethods.filter { $0.id != nil }
		let updateContactMethods = updateContactMethodsOperation(updatedMethods: updatedMethods)
		
		let deletedContactMethods = self.deletedContactMethods
		let deleteContactMethods = deleteContactMethodsOperation(deletedContactMethods: deletedContactMethods)
		
		
		let dismissSelf = ConcurrentOperation { [weak self] in
			self?.dismiss(animated: true)
		}
		
		var operationList = [profileUpdate,
							 profileRefresh,
							 createContactMethods,
							 updateContactMethods,
							 deleteContactMethods]
		
		if let imageUpdate = imageUpdate {
			profileUpdate.addDependency(imageUpdate)
			operationList.insert(imageUpdate, at: 0)
		}
		profileRefresh.addDependency(createContactMethods)
		profileRefresh.addDependency(profileUpdate)
		profileRefresh.addDependency(updateContactMethods)
		profileRefresh.addDependency(deleteContactMethods)
		dismissSelf.addDependency(profileRefresh)
		
		let queue = OperationQueue()
		queue.addOperations(operationList,
							waitUntilFinished: false)
		OperationQueue.main.addOperation(dismissSelf)
		
		saveButton.isEnabled = false
		cancelButton.isEnabled = false
	}
	
	// MARK: Saving Helpers
	/// This generates a generic completion closure to avoid repeating it every time an update operation completes.
	private func concurrentCompletion(with semaphore: DispatchSemaphore) -> (Result<GQLMutationResponse, NetworkError>) -> Void {
		let closure = { (result: Result<GQLMutationResponse, NetworkError>) -> Void in
			switch result {
			case .success:
				break
			case .failure(let error):
				print(error)
			}
			semaphore.signal()
		}
		return closure
	}

	/// Generates a concurrent update operation for the user profile. This means fields like the user's name, location, tagline, etc.

	private func profileUpdateOperation(newProfile: UserProfile, imageUpdateOperation: ImageUpdateOperation?) -> ConcurrentOperation {
		let semaphore = DispatchSemaphore(value: 0)
		let completion = concurrentCompletion(with: semaphore)
		let profileUpdate = ConcurrentOperation { [weak self] in
			var newProfile = newProfile
			if let imageOp = imageUpdateOperation, let imageURL = imageOp.updatedImageURL {
				newProfile.pictureURL = imageURL
			}
			self?.profileController?.updateProfile(newProfile, completion: completion)
			semaphore.wait()
			print("profile update finished")
		}
		return profileUpdate
	}

	/// Generates a concurrent fetch of the user profile. Must run after all the other updates complete.

	private func profileRefreshOperation() -> ConcurrentOperation {
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
		return profileRefresh
	}

	/// Generates a concurrent operation to create the user's new social media and contact methods, as those are
	/// handled separately from the user's profile.

	private func createContactMethodsOperation(createdMethods: [ProfileContactMethod]) -> ConcurrentOperation {
		let semaphore = DispatchSemaphore(value: 0)
		let completion = concurrentCompletion(with: semaphore)
		let createContactMethods = ConcurrentOperation { [weak self] in
			guard let profileController = self?.profileController else { return }
			guard !createdMethods.isEmpty else { return }
			profileController.createContactMethods(createdMethods, completion: completion)
			semaphore.wait()
			print("created new contact method(s)")
		}
		return createContactMethods
	}

	/// Generates a concurrent operation to update the existing the user's new social media and contact methods, as those are
	/// handled separately from the user's profile.
		private func updateContactMethodsOperation(updatedMethods: [ProfileContactMethod]) -> ConcurrentOperation {
		let semaphore = DispatchSemaphore(value: 0)
		let completion = concurrentCompletion(with: semaphore)
		let updateContactMethods = ConcurrentOperation { [weak self] in
			guard let profileController = self?.profileController else { return }
			guard !updatedMethods.isEmpty else { return }
			profileController.updateProfileContactMethods(updatedMethods, completion: completion)
			semaphore.wait()
			print("updated contact method(s)")
		}
		return updateContactMethods
	}

	/// Generates a concurrent operation to delete the user's removed social media and contact methods, as those are
	/// handled separately from the user's profile.
	private func deleteContactMethodsOperation(deletedContactMethods: [ProfileContactMethod]) -> ConcurrentOperation {
		let semaphore = DispatchSemaphore(value: 0)
		let completion = concurrentCompletion(with: semaphore)
		let deleteContactMethods = ConcurrentOperation { [weak self] in
			guard let profileController = self?.profileController else { return }
			guard !deletedContactMethods.isEmpty else { return }
			profileController.deleteProfileContactMethods(deletedContactMethods, completion: completion)
			semaphore.wait()
			print("deleted contact method(s)")
		}
		return deleteContactMethods
	}
	
	// MARK: Other
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
		let contactMethodView = ContactMethodCellView(contactMethod: contactMethod, mode: .edit)
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
			self.nameField.valueText = infoNugget.value
		}, enableSaveButtonHandler: { _, value -> Bool in
			!value.isEmpty
		})
		inputVC?.placeholderStr = "Enter your full name"
		inputVC?.labelText = nameField.valueText
		inputVC?.autoCapitalizationType = .words
		return inputVC
	}
	
	@IBSegueAction func taglineTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.taglineField.valueText = infoNugget.value
		})
		inputVC?.placeholderStr = "Add your tagline"
		inputVC?.labelText = taglineField.valueText
		inputVC?.autoCapitalizationType = .sentences
		return inputVC
	}
	
	@IBSegueAction func locationTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.locationField.valueText = infoNugget.value
		})
		inputVC?.placeholderStr = "Name of city"
		inputVC?.labelText = locationField.valueText
		inputVC?.autoCapitalizationType = .words
		return inputVC
	}
	
	@IBSegueAction func industryTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.industryField.valueText = infoNugget.value
		})
		inputVC?.placeholderStr = "Add the industry you're in"
		inputVC?.labelText = industryField.valueText
		inputVC?.autoCapitalizationType = .words
		return inputVC
	}
	
	@IBSegueAction func birthdateTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.birthdayField.valueText = infoNugget.value
		})
		inputVC?.placeholderStr = "MM/DD/YYYY"
		inputVC?.labelText = birthdayField.valueText
		inputVC?.autoCapitalizationType = .none
		return inputVC
	}
	
	@IBSegueAction func bioTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.bioField.valueText = infoNugget.value
		})
		inputVC?.placeholderStr = "Add a short bio"
		inputVC?.labelText = bioField.valueText
		inputVC?.autoCapitalizationType = .sentences
		return inputVC
	}
    
	@IBSegueAction func editJobTitleSegue(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false, successfulCompletion: { infoNugget in
			self.jobTitleField.valueText = infoNugget.value
		})
		inputVC?.placeholderStr = "Add your job title"
		inputVC?.labelText = jobTitleField.valueText
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
		if cellView.contactMethod.privacy != .public {
			showAlert(titled: "Privacy Notice", message: "Preferred contact must be public.")
			cellView.contactMethod.privacy = .public
		}
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
		let eyeImage = UIImage(systemName: "eye")
		let eyeSlash = UIImage(systemName: "eye.slash")
		let privateStr = NSMutableAttributedString(string: "Private",
												   attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
		let publicStr = NSMutableAttributedString(string: "Public",
												  attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
		let privacyAlertString = """
								 - only visible to you
								 - visible to anyone
								"""
		let privacyAlertStringAttr = NSMutableAttributedString(string: privacyAlertString)
		privacyAlertStringAttr.addAttribute(.font,
											value: UIFont.systemFont(ofSize: 15, weight: .regular),
											range: NSRange(location: 0, length: privacyAlertStringAttr.length))
		privacyAlertStringAttr.insert(privateStr, at: 0)
		privacyAlertStringAttr.insert(publicStr, at: 30)
		let pStyle = NSMutableParagraphStyle()
		pStyle.alignment = NSTextAlignment.left
		privacyAlertStringAttr.addAttribute(.paragraphStyle, value: pStyle, range: NSRange(location: 0, length: privacyAlertStringAttr.length))
		
		let privacyAlert = UIAlertController(title: "Select Privacy Option", message: privacyAlertString, preferredStyle: .actionSheet)
		privacyAlert.setValue(privacyAlertStringAttr, forKey: "attributedMessage")
		
		let privateAction = UIAlertAction(title: "Private", style: .default) { _ in
			guard !cellView.contactMethod.preferredContact else {
				self.showAlert(titled: "Privacy Notice", message: "Preferred contact must be public.")
				return
			}
			cellView.contactMethod.privacy = .private
		}
		privateAction.setValue(eyeSlash, forKey: "image")
		
		let publicAction = UIAlertAction(title: "Public", style: .default) { _ in
			cellView.contactMethod.privacy = .public
		}
		publicAction.setValue(eyeImage, forKey: "image")
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		[privateAction, publicAction, cancel].forEach { privacyAlert.addAction($0) }
		present(privacyAlert, animated: true)
		HapticFeedback.produceMediumFeedback()
	}
	
	private func showAlert(titled title: String?, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Okay", style: .default))
		present(alert, animated: true)
	}
}

extension EditProfileViewController: UIAdaptivePresentationControllerDelegate {
	func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
		self.dismissalActionSheet()
	}
}

extension EditProfileViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let point = getLabelPoint()
		if point.y < view.frame.maxY {
			animateOn()
		} else {
			animateOff()
		}
	}
	
	private func animateOn() {
		guard !buttonIsOnScreen else { return }
		buttonIsOnScreen = true
		UIView.animate(withDuration: 0.5) {
			self.offScreenAnchor.isActive = false
			self.onScreenAnchor.isActive = true
			self.view.layoutSubviews()
		}
	}
	
	private func animateOff() {
		guard buttonIsOnScreen else { return }
		buttonIsOnScreen = false
		UIView.animate(withDuration: 0.5) {
			self.onScreenAnchor.isActive = false
			self.offScreenAnchor.isActive = true
			self.view.layoutSubviews()
		}
	}
	
	func getLabelPoint() -> CGPoint {
		view.convert(CGPoint.zero, from: contactModeDescLabel)
	}
}
