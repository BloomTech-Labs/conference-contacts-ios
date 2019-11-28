//
//  VectorExtensions.swift
//  swaap
//
//  Created by Michael Redig on 11/28/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import CoreGraphics

extension CGSize {
	static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
		return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
	}

	var toPoint: CGPoint {
		CGPoint(x: width, y: height)
	}
}
