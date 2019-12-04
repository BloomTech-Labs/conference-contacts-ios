//
//  HardwareAuthAccess.swift
//  swaap
//
//  Created by Marlon Raskin on 12/3/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import Photos

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	// MARK: - Auth Access
	func requestPhotoLibraryAccess() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {
        case .authorized:
			presentImagePickerController()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")

					self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                self.presentImagePickerController()
            }
        case .denied:
            presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
        default:
            break
        }
        presentImagePickerController()
    }

	func requestCameraAccess() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            presentCamera()
        case .denied:
            alertPromptToAllowCameraAccessViaSettings()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted == true else {
                    NSLog("User did not authorize access to the camera")
					self.presentInformationalAlertController(title: "Error", message: "In order to use the camera, you must allow this application access to it.")
                    return
                }
                self.presentCamera()
            }
        default:
            break
        }
    }

	// MARK: - Picker Controllers
	func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
			presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }

        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
			self.present(imagePicker, animated: true, completion: nil)
        }
    }

	func presentCamera() {
		guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
			presentInformationalAlertController(title: "Error", message: "The camera is unavailable")
			return
		}

		DispatchQueue.main.async {
			let camera = UIImagePickerController()
			camera.delegate = self
			camera.sourceType = .camera
			camera.modalPresentationStyle = .automatic
			self.present(camera, animated: true)
		}
	}

	// MARK: - Camera Settings - Presents alert that takes the user to settings to allow camera access
	func alertPromptToAllowCameraAccessViaSettings() {
        let alert = UIAlertController(title: "In order to use this feature, access to the camera is needed",
									  message: "Please grant permission to use the Camera",
									  preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { _ in
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL)
            }
        })
		present(alert, animated: true, completion: nil)
    }

	// MARK: - Alert and Action Sheet
	func presentInformationalAlertController(title: String?,
											 message: String?,
											 dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
		alertController.addAction(dismissAction)
		present(alertController, animated: true, completion: completion)
    }

	func imageActionSheet() {
        let photoOptionsController = UIAlertController(title: "Choose how you'd like to add a photo", message: nil, preferredStyle: .actionSheet)

        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
			self.requestPhotoLibraryAccess()
        }

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
			self.requestCameraAccess()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        [libraryAction, cameraAction, cancelAction].forEach { photoOptionsController.addAction($0) }
		present(photoOptionsController, animated: true, completion: nil)
    }
}
