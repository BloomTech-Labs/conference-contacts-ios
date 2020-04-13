//
//  UIView+Visible.swift
//  swaap
//
//  Created by Marlon Raskin on 12/6/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

extension UIView {
	var isVisible: Bool {
		get {
			!isHidden
		}
		
		set {
			guard isHidden != !newValue else { return }
			isHidden = !newValue
		}
	}
}

extension String {
	var isNotEmpty: Bool {
		!isEmpty
	}
}
