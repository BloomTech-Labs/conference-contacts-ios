//
//  ProfileViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 11/22/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, Storyboarded {

	@IBOutlet private weak var profileCardContainerView: UIView!
	@IBOutlet private weak var profileCardView: UIView!

	override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.isHidden = true

		profileCardView.layer.masksToBounds = true
		[profileCardView, profileCardContainerView].forEach { $0?.layer.cornerRadius = 20 }
		[profileCardView, profileCardContainerView].forEach { $0?.layer.cornerCurve = .continuous }

		updateViews()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		profileCardView.setNeedsUpdateConstraints()
		updateViews()
	}

	private func updateViews() {
		profileCardContainerView.layer.shadowPath = UIBezierPath(rect: profileCardView.bounds).cgPath
		profileCardContainerView.layer.shadowRadius = 14
		profileCardContainerView.layer.shadowOffset = .zero
		profileCardContainerView.layer.shadowOpacity = 0.3
	}

//	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
////		viewDidLoad()
//	}
//
//	required init?(coder: NSCoder) {
//		super.init(coder: coder)
////		viewDidLoad()
//	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	@IBAction func testButtonPressed(_ sender: UIButton) {
		print("tested")
	}
}
