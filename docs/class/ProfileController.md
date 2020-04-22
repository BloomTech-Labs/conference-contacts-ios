## ProfileController

**internal** *class*

```swift
class ProfileController
```

No documentation



*Found in:*

* `swaap/Model Controllers/ProfileController.swift`


### Members



* ##--Property/authManager/authManager--##
	***internal*** *instance property*
	No documentation
	```swift
	let authManager: AuthManager
	```

* ##--Property/locationManager/locationManager--##
	***internal*** *instance property*
	No documentation
	```swift
	let locationManager = LocationHandler()
	```

* ##--Property/userProfile/userProfile--##
	***internal*** *instance property*
	Automatically sends `userProfileChanged` (all events), `userProfilePopulated` (when nil -> value),
	`userProfileDepopulated` (value -> nil), or `userProfileModified` (value -> value) notifications when modified
	```swift
	var userProfile: UserProfile?
	```

* ##--Property/apiBaseURL/apiBaseURL--##
	***internal*** *instance property*
	Uses staging backend with debugging and testflight, but use production when a live app store release
	```swift
	let apiBaseURL: URL
	```

* ##--Property/graphqlURL/graphqlURL--##
	***internal*** *instance property*
	No documentation
	```swift
	var graphqlURL: URL
	```

* ##--Property/liveSiteBaseURL/liveSiteBaseURL--##
	***internal*** *instance property*
	No documentation
	```swift
	let liveSiteBaseURL: URL
	```

* ##--Property/networkHandler/networkHandler--##
	***internal*** *instance property*
	No documentation
	```swift
	let networkHandler: NetworkHandler
	```

* ##--Property/depopCredentialObserver/depopCredentialObserver--##
	***private*** *instance property*
	No documentation
	```swift
	private var depopCredentialObserver: NSObjectProtocol?
	```

* ##--Property/restoredCredentialObserver/restoredCredentialObserver--##
	***private*** *instance property*
	No documentation
	```swift
	private var restoredCredentialObserver: NSObjectProtocol?
	```

* ##--Method/init(authManager%3A)/init(authManager:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(authManager: AuthManager)
	```

* ##--Method/createProfileOnServer(session%3Acompletion%3A)/createProfileOnServer(session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func createProfileOnServer(session: NetworkLoader = URLSession.shared, completion: ((Result<GQLMutationResponse, NetworkError>) -> Void)? = nil)
	```

* ##--Method/fetchProfileFromServer(session%3Acompletion%3A)/fetchProfileFromServer(session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func fetchProfileFromServer(session: NetworkLoader = URLSession.shared, completion: @escaping (Result<UserProfile, NetworkError>) -> Void)
	```

* ##--Method/updateProfile(_%3Asession%3Acompletion%3A)/updateProfile(_:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func updateProfile(_ userProfile: UserProfile,
					   session: NetworkLoader = URLSession.shared,
					   completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void)
	```

* ##--Method/createQRCode(labeled%3Asession%3Acompletion%3A)/createQRCode(labeled:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func createQRCode(labeled label: String,
					  session: NetworkLoader = URLSession.shared,
					  completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void)
	```

* ##--Method/createContactMethods(_%3Asession%3Acompletion%3A)/createContactMethods(_:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func createContactMethods(_ contactMethods: [ProfileContactMethod],
							  session: NetworkLoader = URLSession.shared,
							  completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void)
	```

* ##--Method/updateProfileContactMethods(_%3Asession%3Acompletion%3A)/updateProfileContactMethods(_:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func updateProfileContactMethods(_ contactMethods: [ProfileContactMethod],
									 session: NetworkLoader = URLSession.shared,
									 completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void)
	```

* ##--Method/deleteProfileContactMethods(_%3Asession%3Acompletion%3A)/deleteProfileContactMethods(_:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func deleteProfileContactMethods(_ contactMethods: [ProfileContactMethod],
									 session: NetworkLoader = URLSession.shared,
									 completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void)
	```

* ##--Method/networkAuthRequestCommon()/networkAuthRequestCommon()--##
	***private*** *instance method*
	No documentation
	```swift
	private func networkAuthRequestCommon() -> NetworkRequest?
	```

* ##--Method/fetchImage(url%3Asession%3Acompletion%3A)/fetchImage(url:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@discardableResult func fetchImage(url: URL,
									   session: NetworkLoader = URLSession.shared,
									   completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
	```

* ##--Method/updateUserImage(_%3A)/updateUserImage(_:)--##
	***internal*** *instance method*
	By default, only updates if photo is nil. `force` will force it to download, even if there's already data.
	- Parameter force: Bool determining if the update is forced or contextual.
	```swift
	func updateUserImage(_ force: Bool = false)
	```

* ##--Method/checkUserQRCode()/checkUserQRCode()--##
	***private*** *instance method*
	No documentation
	```swift
	private func checkUserQRCode()
	```

* ##--Property/cloudinaryConfig/cloudinaryConfig--##
	***private*** *instance property*
	No documentation
	```swift
	private let cloudinaryConfig = CLDConfiguration(cloudName: "swaap", secure: true)
	```

* ##--Property/cloudinary/cloudinary--##
	***private*** *instance property*
	No documentation
	```swift
	private lazy var cloudinary = CLDCloudinary(configuration: cloudinaryConfig)
	```

* ##--Method/uploadImageData(_%3Acompletion%3A)/uploadImageData(_:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func uploadImageData(_ data: Data, completion: @escaping (Result<URL, NetworkError>) -> Void)
	```

* ##--Property/fm/fm--##
	***private*** *instance property*
	No documentation
	```swift
	private let fm = FileManager.default
	```

* ##--Property/profileCacheFilename/profileCacheFilename--##
	***private*** *instance property*
	No documentation
	```swift
	private let profileCacheFilename = "profile.plist"
	```

* ##--Property/profileCacheURL/profileCacheURL--##
	***private*** *instance property*
	No documentation
	```swift
	private var profileCacheURL: URL
	```

* ##--Method/loadCachedProfile()/loadCachedProfile()--##
	***private*** *instance method*
	No documentation
	```swift
	private func loadCachedProfile()
	```

* ##--Method/saveProfileToCache()/saveProfileToCache()--##
	***private*** *instance method*
	No documentation
	```swift
	private func saveProfileToCache()
	```

* ##--Method/deleteProfileCache()/deleteProfileCache()--##
	***private*** *instance method*
	No documentation
	```swift
	private func deleteProfileCache()
	```

### Extension: ProfileController

**internal** *extension*

```swift
extension ProfileController: LocationHandlerDelegate
```

No documentation




* ##--Method/locationRequester(_%3AdidUpdateLocation%3A)/locationRequester(_:didUpdateLocation:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func locationRequester(_ locationRequester: LocationHandler, didUpdateLocation location: CLLocation)
	```

### Extension: ProfileController

**internal** *extension*

```swift
extension ProfileController
```

No documentation




* ##--Method/checkUserProfileChanged(oldValue%3AnewValue%3A)/checkUserProfileChanged(oldValue:newValue:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func checkUserProfileChanged(oldValue: UserProfile?, newValue: UserProfile?)
	```


