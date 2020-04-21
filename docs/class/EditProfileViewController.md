## EditProfileViewController

**internal** *class*

```swift
class EditProfileViewController: UIViewController, ProfileAccessor
```

No documentation



*Found in:*

* `swaap/View Controllers/EditProfileViewController.swift`


### Members



* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileController: ProfileController?
	```

* ##--Property/cancelButton/cancelButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var cancelButton: UIBarButtonItem!
	```

* ##--Property/saveButton/saveButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var saveButton: UIBarButtonItem!
	```

* ##--Property/scrollView/scrollView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var scrollView: UIScrollView!
	```

* ##--Property/profileImageView/profileImageView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var profileImageView: UIImageView!
	```

* ##--Property/choosePhotoButton/choosePhotoButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var choosePhotoButton: UIButton!
	```

* ##--Property/contactMethodsDescLabel/contactMethodsDescLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var contactMethodsDescLabel: UILabel!
	```

* ##--Property/nameField/nameField--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var nameField: BasicInfoView!
	```

* ##--Property/taglineField/taglineField--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var taglineField: BasicInfoView!
	```

* ##--Property/jobTitleField/jobTitleField--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var jobTitleField: BasicInfoView!
	```

* ##--Property/locationField/locationField--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var locationField: BasicInfoView!
	```

* ##--Property/industryField/industryField--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var industryField: BasicInfoView!
	```

* ##--Property/birthdayField/birthdayField--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var birthdayField: BasicInfoView!
	```

* ##--Property/bioField/bioField--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var bioField: BasicInfoView!
	```

* ##--Property/contactMethodsStackView/contactMethodsStackView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var contactMethodsStackView: UIStackView!
	```

* ##--Property/socialLinkButtonTopAnchor/socialLinkButtonTopAnchor--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var socialLinkButtonTopAnchor: NSLayoutConstraint!
	```

* ##--Property/socialLinkButtonBottomAnchor/socialLinkButtonBottomAnchor--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var socialLinkButtonBottomAnchor: NSLayoutConstraint!
	```

* ##--Property/contactModeDescLabel/contactModeDescLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var contactModeDescLabel: UILabel!
	```

* ##--Property/onScreenAnchor/onScreenAnchor--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var onScreenAnchor: NSLayoutConstraint!
	```

* ##--Property/offScreenAnchor/offScreenAnchor--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var offScreenAnchor: NSLayoutConstraint!
	```

* ##--Property/buttonIsOnScreen/buttonIsOnScreen--##
	***internal*** *instance property*
	No documentation
	```swift
	var buttonIsOnScreen: Bool = false
	```

* ##--Property/contactMethods/contactMethods--##
	***internal*** *instance property*
	No documentation
	```swift
	var contactMethods: [ProfileContactMethod]
	```

* ##--Property/deletedContactMethods/deletedContactMethods--##
	***internal*** *instance property*
	No documentation
	```swift
	var deletedContactMethods: [ProfileContactMethod] = []
	```

* ##--Property/contactMethodCellViews/contactMethodCellViews--##
	***internal*** *instance property*
	No documentation
	```swift
	var contactMethodCellViews: [ContactMethodCellView] = []
	```

* ##--Property/newPhoto/newPhoto--##
	***private*** *instance property*
	No documentation
	```swift
	private var newPhoto: UIImage?
	```

* ##--Property/photo/photo--##
	***internal*** *instance property*
	No documentation
	```swift
	var photo: UIImage?
	```

* ##--Method/viewDidLoad()/viewDidLoad()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidLoad()
	```

* ##--Method/setupUI()/setupUI()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupUI()
	```

* ##--Method/updateViews()/updateViews()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateViews()
	```

* ##--Method/populateFromUserProfile()/populateFromUserProfile()--##
	***private*** *instance method*
	No documentation
	```swift
	private func populateFromUserProfile()
	```

* ##--Method/saveButtonTapped(_%3A)/saveButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem)
	```

* ##--Method/cancelButtonTapped(_%3A)/cancelButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem)
	```

* ##--Method/choosePhotoButtonTapped(_%3A)/choosePhotoButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func choosePhotoButtonTapped(_ sender: UIButton)
	```

* ##--Method/saveProfile()/saveProfile()--##
	***private*** *instance method*
	gathers all the saved values, configures operations to update everything, and prioritizes the operations so that
	the updates happen before fetching data from the server (otherwise you might get old data!)
	```swift
	private func saveProfile()
	```

