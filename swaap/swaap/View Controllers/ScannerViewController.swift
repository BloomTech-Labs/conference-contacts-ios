//
//  CameraViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/19/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import AVFoundation
import NetworkHandler

class ScannerViewController: UIViewController, ContactsAccessor, ProfileAccessor {
	private enum ConnectionState {
		case yourself
		case alreadyConnected
		case unconnected
	}

	// MARK: - System Overrides
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}

	// MARK: - Properties and Outlets
	@IBOutlet private weak var cameraView: UIView!
	@IBOutlet private weak var notificationProfileImageView: UIImageView!
	@IBOutlet private weak var notificationNameLabel: UILabel!
	@IBOutlet private weak var notificationTitle: UILabel!

	var contactsController: ContactsController?
	var profileController: ProfileController?
	var networkRequest: URLSessionDataTask?
	var imageRequest: URLSessionDataTask?

	var session: AVCaptureSession!
	var previewLayer: AVCaptureVideoPreviewLayer!
	let detectedObjectOverlayView = UIView()
	let detectedShapeLayer = CAShapeLayer()

	var foundQRCodeData = ""

	// static values
	let lookingForString = "Looking for QR code..."
	let foundString = "Found"
	var defaultConnectionImage: UIImage?

	@IBOutlet private weak var onScreenAnchor: NSLayoutConstraint!
	@IBOutlet private weak var offScreenAnchor: NSLayoutConstraint!
	var requestSentViewIsOnScreen: Bool = false

	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		title = lookingForString
		defaultConnectionImage = notificationProfileImageView.image

		session = AVCaptureSession()

		setupVideoCaptureAndSession()

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.insertSublayer(previewLayer, at: 0)
		view.addSubview(detectedObjectOverlayView)
		detectedObjectOverlayView.backgroundColor = .clear
		detectedObjectOverlayView.frame = cameraView.frame
		detectedObjectOverlayView.layer.addSublayer(detectedShapeLayer)
        session.startRunning()

		dismissRequestNotification(false, forced: true)

		profileController?.locationManager.requestAuth()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if session.isRunning == false {
			session.startRunning()
		}
		profileController?.locationManager.startTrackingLocation()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if session.isRunning == true {
			session.stopRunning()
		}
		profileController?.locationManager.stopTrackingLocation()
	}

	private func setupUI() {
		notificationProfileImageView.clipsToBounds = true
		notificationProfileImageView.layer.cornerRadius = notificationProfileImageView.frame.height / 2
	}

	private func setupVideoCaptureAndSession() {
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
		let videoInput: AVCaptureDeviceInput

		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			return
		}

		if session.canAddInput(videoInput) {
			session.addInput(videoInput)
		} else {
			failed()
		}

		let metaDataOutput = AVCaptureMetadataOutput()

		if session.canAddOutput(metaDataOutput) {
			session.addOutput(metaDataOutput)

			metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metaDataOutput.metadataObjectTypes = [.qr]
		} else {
			failed()
		}
	}

	// MARK: - IBActions
	@IBAction func cancelTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true)
	}

	@IBAction func dismissButtonPressed(_ sender: UIButton) {
		dismissRequestNotification(true)
	}

	// MARK: - Alerts
    func failed() {
		let alertVC = UIAlertController(title: "Scanning not supported",
								   message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
								   preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true)
        session = nil
    }

	// MARK: - QR Handling
	private func createPath(with points: [CGPoint]?) -> CGPath {
		let path = CGMutablePath()

		if let points = points {
			for (index, point) in points.enumerated() {
				let convertedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: point)
				if index == 0 {
					path.move(to: convertedPoint)
				} else {
					path.addLine(to: convertedPoint)
				}
			}
			path.closeSubpath()
		}
		return path
	}

	private func foundQRCode(readableObject: AVMetadataMachineReadableCodeObject) {
		detectedShapeLayer.fillColor = UIColor.gradientBackgroundColorBlueOne.withAlphaComponent(0.5).cgColor
		detectedShapeLayer.strokeColor = UIColor.gradientBackgroundColorBlueOne.withAlphaComponent(0.7).cgColor
		detectedShapeLayer.lineWidth = 5
		detectedShapeLayer.lineJoin = .round
		let path = createPath(with: readableObject.corners)
		guard let stringValue = readableObject.stringValue else { return }
		found(code: stringValue, path: path)
	}

	private func hideQROverlay() {
		detectedShapeLayer.path = nil
	}

	private func triggerHapticFeedback(_ code: String) {
		guard foundQRCodeData.isEmpty else { return }
		HapticFeedback.produceHeavyFeedback()
	}

	private func found(code: String, path: CGPath) {
		// Do something with metaData stringValue here
		guard foundQRCodeData.isEmpty || code == foundQRCodeData else { return }
		guard let url = URL(string: code),
			url.host == "swaap.co",
			url.pathComponents.count == 3,
			url.pathComponents[1] == "qrLink" else { return }
		triggerHapticFeedback(code)
		foundQRCodeData = code
		detectedShapeLayer.path = path
		title = foundString

		let newConnectionQRId = url.lastPathComponent
		fetchAndRequestNewConnection(newConnectionQRId: newConnectionQRId)
	}

	private func fetchAndRequestNewConnection(newConnectionQRId: String) {
		// if a network request isnt already in progress...
		if networkRequest == nil {
			// fetch the qr code info
			networkRequest = contactsController?.fetchQRCode(with: newConnectionQRId, completion: { [weak self] (result: Result<ProfileQRCode, NetworkError>) in
				guard let self = self else { return }
				switch result {
				case .success(let qrCode):
					guard let user = qrCode.user else { return }
					self.fetchConnectionImage(user)
					// take the result and on the main thread, update ui if appropriate.
					DispatchQueue.main.async {
						let state = self.getStateForID(user.id)
						if state == .unconnected {
							// if a new connection can be requested, do so, but that goes back to a background thread
							guard let currentLocation = self.profileController?.locationManager.lastLocation else {
								self.dismissRequestNotification(true, forced: true)
								return
							}
							self.contactsController?.requestConnection(toUserID: user.id,
																	   currentLocation: currentLocation,
																	   completion: { (result: Result<GQLMutationResponse, NetworkError>) in
								switch result {
								case .success:
									// update ui on main thread stating that a connection has been requested on your behalf
									DispatchQueue.main.async {
										self.animateRequestNotificationOn(for: state)
										self.notificationNameLabel.text = qrCode.user?.name
									}
									self.contactsController?.updateContactCache()
								case .failure(let error):
									NSLog("Error requesting connection: \(error)")
								}
							})
						} else {
							self.animateRequestNotificationOn(for: state)
							self.notificationNameLabel.text = qrCode.user?.name
						}
					}
				case .failure(let error):
					NSLog("Error loading qr code from server: \(error)")
					self.dismissRequestNotification(true, forced: true)
				}
			})
		}
	}

	private func getStateForID(_ userID: String) -> ConnectionState {
		if profileController?.userProfile?.id == userID {
			return .yourself
		}

		if contactsController?.allContacts.contains(where: { $0.id == userID }) == true {
			return .alreadyConnected
		}

		return .unconnected
	}

	private func fetchConnectionImage(_ userProfile: UserProfile?) {
		guard let userProfile = userProfile else { return }
		imageRequest?.cancel()
		imageRequest = profileController?.fetchImage(url: userProfile.pictureURL, completion: { [weak self] imageResult in
			do {
				let imageData = try imageResult.get()
				DispatchQueue.main.async {
					self?.notificationProfileImageView.image = UIImage(data: imageData)
				}
			} catch {
				NSLog("Failed getting image for user: \(userProfile.id) \(userProfile.name)")
			}
		})
	}

	private func animateRequestNotificationOn(for state: ConnectionState) {
		guard !requestSentViewIsOnScreen else { return }
		requestSentViewIsOnScreen = true

		switch state {
		case .yourself:
			notificationTitle.text = "Look inward to connect with yourself."
		case .alreadyConnected:
			notificationTitle.text = "You're already connected with"
		case .unconnected:
			notificationTitle.text = "Request sent to"
		}

		UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
			self.offScreenAnchor.isActive = false
			self.onScreenAnchor.isActive = true
			self.view.layoutSubviews()
		})
	}

	private func dismissRequestNotification(_ animated: Bool, forced: Bool = false) {
		guard requestSentViewIsOnScreen || forced else { return }
		foundQRCodeData = ""
		networkRequest?.cancel()
		networkRequest = nil
		imageRequest?.cancel()
		imageRequest = nil
		title = lookingForString
		requestSentViewIsOnScreen = false
		let duration: TimeInterval = animated ? 0.3 : 0.0
		UIView.animate(withDuration: duration, animations: {
			self.onScreenAnchor.isActive = false
			self.offScreenAnchor.isActive = true
			self.view.layoutSubviews()
		}) { _ in
			self.notificationProfileImageView.image = self.defaultConnectionImage
		}
	}
}

// MARK: - QR meta data delegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if let metaDataObject = metadataObjects.first {
			guard let readableObject = metaDataObject as? AVMetadataMachineReadableCodeObject else { return }
			foundQRCode(readableObject: readableObject)
		} else {
			hideQROverlay()
		}
	}
}
