## CoreDataStack

**internal** *class*

```swift
class CoreDataStack
```

No documentation



*Found in:*

* `swaap/Helpers/CoreDataStack.swift`


### Members



* ##--Static/shared/shared--##
	***internal*** *static*
	No documentation
	```swift
	static let shared = CoreDataStack()
	```

* ##--Method/init()/init()--##
	***private*** *instance method*
	No documentation
	```swift
	private init()
	```

* ##--Method/save(context%3A)/save(context:)--##
	***internal*** *instance method*
	A generic function to save any context we want (main or background)
	```swift
	func save(context: NSManagedObjectContext) throws
	```

* ##--Property/container/container--##
	***internal*** *instance property*
	Access to the Persistent Container
	```swift
	lazy var container: NSPersistentContainer { get set }
	```

* ##--Property/mainContext/mainContext--##
	***internal*** *instance property*
	No documentation
	```swift
	var mainContext: NSManagedObjectContext
	```