* ##--Method/concurrentCompletion(with%3A)/concurrentCompletion(with:)--##
	***private*** *instance method*
	This generates a generic completion closure to avoid repeating it every time an update operation completes.
	```swift
	private func concurrentCompletion(with semaphore: DispatchSemaphore) -> (Result<GQLMutationResponse, NetworkError>) -> Void
	```

* ##--Method/profileUpdateOperation(newProfile%3AimageUpdateOperation%3A)/profileUpdateOperation(newProfile:imageUpdateOperation:)--##
	***private*** *instance method*
	Generates a concurrent update operation for the user profile. This means fields like the user's name, location, tagline, etc.
	```swift
	private func profileUpdateOperation(newProfile: UserProfile, imageUpdateOperation: ImageUpdateOperation?) -> ConcurrentOperation
	```

* ##--Method/profileRefreshOperation()/profileRefreshOperation()--##
	***private*** *instance method*
	Generates a concurrent fetch of the user profile. Must run after all the other updates complete.
	```swift
	private func profileRefreshOperation() -> ConcurrentOperation
	```

* ##--Method/createContactMethodsOperation(createdMethods%3A)/createContactMethodsOperation(createdMethods:)--##
	***private*** *instance method*
	Generates a concurrent operation to create the user's new social media and contact methods, as those are
	handled separately from the user's profile.
	```swift
	private func createContactMethodsOperation(createdMethods: [ProfileContactMethod]) -> ConcurrentOperation
	```

* ##--Method/updateContactMethodsOperation(updatedMethods%3A)/updateContactMethodsOperation(updatedMethods:)--##
	***private*** *instance method*
	Generates a concurrent operation to update the existing the user's new social media and contact methods, as those are
	handled separately from the user's profile.
	```swift
	private func updateContactMethodsOperation(updatedMethods: [ProfileContactMethod]) -> ConcurrentOperation
	```

* ##--Method/deleteContactMethodsOperation(deletedContactMethods%3A)/deleteContactMethodsOperation(deletedContactMethods:)--##
	***private*** *instance method*
	Generates a concurrent operation to delete the user's removed social media and contact methods, as those are
	handled separately from the user's profile.
	```swift
	private func deleteContactMethodsOperation(deletedContactMethods: [ProfileContactMethod]) -> ConcurrentOperation
	```

* ##--Method/dismissalActionSheet()/dismissalActionSheet()--##
	***private*** *instance method*
	No documentation
	```swift
	private func dismissalActionSheet()
	```

* ##--Method/addContactMethod(contactMethod%3AcheckForPreferred%3A)/addContactMethod(contactMethod:checkForPreferred:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func addContactMethod(contactMethod: ProfileContactMethod, checkForPreferred: Bool = true)
	```

* ##--Method/removeContactMethod(contactMethod%3A)/removeContactMethod(contactMethod:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func removeContactMethod(contactMethod: ProfileContactMethod)
	```

* ##--Method/assurePreferredContactExists()/assurePreferredContactExists()--##
	***private*** *instance method*
	No documentation
	```swift
	private func assurePreferredContactExists()
	```

* ##--Method/nameTextFieldViewController(coder%3A)/nameTextFieldViewController(coder:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func nameTextFieldViewController(coder: NSCoder) -> UIViewController?
	```

* ##--Method/taglineTextFieldViewController(_%3A)/taglineTextFieldViewController(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func taglineTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController?
	```

* ##--Method/locationTextFieldViewController(_%3A)/locationTextFieldViewController(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func locationTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController?
	```

* ##--Method/industryTextFieldViewController(_%3A)/industryTextFieldViewController(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func industryTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController?
	```

* ##--Method/birthdateTextFieldViewController(_%3A)/birthdateTextFieldViewController(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func birthdateTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController?
	```

* ##--Method/bioTextFieldViewController(_%3A)/bioTextFieldViewController(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func bioTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController?
	```

* ##--Method/editJobTitleSegue(_%3A)/editJobTitleSegue(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func editJobTitleSegue(_ coder: NSCoder) -> InputTextFieldViewController?
	```

* ##--Method/createContactMethodTextFieldViewController(_%3A)/createContactMethodTextFieldViewController(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func createContactMethodTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController?
	```

### Extension: EditProfileViewController

**internal** *extension*

```swift
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
```

No documentation




* ##--Method/requestPhotoLibraryAccess()/requestPhotoLibraryAccess()--##
	***internal*** *instance method*
	No documentation
	```swift
	func requestPhotoLibraryAccess()
	```
	*Found in:*

