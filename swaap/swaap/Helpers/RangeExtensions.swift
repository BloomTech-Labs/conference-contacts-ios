//
//  RangeExtensions.swift
//  swaap
//
//  Created by Michael Redig on 11/29/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

extension ClosedRange where Bound: BinaryFloatingPoint {
	func normalizedIndex(_ value: Bound) -> Double {
		let value = Double(value - lowerBound)
		let upper = Double(upperBound - lowerBound)

		return value / upper
	}
}

extension ClosedRange where Bound: FixedWidthInteger {
	func normalizedIndex(_ value: Bound) -> Double {
		let value = Double(value - lowerBound)
		let upper = Double(upperBound - lowerBound)

		return value / upper
	}
}
