## SocialButton

**internal** *class*

```swift
class SocialButton: IBPreviewControl
```

No documentation



*Found in:*

* `swaap/Views/SocialButton.swift`


### Members



* ##--Property/contentHeightAnchor/contentHeightAnchor--##
	***private*** *instance property*
	No documentation
	```swift
	private var contentHeightAnchor: NSLayoutConstraint?
	```

* ##--Property/height/height--##
	***internal*** *instance property*
	No documentation
	```swift
	var height: CGFloat
	```

* ##--Property/smallButton/smallButton--##
	***internal*** *instance property*
	No documentation
	```swift
	var smallButton: Bool = false
	```

* ##--Property/infoNugget/infoNugget--##
	***internal*** *instance property*
	No documentation
	```swift
	var infoNugget: ProfileInfoNugget = ProfileInfoNugget(type: .twitter, value: "@swaapApp")
	```

* ##--Property/cornerRadius/cornerRadius--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var cornerRadius: CGFloat
	```

* ##--Property/twitterURL/twitterURL--##
	***internal*** *instance property*
	No documentation
	```swift
	let twitterURL = URL(string: "https://twitter.com/")!
	```

* ##--Property/facebookURL/facebookURL--##
	***internal*** *instance property*
	No documentation
	```swift
	let facebookURL = URL(string: "https://facebook.com/")!
	```

* ##--Property/instagramURL/instagramURL--##
	***internal*** *instance property*
	No documentation
	```swift
	let instagramURL = URL(string: "https://instagram.com/")!
	```

* ##--Property/linkedInURL/linkedInURL--##
	***internal*** *instance property*
	No documentation
	```swift
	let linkedInURL = URL(string: "https://linkedin.com/in/")!
	```

* ##--Property/emailURL/emailURL--##
	***internal*** *instance property*
	No documentation
	```swift
	let emailURL = URL(string: "mailto:")!
	```

* ##--Property/phoneURL/phoneURL--##
	***internal*** *instance property*
	No documentation
	```swift
	let phoneURL = URL(string: "tel:")!
	```

* ##--Property/smsURL/smsURL--##
	***internal*** *instance property*
	No documentation
	```swift
	let smsURL = URL(string: "sms:")!
	```

* ##--Property/contentView/contentView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private var contentView: UIView!
	```

* ##--Property/mainColorBackgroundView/mainColorBackgroundView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var mainColorBackgroundView: UIView!
	```

* ##--Property/translucentView/translucentView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var translucentView: UIView!
	```

* ##--Property/iconView/iconView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var iconView: UIImageView!
	```

* ##--Property/handleLabel/handleLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var handleLabel: UILabel!
	```

* ##--Property/depressFadeView/depressFadeView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var depressFadeView: UIView!
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

* ##--Method/updateSocialPlatformType()/updateSocialPlatformType()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateSocialPlatformType()
	```

* ##--Method/openLink()/openLink()--##
	***internal*** *instance method*
	No documentation
	```swift
	func openLink()
	```

* ##--Property/animationTime/animationTime--##
	***private*** *instance property*
	No documentation
	```swift
	private let animationTime = 0.07
	```

* ##--Property/isDepressed/isDepressed--##
	***private*** *instance property*
	No documentation
	```swift
	private var isDepressed = false
	```

* ##--Method/animateDepress()/animateDepress()--##
	***private*** *instance method*
	No documentation
	```swift
	private func animateDepress()
	```

* ##--Method/animateRelease()/animateRelease()--##
	***private*** *instance method*
	No documentation
	```swift
	private func animateRelease()
	```

* ##--Method/beginTracking(_%3Awith%3A)/beginTracking(_:with:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
	```

* ##--Method/continueTracking(_%3Awith%3A)/continueTracking(_:with:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
	```

* ##--Method/endTracking(_%3Awith%3A)/endTracking(_:with:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func endTracking(_ touch: UITouch?, with event: UIEvent?)
	```

* ##--Method/cancelTracking(with%3A)/cancelTracking(with:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func cancelTracking(with event: UIEvent?)
	```


