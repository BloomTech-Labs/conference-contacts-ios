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

	var oldOutputStringValue = ""

	@IBOutlet private weak var onScreenAnchor: NSLayoutConstraint!
	@IBOutlet private weak var offScreenAnchor: NSLayoutConstraint!
	var requestSentViewIsOnScreen: Bool = false

	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		session = AVCaptureSession()

		setupVideoCaptureAndSession()

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.insertSublayer(previewLayer, at: 0)
		view.addSubview(detectedObjectOverlayView)
//		view.bringSubviewToFront(detectedObjectOverlayView)
		detectedObjectOverlayView.backgroundColor = .clear
//		detectedObjectOverlayView.translatesAutoresizingMaskIntoConstraints = false
		detectedObjectOverlayView.frame = cameraView.frame
		detectedObjectOverlayView.layer.addSublayer(detectedShapeLayer)
        session.startRunning()
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

	// FIXME: - Remove for staging & Master
	@IBAction func button(_ sender: UIButton) {
		if !requestSentViewIsOnScreen {
			animateOn()
		} else {
			animateOff()
		}
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
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if let metaDataObject = metadataObjects.first {
			guard let readableObject = metaDataObject as? AVMetadataMachineReadableCodeObject else { return }

			detectedShapeLayer.fillColor = UIColor.gradientBackgroundColorBlueOne.withAlphaComponent(0.3).cgColor
			detectedShapeLayer.lineJoin = .round
//			let path = createPath(with: [CGPoint.zero, CGPoint(x: 200, y: 0), CGPoint(x: 200, y: 200), CGPoint(x: 0, y: 200)])
			let path = createPath(with: readableObject.corners)
			print(readableObject.corners)
			detectedShapeLayer.path = path
			guard let stringValue = readableObject.stringValue else { return }
			triggerHapticFeedback(stringValue)
			title = "Found"
			found(code: stringValue)
//			session.stopRunning()
		} else {
			title = "Looking for QR Code..."
			oldOutputStringValue = ""
			detectedShapeLayer.path = nil
		}
	}

	private func createPath(with points: [CGPoint]?) -> CGMutablePath {
		let path = CGMutablePath()

		let screenSize = cameraView.bounds.maxXY.valuesSwapped

		if var points = points {
			guard !points.isEmpty else { return path }
			var firstPoint = points.removeFirst() * screenSize
			firstPoint = firstPoint.valuesSwapped
			firstPoint.x = cameraView.bounds.maxX - firstPoint.x
			path.move(to: firstPoint)

			for point in points {
				var scaledPoint = point * screenSize
				scaledPoint = scaledPoint.valuesSwapped
				scaledPoint.x = cameraView.bounds.maxX - scaledPoint.x
				path.addLine(to: scaledPoint)
			}
			path.closeSubpath()
		}
		return path
	}

	private func triggerHapticFeedback(_ stringValue: String) {
		guard stringValue != oldOutputStringValue else { return }
		HapticFeedback.produceHeavyFeedback()
		oldOutputStringValue = stringValue
	}

	private func found(code: String) {
		// Do something with metaData stringValue here
	}

	private func animateOn() {
		guard !requestSentViewIsOnScreen else { return }
		requestSentViewIsOnScreen = true
		UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
			self.offScreenAnchor.isActive = false
			self.onScreenAnchor.isActive = true
			self.view.layoutSubviews()
		})
	}

	private func animateOff() {
		guard requestSentViewIsOnScreen else { return }
		requestSentViewIsOnScreen = false
		UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
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
