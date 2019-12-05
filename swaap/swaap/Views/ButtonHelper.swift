 //
//  ButtonHelper.swift
//  swaap
//
//  Created by Marlon Raskin on 11/14/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonHelper: UIButton {

	@IBInspectable var cornerRadius: CGFloat {
		get {
			layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}

	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [.allowUserInteraction], animations: {
				self.transform = self.isHighlighted ? .init(scaleX: 0.98, y: 0.98) : .identity
			}, completion: nil)
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		cornerRadius = 8
		layer.cornerCurve = .continuous
	}
}
