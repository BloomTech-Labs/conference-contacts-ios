//
//  ConnectViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/19/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {

	@IBOutlet private weak var smallProfileCard: ProfileCardView!

	var profileController: ProfileController?

    override func viewDidLoad() {
        super.viewDidLoad()
		smallProfileCard.isSmallProfileCard = true
    }
}