* `swaap/View Controllers/EditProfileViewController+Camera.swift`
* ##--Method/requestCameraAccess()/requestCameraAccess()--##
	***internal*** *instance method*
	No documentation
	```swift
	func requestCameraAccess()
	```
	*Found in:*

* `swaap/View Controllers/EditProfileViewController+Camera.swift`
* ##--Method/presentImagePickerController()/presentImagePickerController()--##
	***internal*** *instance method*
	No documentation
	```swift
	func presentImagePickerController()
	```
	*Found in:*

* `swaap/View Controllers/EditProfileViewController+Camera.swift`
* ##--Method/presentCamera()/presentCamera()--##
	***internal*** *instance method*
	No documentation
	```swift
	func presentCamera()
	```
	*Found in:*

* `swaap/View Controllers/EditProfileViewController+Camera.swift`
* ##--Method/alertPromptToAllowCameraAccessViaSettings()/alertPromptToAllowCameraAccessViaSettings()--##
	***internal*** *instance method*
	No documentation
	```swift
	func alertPromptToAllowCameraAccessViaSettings()
	```
	*Found in:*

* `swaap/View Controllers/EditProfileViewController+Camera.swift`
* ##--Method/presentInformationalAlertController(title%3Amessage%3AdismissActionCompletion%3Acompletion%3A)/presentInformationalAlertController(title:message:dismissActionCompletion:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func presentInformationalAlertController(title: String?,
											 message: String?,
											 dismissActionCompletion: ((UIAlertAction) -> Void)? = nil,
											 completion: (() -> Void)? = nil)
	```
	*Found in:*

* `swaap/View Controllers/EditProfileViewController+Camera.swift`
* ##--Method/imageActionSheet()/imageActionSheet()--##
	***internal*** *instance method*
	No documentation
	```swift
	func imageActionSheet()
	```
	*Found in:*

* `swaap/View Controllers/EditProfileViewController+Camera.swift`
* ##--Method/imagePickerControllerDidCancel(_%3A)/imagePickerControllerDidCancel(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
	```
	*Found in:*

* `swaap/View Controllers/EditProfileViewController+Camera.swift`
* ##--Method/imagePickerController(_%3AdidFinishPickingMediaWithInfo%3A)/imagePickerController(_:didFinishPickingMediaWithInfo:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
	```
	*Found in:*

* `swaap/View Controllers/EditProfileViewController+Camera.swift`


### Extension: EditProfileViewController

**internal** *extension*

```swift
extension EditProfileViewController: ContactMethodCellViewDelegate
```

No documentation




* ##--Method/deleteButtonPressed(on%3A)/deleteButtonPressed(on:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func deleteButtonPressed(on cellView: ContactMethodCellView)
	```

* ##--Method/starButtonPressed(on%3A)/starButtonPressed(on:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func starButtonPressed(on cellView: ContactMethodCellView)
	```

* ##--Method/editCellInvoked(on%3A)/editCellInvoked(on:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func editCellInvoked(on cellView: ContactMethodCellView)
	```

* ##--Method/privacySelectionInvoked(on%3A)/privacySelectionInvoked(on:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func privacySelectionInvoked(on cellView: ContactMethodCellView)
	```

* ##--Method/showAlert(titled%3Amessage%3A)/showAlert(titled:message:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func showAlert(titled title: String?, message: String?)
	```

### Extension: EditProfileViewController

**internal** *extension*

```swift
extension EditProfileViewController: UIAdaptivePresentationControllerDelegate
```

No documentation




* ##--Method/presentationControllerDidAttemptToDismiss(_%3A)/presentationControllerDidAttemptToDismiss(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController)
	```

### Extension: EditProfileViewController

**internal** *extension*

```swift
extension EditProfileViewController: UIScrollViewDelegate
```

No documentation




* ##--Method/scrollViewDidScroll(_%3A)/scrollViewDidScroll(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func scrollViewDidScroll(_ scrollView: UIScrollView)
	```

* ##--Method/animateOn()/animateOn()--##
	***private*** *instance method*
	No documentation
	```swift
	private func animateOn()
	```

* ##--Method/animateOff()/animateOff()--##
	***private*** *instance method*
	No documentation
	```swift
	private func animateOff()
	```

* ##--Method/getLabelPoint()/getLabelPoint()--##
	***internal*** *instance method*
	No documentation
	```swift
	func getLabelPoint() -> CGPoint
	```


