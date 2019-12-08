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
	@IBOutlet private weak var saveAndCancelStackView: UIStackView!
	@IBOutlet private weak var cancelButton: UIButton!
	@IBOutlet private weak var saveButton: UIButton!
	@IBOutlet private weak var profileImageView: UIImageView!
	@IBOutlet private weak var choosePhotoButton: UIButton!


	override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
	@IBAction func saveButtonTapped(_ sender: UIButton) {
	}

	@IBAction func cancelButtonTapped(_ sender: UIButton) {

	}

	@IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
		imageActionSheet()
	}

}
