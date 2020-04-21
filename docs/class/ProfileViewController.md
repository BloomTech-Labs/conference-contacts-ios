## ProfileViewController

**internal** *class*

```swift
class ProfileViewController: UIViewController, Storyboarded, ProfileAccessor
```

This was originally designed with only displaying the current user in mind. Functionality to display the current
user's contacts was somewhat grafted on, not always elegantly. It could probably use a little refactoring to make
it a bit smoother. (But it works, so don't fret too much)



*Found in:*

* `swaap/View Controllers/ProfileViewController.swift`


### Members



* ##--Property/noInfoDescLabel/noInfoDescLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var noInfoDescLabel: UILabel!
	```

* ##--Property/profileCardView/profileCardView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var profileCardView: ProfileCardView!
	```

* ##--Property/scrollView/scrollView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var scrollView: UIScrollView!
	```

* ##--Property/backButtonVisualFXContainerView/backButtonVisualFXContainerView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var backButtonVisualFXContainerView: UIVisualEffectView!
	```

* ##--Property/editProfileButtonVisualFXContainerView/editProfileButtonVisualFXContainerView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var editProfileButtonVisualFXContainerView: UIVisualEffectView!
	```

* ##--Property/backButton/backButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var backButton: UIButton!
	```

* ##--Property/socialButtonsStackView/socialButtonsStackView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var socialButtonsStackView: UIStackView!
	```

* ##--Property/birthdayHeaderContainer/birthdayHeaderContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var birthdayHeaderContainer: UIView!
	```

* ##--Property/birthdayLabelContainer/birthdayLabelContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var birthdayLabelContainer: UIView!
	```

* ##--Property/birthdayLabel/birthdayLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var birthdayLabel: UILabel!
	```

* ##--Property/bioHeaderContainer/bioHeaderContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var bioHeaderContainer: UIView!
	```

* ##--Property/bioLabelContainer/bioLabelContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var bioLabelContainer: UIView!
	```

* ##--Property/bioLabel/bioLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var bioLabel: UILabel!
	```

* ##--Property/locationViewContainer/locationViewContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var locationViewContainer: UIView!
	```

* ##--Property/locationView/locationView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var locationView: BasicInfoView!
	```

* ##--Property/birthdayImageContainerView/birthdayImageContainerView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var birthdayImageContainerView: UIView!
	```

* ##--Property/bioImageViewContainer/bioImageViewContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var bioImageViewContainer: UIView!
	```

* ##--Property/modesOfContactHeaderContainer/modesOfContactHeaderContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var modesOfContactHeaderContainer: UIView!
	```

* ##--Property/modesOfContactPreviewStackView/modesOfContactPreviewStackView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var modesOfContactPreviewStackView: UIStackView!
	```

* ##--Property/modesOfContactImageViewContainer/modesOfContactImageViewContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var modesOfContactImageViewContainer: UIView!
	```

* ##--Property/locationMapViewContainer/locationMapViewContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var locationMapViewContainer: UIView!
	```

* ##--Property/locationmapView/locationmapView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var locationmapView: MeetingLocationView!
	```

* ##--Property/bottomFadeView/bottomFadeView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var bottomFadeView: UIView!
	```

* ##--Property/bottomFadeviewBottomConstraint/bottomFadeviewBottomConstraint--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var bottomFadeviewBottomConstraint: NSLayoutConstraint!
	```

* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileController: ProfileController?
	```

* ##--Property/profileChangedObserver/profileChangedObserver--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileChangedObserver: NSObjectProtocol?
	```

* ##--Property/prefersStatusBarHidden/prefersStatusBarHidden--##
	***internal*** *instance property*
	No documentation
	```swift
	override var prefersStatusBarHidden: Bool
	```

* ##--Property/preferredStatusBarUpdateAnimation/preferredStatusBarUpdateAnimation--##
	***internal*** *instance property*
	No documentation
	```swift
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
	```

* ##--Property/userProfile/userProfile--##
	***internal*** *instance property*
	No documentation
	```swift
	var userProfile: UserProfile?
	```

* ##--Property/meetingCoordinate/meetingCoordinate--##
	***internal*** *instance property*
	No documentation
	```swift
	var meetingCoordinate: MeetingCoordinate?
	```

* ##--Property/isCurrentUser/isCurrentUser--##
	***internal*** *instance property*
	No documentation
	```swift
	var isCurrentUser = false
	```

* ##--Method/viewDidLoad()/viewDidLoad()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidLoad()
	```

* ##--Method/viewWillAppear(_%3A)/viewWillAppear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewWillAppear(_ animated: Bool)
	```

* ##--Method/viewDidLayoutSubviews()/viewDidLayoutSubviews()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidLayoutSubviews()
	```

* ##--Method/viewDidAppear(_%3A)/viewDidAppear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidAppear(_ animated: Bool)
	```

* ##--Method/viewDidDisappear(_%3A)/viewDidDisappear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidDisappear(_ animated: Bool)
	```

* ##--Method/configureProfileCard()/configureProfileCard()--##
	***private*** *instance method*
	No documentation
	```swift
	private func configureProfileCard()
	```

* ##--Method/updateViews()/updateViews()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateViews()
	```

* ##--Enum/ProfileViewController.InfoValueType/ProfileViewController.InfoValueType--##
	***internal*** *enum*
	No documentation
	```swift
	enum InfoValueType
	```

* ##--Method/shouldShowIllustration(infoValueType%3A)/shouldShowIllustration(infoValueType:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func shouldShowIllustration(infoValueType: InfoValueType) -> Bool
	```

* ##--Method/shouldShowLabelInfo(infoValueType%3A)/shouldShowLabelInfo(infoValueType:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func shouldShowLabelInfo(infoValueType: InfoValueType) -> Bool
	```

* ##--Method/shouldShowNoInfoLabel()/shouldShowNoInfoLabel()--##
	***private*** *instance method*
	No documentation
	```swift
	private func shouldShowNoInfoLabel()
	```

* ##--Method/populateSocialButtons()/populateSocialButtons()--##
	***private*** *instance method*
	No documentation
	```swift
	private func populateSocialButtons()
	```

* ##--Method/setupNotifications()/setupNotifications()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupNotifications()
	```

* ##--Method/setupCardShadow()/setupCardShadow()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupCardShadow()
	```

* ##--Method/setupFXView()/setupFXView()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupFXView()
	```

* ##--Method/backbuttonTapped(_%3A)/backbuttonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func backbuttonTapped(_ sender: UIButton)
	```

* ##--Method/editButtonTappedSegue(_%3A)/editButtonTappedSegue(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func editButtonTappedSegue(_ coder: NSCoder) -> UINavigationController?
	```

### Extension: ProfileViewController

**internal** *extension*

```swift
extension ProfileViewController: ProfileCardViewDelegate
```

No documentation




* ##--Method/updateFadeViewPosition()/updateFadeViewPosition()--##
	***internal*** *instance method*
	No documentation
	```swift
	func updateFadeViewPosition()
	```

* ##--Method/profileCardDidFinishAnimation(_%3A)/profileCardDidFinishAnimation(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func profileCardDidFinishAnimation(_ card: ProfileCardView)
	```

* ##--Method/positionDidChange(on%3A)/positionDidChange(on:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func positionDidChange(on view: ProfileCardView)
	```

### Extension: ProfileViewController

**internal** *extension*

```swift
extension ProfileViewController: UIScrollViewDelegate
```

No documentation




* ##--Method/scrollViewDidScroll(_%3A)/scrollViewDidScroll(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func scrollViewDidScroll(_ scrollView: UIScrollView)
	```

### Extension: ProfileViewController

**internal** *extension*

```swift
extension ProfileViewController: UITabBarControllerDelegate
```

No documentation




* ##--Method/tabBarController(_%3AdidSelect%3A)/tabBarController(_:didSelect:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
	```


