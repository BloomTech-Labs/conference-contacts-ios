//
//  AlertTint+UIAlertViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
		self.view.tintColor = .swaapAccentColorOne
    }
}
