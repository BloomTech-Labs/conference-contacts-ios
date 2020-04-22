## ScannerViewController

**internal** *class*

```swift
class ScannerViewController: UIViewController, ContactsAccessor, ProfileAccessor
```

Shows the camera and overlays where the QR code is detected. Would probably be smart to refactor the camera code
into another file.



*Found in:*

* `swaap/View Controllers/ScannerViewController.swift`


### Members



* ##--Enum/ScannerViewController.ConnectionState/ScannerViewController.ConnectionState--##
	***private*** *enum*
	No documentation
	```swift
	private enum ConnectionState
	```

* ##--Property/supportedInterfaceOrientations/supportedInterfaceOrientations--##
	***internal*** *instance property*
	No documentation
	```swift
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask
	```

* ##--Property/cameraView/cameraView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var cameraView: UIView!
	```

* ##--Property/notificationProfileImageView/notificationProfileImageView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var notificationProfileImageView: UIImageView!
	```

* ##--Property/notificationNameLabel/notificationNameLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var notificationNameLabel: UILabel!
	```

* ##--Property/notificationTitle/notificationTitle--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var notificationTitle: UILabel!
	```

* ##--Property/contactsController/contactsController--##
	***internal*** *instance property*
	No documentation
	```swift
	var contactsController: ContactsController?
	```

* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileController: ProfileController?
	```

* ##--Property/networkRequest/networkRequest--##
	***internal*** *instance property*
	No documentation
	```swift
	var networkRequest: URLSessionDataTask?
	```

* ##--Property/imageRequest/imageRequest--##
	***internal*** *instance property*
	No documentation
	```swift
	var imageRequest: URLSessionDataTask?
	```

* ##--Property/session/session--##
	***internal*** *instance property*
	No documentation
	```swift
	var session: AVCaptureSession!
	```

* ##--Property/previewLayer/previewLayer--##
	***internal*** *instance property*
	No documentation
	```swift
	var previewLayer: AVCaptureVideoPreviewLayer!
	```

* ##--Property/detectedObjectOverlayView/detectedObjectOverlayView--##
	***internal*** *instance property*
	No documentation
	```swift
	let detectedObjectOverlayView = UIView()
	```

* ##--Property/detectedShapeLayer/detectedShapeLayer--##
	***internal*** *instance property*
	No documentation
	```swift
	let detectedShapeLayer = CAShapeLayer()
	```

* ##--Property/foundQRCodeData/foundQRCodeData--##
	***internal*** *instance property*
	No documentation
	```swift
	var foundQRCodeData = ""
	```

* ##--Property/lookingForString/lookingForString--##
	***internal*** *instance property*
	No documentation
	```swift
	let lookingForString = "Looking for QR code..."
	```

* ##--Property/foundString/foundString--##
	***internal*** *instance property*
	No documentation
	```swift
	let foundString = "Found"
	```

* ##--Property/defaultConnectionImage/defaultConnectionImage--##
	***internal*** *instance property*
	No documentation
	```swift
	var defaultConnectionImage: UIImage?
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

* ##--Property/requestSentViewIsOnScreen/requestSentViewIsOnScreen--##
	***internal*** *instance property*
	No documentation
	```swift
	var requestSentViewIsOnScreen: Bool = false
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

* ##--Method/viewDidDisappear(_%3A)/viewDidDisappear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidDisappear(_ animated: Bool)
	```

* ##--Method/setupUI()/setupUI()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupUI()
	```

* ##--Method/setupVideoCaptureAndSession()/setupVideoCaptureAndSession()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupVideoCaptureAndSession()
	```

* ##--Method/cancelTapped(_%3A)/cancelTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func cancelTapped(_ sender: UIBarButtonItem)
	```

* ##--Method/dismissButtonPressed(_%3A)/dismissButtonPressed(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func dismissButtonPressed(_ sender: UIButton)
	```

* ##--Method/failed()/failed()--##
	***internal*** *instance method*
	No documentation
	```swift
	func failed()
	```

* ##--Method/createPath(with%3A)/createPath(with:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func createPath(with points: [CGPoint]?) -> CGPath
	```

* ##--Method/foundQRCode(readableObject%3A)/foundQRCode(readableObject:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func foundQRCode(readableObject: AVMetadataMachineReadableCodeObject)
	```

* ##--Method/hideQROverlay()/hideQROverlay()--##
	***private*** *instance method*
	No documentation
	```swift
	private func hideQROverlay()
	```

* ##--Method/triggerHapticFeedback(_%3A)/triggerHapticFeedback(_:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func triggerHapticFeedback(_ code: String)
	```

* ##--Method/found(code%3Apath%3A)/found(code:path:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func found(code: String, path: CGPath)
	```

* ##--Method/fetchAndRequestNewConnection(newConnectionQRId%3A)/fetchAndRequestNewConnection(newConnectionQRId:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func fetchAndRequestNewConnection(newConnectionQRId: String)
	```

* ##--Method/getStateForID(_%3A)/getStateForID(_:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func getStateForID(_ userID: String) -> ConnectionState
	```

* ##--Method/fetchConnectionImage(_%3A)/fetchConnectionImage(_:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func fetchConnectionImage(_ userProfile: UserProfile?)
	```

* ##--Method/animateRequestNotificationOn(for%3A)/animateRequestNotificationOn(for:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func animateRequestNotificationOn(for state: ConnectionState)
	```

* ##--Method/dismissRequestNotification(_%3Aforced%3A)/dismissRequestNotification(_:forced:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func dismissRequestNotification(_ animated: Bool, forced: Bool = false)
	```

### Extension: ScannerViewController

**internal** *extension*

```swift
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate
```

No documentation




* ##--Method/metadataOutput(_%3AdidOutput%3Afrom%3A)/metadataOutput(_:didOutput:from:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
	```


