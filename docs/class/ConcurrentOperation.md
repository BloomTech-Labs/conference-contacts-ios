## ConcurrentOperation

**internal** *class*

```swift
class ConcurrentOperation: Operation
```

No documentation



*Found in:*

* `swaap/Helpers/Operations/ConcurrentOperation.swift`


### Members



* ##--Enum/ConcurrentOperation.State/ConcurrentOperation.State--##
	***internal*** *enum*
	No documentation
	```swift
	enum State: String
	```

* ##--Property/task/task--##
	***internal*** *instance property*
	No documentation
	```swift
	let task: () -> Void
	```

* ##--Property/_state/_state--##
	***private*** *instance property*
	No documentation
	```swift
	private var _state = State.isReady
	```

* ##--Property/stateQueue/stateQueue--##
	***private*** *instance property*
	No documentation
	```swift
	private let stateQueue = DispatchQueue(label: "com.swaap.concurrentStateQueue")
	```

* ##--Property/state/state--##
	***internal*** *instance property*
	No documentation
	```swift
	var state: State
	```

* ##--Property/isReady/isReady--##
	***internal*** *instance property*
	No documentation
	```swift
	override dynamic var isReady: Bool
	```

* ##--Property/isExecuting/isExecuting--##
	***internal*** *instance property*
	No documentation
	```swift
	override dynamic var isExecuting: Bool
	```

* ##--Property/isFinished/isFinished--##
	***internal*** *instance property*
	No documentation
	```swift
	override dynamic var isFinished: Bool
	```

* ##--Property/isAsynchronous/isAsynchronous--##
	***internal*** *instance property*
	No documentation
	```swift
	override var isAsynchronous: Bool
	```

* ##--Method/init(task%3A)/init(task:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(task: @escaping () -> Void)
	```

* ##--Method/start()/start()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func start()
	```


