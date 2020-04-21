## ContactsController

**internal** *class*

```swift
class ContactsController
```

No documentation



*Found in:*

* `swaap/Model Controllers/ContactsController.swift`


### Members



* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	let profileController: ProfileController
	```

* ##--Property/authManager/authManager--##
	***internal*** *instance property*
	No documentation
	```swift
	let authManager: AuthManager
	```

* ##--Property/networkHandler/networkHandler--##
	***internal*** *instance property*
	No documentation
	```swift
	let networkHandler: NetworkHandler
	```

* ##--Property/graphqlURL/graphqlURL--##
	***internal*** *instance property*
	No documentation
	```swift
	var graphqlURL: URL
	```

* ##--Property/allContacts/allContacts--##
	***internal*** *instance property*
	No documentation
	```swift
	var allContacts: [ConnectionContact]
	```

* ##--Property/pendingIncomingRequests/pendingIncomingRequests--##
	***internal*** *instance property*
	No documentation
	```swift
	var pendingIncomingRequests: [ConnectionContact]
	```

* ##--Property/pendingOutgoingRequests/pendingOutgoingRequests--##
	***internal*** *instance property*
	No documentation
	```swift
	var pendingOutgoingRequests: [ConnectionContact]
	```

* ##--Method/init(profileController%3A)/init(profileController:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(profileController: ProfileController)
	```

* ##--Method/fetchUser(with%3Asession%3Acompletion%3A)/fetchUser(with:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func fetchUser(with id: String, session: NetworkLoader = URLSession.shared, completion: @escaping (Result<UserProfile, NetworkError>) -> Void)
	```

* ##--Method/fetchAllContacts(session%3Acompletion%3A)/fetchAllContacts(session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func fetchAllContacts(session: NetworkLoader = URLSession.shared, completion: @escaping (Result<ContactContainer, NetworkError>) -> Void)
	```

* ##--Method/updateContactCache(completion%3A)/updateContactCache(completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func updateContactCache(completion: @escaping () -> Void = {})
	```

* ##--Method/allCachedContacts(onContext%3Astatus%3A)/allCachedContacts(onContext:status:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func allCachedContacts(onContext context: NSManagedObjectContext, status: ContactPendingStatus? = nil) -> [ConnectionContact]
	```

* ##--Method/getContactFromCache(forID%3AonContext%3A)/getContactFromCache(forID:onContext:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func getContactFromCache(forID id: String, onContext context: NSManagedObjectContext) -> ConnectionContact?
	```

* ##--Method/fetchQRCode(with%3Asession%3Acompletion%3A)/fetchQRCode(with:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@discardableResult func fetchQRCode(with id: String,
										session: NetworkLoader = URLSession.shared,
										completion: @escaping (Result<ProfileQRCode, NetworkError>) -> Void) -> URLSessionDataTask?
	```

* ##--Method/requestConnection(toUserID%3AcurrentLocation%3Asession%3Acompletion%3A)/requestConnection(toUserID:currentLocation:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func requestConnection(toUserID userID: String,
						   currentLocation: CLLocation,
						   session: NetworkLoader = URLSession.shared,
						   completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void)
	```

* ##--Method/acceptConnection(toConnectionID%3AcurrentLocation%3Asession%3Acompletion%3A)/acceptConnection(toConnectionID:currentLocation:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func acceptConnection(toConnectionID connectionID: String,
						   currentLocation: CLLocation,
						   session: NetworkLoader = URLSession.shared,
						   completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void)
	```

* ##--Method/deleteConnection(toConnectionID%3Asession%3Acompletion%3A)/deleteConnection(toConnectionID:session:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func deleteConnection(toConnectionID connectionID: String,
						  session: NetworkLoader = URLSession.shared,
						  completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void)
	```

* ##--Method/clearCache(completion%3A)/clearCache(completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func clearCache(completion: ((Error?) -> Void)? = nil)
	```


