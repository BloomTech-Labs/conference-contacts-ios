//
//  taglineQuoteView.swift
//  swaap
//
//  Created by Marlon Raskin on 1/5/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import UIKit

@IBDesignable
class TaglineQuoteView: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		backgroundColor = .clear
	}

    override func draw(_ rect: CGRect) {
		let path = UIBezierPath()
		path.move(to: .zero)
		path.addLine(to: CGPoint(x: 0.0, y: self.bounds.maxY))

		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path.cgPath
		shapeLayer.strokeColor = UIColor.swaapAccentColorOne.cgColor
		shapeLayer.lineWidth = 2.0
		shapeLayer.lineCap = .round

		layer.addSublayer(shapeLayer)
    }
}
