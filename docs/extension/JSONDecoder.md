## JSONDecoder

**open** *extension*

```swift
no declaration
```

The following are extensions on the JSONDecoder Type.



*Found in:*

* `swaap`


### Extension: JSONDecoder

**internal** *extension*

```swift
extension JSONDecoder
```

No documentation




* ##--Enum/JSONDecoder.JWTError/JSONDecoder.JWTError--##
	***internal*** *enum*
	No documentation
	```swift
	enum JWTError: Error
	```
	*Found in:*

* `swaap/Helpers/JSONDecoder+JWTDecoding.swift`
* ##--Method/decode(_%3AfromJWT%3A)/decode(_:fromJWT:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func decode<T>(_ type: T.Type, fromJWT jwtString: String) throws -> T where T: Decodable
	```
	*Found in:*

* `swaap/Helpers/JSONDecoder+JWTDecoding.swift`



