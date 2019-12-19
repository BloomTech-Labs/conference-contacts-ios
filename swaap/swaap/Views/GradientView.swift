//
//  GradientView.swift
//  Poopmaster Pro
//
//  Created by Michael Redig on 10/26/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//
// swiftlint:disable force_cast

import UIKit

@IBDesignable
class GradientView: UIView {

	@IBInspectable var startColor: UIColor = .black {
		didSet {
			updateColors()
		}
	}
	@IBInspectable var endColor: UIColor = .white {
		didSet {
			updateColors()
		}
	}
	@IBInspectable var startPoint: CGPoint = .zero {
		didSet {
			updatePoints()
		}
	}
	@IBInspectable var endPoint: CGPoint = .init(x: 0, y: 1) {
		didSet {
			updatePoints()
		}
	}

	override public class var layerClass: AnyClass {
		CAGradientLayer.self
	}

	var gradientLayer: CAGradientLayer {
		layer as! CAGradientLayer
	}

	func updatePoints() {
		gradientLayer.startPoint = startPoint
		gradientLayer.endPoint = endPoint
	}

	func updateColors() {
		gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
	}
	override public func layoutSubviews() {
		super.layoutSubviews()
		updatePoints()
		updateColors()
	}
}
