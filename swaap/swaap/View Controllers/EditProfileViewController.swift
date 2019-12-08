//
//  EditProfileViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/3/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import Photos

struct SocialLink {
	let socialType: SocialButton.SocialPlatform?
	let value: String
}

class EditProfileViewController: UIViewController {

	@IBOutlet private weak var cancelButton: UIBarButtonItem!
	@IBOutlet private weak var saveButton: UIBarButtonItem!
	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var profileImageView: UIImageView!
	@IBOutlet private weak var choosePhotoButton: UIButton!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var locationLabel: UILabel!
	@IBOutlet private weak var industryLabel: UILabel!

	override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.setNavigationBarHidden(false, animated: false)
		navigationController?.navigationBar.installBlurEffect()
		setupUI()
    }

	private func setupUI() {
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
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		profileImageView.image = image
		choosePhotoButton.setImage(nil, for: .normal)
		picker.dismiss(animated: true)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let inputVC = segue.destination as? InputTextFieldViewController else { return }
		switch segue.identifier {
		case "AddSocialLink":
			inputVC.needsSocialTextField = true
		case "AddIndustrySegue":
			inputVC.needsSocialTextField = false
			inputVC.placeholderStr = "Add the industry you're in"
			inputVC.labelText = passLabelText(from: industryLabel)
		default:
			break
		}
	}

	// MARK: - Helper Methods
	private func passLabelText(from label: UILabel) -> String? {
		if let text = label.text {
			if labelHasDescriptionText(with: text) {
				return nil
			} else {
				return text
			}
		}
		return nil
	}

	private func labelHasDescriptionText(with text: String) -> Bool {
		return text.contains("Tap to add")
	}

	@IBSegueAction func nameTextFieldViewController(coder: NSCoder) -> UIViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false) { socialLink in
			self.nameLabel.text = socialLink.value
		}
		inputVC?.placeholderStr = "Enter your full name"
		inputVC?.labelText = passLabelText(from: nameLabel)
		return inputVC
	}
	
	@IBSegueAction func locationTextFieldViewController(_ coder: NSCoder) -> InputTextFieldViewController? {
		let inputVC = InputTextFieldViewController(coder: coder, needsSocialTextField: false) { socialLink in
			self.locationLabel.text = socialLink.value
		}
		inputVC?.placeholderStr = "Name of city"
		inputVC?.labelText = passLabelText(from: locationLabel)
		return inputVC
	}
}
