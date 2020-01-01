//
//  CameraViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/19/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

	@IBOutlet private weak var cameraView: UIView!
	@IBOutlet private weak var profileImageView: UIImageView!
	@IBOutlet private weak var nameOfReceiver: UILabel!

	var session: AVCaptureSession!
	var previewLayer: AVCaptureVideoPreviewLayer!
	let detectedObjectOverlayView = UIView()
	let detectedShapeLayer = CAShapeLayer()
	let lookingForString = "Looking for QR code..."
	let foundString = "Found"

	var foundQRCodeData = ""

	@IBOutlet private weak var onScreenAnchor: NSLayoutConstraint!
	@IBOutlet private weak var offScreenAnchor: NSLayoutConstraint!
	var requestSentViewIsOnScreen: Bool = false

	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		title = lookingForString

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
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if session.isRunning == false {
			session.startRunning()
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if session.isRunning == true {
			session.stopRunning()
		}
	}

	private func setupUI() {
		profileImageView.clipsToBounds = true
		profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
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


	// MARK: - Alerts
    func failed() {
		let alertVC = UIAlertController(title: "Scanning not supported",
								   message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
								   preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true)
        session = nil
    }

	// MARK: - Delegate & Helper Methods
	private func createPath(with points: [CGPoint]?) -> CGMutablePath {
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

	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if let metaDataObject = metadataObjects.first {
			guard let readableObject = metaDataObject as? AVMetadataMachineReadableCodeObject else { return }
			foundQRCode(readableObject: readableObject)
		} else {
			hideQROverlay()
		}
	}

	private func foundQRCode(readableObject: AVMetadataMachineReadableCodeObject) {
		detectedShapeLayer.fillColor = UIColor.gradientBackgroundColorBlueOne.withAlphaComponent(0.5).cgColor
		detectedShapeLayer.strokeColor = UIColor.gradientBackgroundColorBlueOne.withAlphaComponent(0.7).cgColor
		detectedShapeLayer.lineWidth = 5
		detectedShapeLayer.lineJoin = .round
		let path = createPath(with: readableObject.corners)
		detectedShapeLayer.path = path
		guard let stringValue = readableObject.stringValue else { return }
		found(code: stringValue)
	}

	private func hideQROverlay() {
		detectedShapeLayer.path = nil
	}

	private func triggerHapticFeedback(_ code: String) {
		guard code != foundQRCodeData else { return }
		HapticFeedback.produceHeavyFeedback()
	}

	private func found(code: String) {
		// Do something with metaData stringValue here
		triggerHapticFeedback(code)
		foundQRCodeData = code
		animateRequestNotificationOn()
		title = foundString

	}

	private func animateRequestNotificationOn() {
		guard !requestSentViewIsOnScreen else { return }
		requestSentViewIsOnScreen = true
		UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
			self.offScreenAnchor.isActive = false
			self.onScreenAnchor.isActive = true
			self.view.layoutSubviews()
		})
	}

	private func dismissRequestNotification(_ animated: Bool, forced: Bool = false) {
		guard requestSentViewIsOnScreen || forced else { return }
		foundQRCodeData = ""
		title = lookingForString
		requestSentViewIsOnScreen = false
		let duration: TimeInterval = animated ? 0.3 : 0.0
		UIView.animate(withDuration: duration, delay: 0.0, animations: {
			self.onScreenAnchor.isActive = false
			self.offScreenAnchor.isActive = true
			self.view.layoutSubviews()
		})
	}

	// MARK: - System Overrides
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
}
