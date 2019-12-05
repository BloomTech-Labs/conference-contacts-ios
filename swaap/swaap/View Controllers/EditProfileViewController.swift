//
//  EditProfileViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/3/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import Photos

class EditProfileViewController: UIViewController {

	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var profileImageView: UIImageView!
	@IBOutlet private weak var choosePhotoButton: UIButton!

	override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.setNavigationBarHidden(false, animated: false)
		navigationController?.navigationBar.installBlurEffect()

		setupUI()
    }

	private func setupUI() {
		profileImageView.layer.borderColor = UIColor.systemGray5.cgColor
		profileImageView.layer.borderWidth = 1.5
		profileImageView.layer.cornerRadius = 20
		profileImageView.layer.cornerCurve = .continuous
	}
    
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {

	}

	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true)
	}

	@IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
		imageActionSheet()
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		picker.dismiss(animated: true)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		profileImageView.image = image
		choosePhotoButton.setImage(nil, for: .normal)
	}
}
