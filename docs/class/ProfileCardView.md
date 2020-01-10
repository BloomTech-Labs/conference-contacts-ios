## ProfileCardView

**internal** *class*

```swift
class ProfileCardView: IBPreviewView
```

No documentation



*Found in:*

* `swaap/Views/ProfileCardView.swift`


### Members



* ##--Property/userProfile/userProfile--##
	***internal*** *instance property*
	No documentation
	```swift
	var userProfile: UserProfile?
	```

* ##--Property/profileImage/profileImage--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileImage: UIImage?
	```

* ##--Property/name/name--##
	***internal*** *instance property*
	No documentation
	```swift
	var name: String?
	```

* ##--Property/tagline/tagline--##
	***internal*** *instance property*
	No documentation
	```swift
	var tagline: String?
	```

* ##--Property/jobTitle/jobTitle--##
	***internal*** *instance property*
	No documentation
	```swift
	var jobTitle: String?
	```

* ##--Property/location/location--##
	***internal*** *instance property*
	No documentation
	```swift
	var location: String?
	```

* ##--Property/industry/industry--##
	***internal*** *instance property*
	No documentation
	```swift
	var industry: String?
	```

* ##--Property/preferredContact/preferredContact--##
	***internal*** *instance property*
	No documentation
	```swift
	var preferredContact: ProfileInfoNugget?
	```

* ##--Property/isSmallProfileCard/isSmallProfileCard--##
	***internal*** *instance property*
	No documentation
	```swift
	var isSmallProfileCard: Bool?
	```

* ##--Property/delegate/delegate--##
	***internal*** *instance property*
	No documentation
	```swift
	weak var delegate: ProfileCardViewDelegate?
	```

* ##--Property/contentView/contentView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private var contentView: UIView!
	```

* ##--Property/imageCornerRadius/imageCornerRadius--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var imageCornerRadius: CGFloat = 12
	```

* ##--Property/profileImageView/profileImageView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var profileImageView: UIImageView!
	```

* ##--Property/imageMaskView/imageMaskView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var imageMaskView: UIView!
	```

* ##--Property/chevron/chevron--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var chevron: ChevronView!
	```

* ##--Property/nameLabel/nameLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var nameLabel: UILabel!
	```

* ##--Property/jobTitleLabel/jobTitleLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var jobTitleLabel: UILabel!
	```

* ##--Property/taglineContainer/taglineContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var taglineContainer: UIView!
	```

* ##--Property/taglineLabel/taglineLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var taglineLabel: UILabel!
	```

* ##--Property/locationLabel/locationLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var locationLabel: UILabel!
	```

* ##--Property/industryLabel/industryLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var industryLabel: UILabel!
	```

* ##--Property/socialButton/socialButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var socialButton: SocialButton!
	```

* ##--Property/locationStackView/locationStackView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var locationStackView: UIStackView!
	```

* ##--Property/industryStackView/industryStackView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var industryStackView: UIStackView!
	```

* ##--Property/lackOfInfoDescLabel/lackOfInfoDescLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var lackOfInfoDescLabel: UILabel!
	```

* ##--Method/init(frame%3A)/init(frame:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override init(frame: CGRect)
	```

* ##--Method/init(coder%3A)/init(coder:)--##
	***internal*** *instance method*
	No documentation
	```swift
	required init?(coder: NSCoder)
	```

* ##--Method/commonInit()/commonInit()--##
	***private*** *instance method*
	No documentation
	```swift
	private func commonInit()
	```

* ##--Method/setupImageView()/setupImageView()--##
	***internal*** *instance method*
	This should be private and should be inherently called by resizing the view, but it's not.
	Call externally if needed for different size profilecardViews
	```swift
	func setupImageView()
	```

* ##--Method/setupSmallCardVersion()/setupSmallCardVersion()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupSmallCardVersion()
	```

* ##--Method/updateViews()/updateViews()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateViews()
	```

* ##--Method/hideUnhideElements()/hideUnhideElements()--##
	***private*** *instance method*
	No documentation
	```swift
	private func hideUnhideElements()
	```

* ##--Method/socialButtonTapped(_%3A)/socialButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func socialButtonTapped(_ sender: SocialButton)
	```

* ##--Property/slideOffset/slideOffset--##
	***private*** *instance property*
	No documentation
	```swift
	private var slideOffset: CGFloat = 0
	```

* ##--Property/maxTranslate/maxTranslate--##
	***private*** *instance property*
	No documentation
	```swift
	private var maxTranslate: CGFloat
	```

* ##--Property/isAtTop/isAtTop--##
	***internal*** *instance property*
	No documentation
	```swift
	var isAtTop: Bool = false
	```

* ##--Property/swipeVelocity/swipeVelocity--##
	***private*** *instance property*
	No documentation
	```swift
	private let swipeVelocity: CGFloat = 550
	```

* ##--Property/currentSlidingProgress/currentSlidingProgress--##
	***internal*** *instance property*
	0 is when it's slid all the way down, 1.0 when it's slid all the way to its max sliding height
	```swift
	var currentSlidingProgress: Double
	```

* ##--Method/panGuesturePanning(_%3A)/panGuesturePanning(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func panGuesturePanning(_ sender: UIPanGestureRecognizer)
	```

* ##--Method/animateToPrimaryPosition()/animateToPrimaryPosition()--##
	***internal*** *instance method*
	No documentation
	```swift
	func animateToPrimaryPosition()
	```

* ##--Method/animateToTopPosition()/animateToTopPosition()--##
	***private*** *instance method*
	No documentation
	```swift
	private func animateToTopPosition()
	```


