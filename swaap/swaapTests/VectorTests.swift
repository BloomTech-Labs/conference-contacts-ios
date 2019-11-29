//
//  swaapTests.swift
//  swaapTests
//
//  Created by Marlon Raskin on 11/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import XCTest
@testable import swaap

class VectorTests: XCTestCase {
	// MARK: - CGAffineTransform
	func testTransformExtensions() {
		let expected = CGPoint(x: 1.4, y: 1.8)

		let transform = CGAffineTransform(translationX: expected.x, y: expected.y)
		let offset = transform.offset

		XCTAssertEqual(expected, offset)
	}

	// MARK: - CGVector
	func testVectorAdd() {
		let expected = CGVector(dx: 5, dy: 2)

		let addend1 = CGVector(dx: 3, dy: 0)
		let addend2 = CGVector(dx: 2, dy: 2)

		let result = addend1 + addend2

		XCTAssertEqual(expected, result)
	}

	func testVectorFromPoint() {
		let point = CGPoint(x: 20, y: 25)
		let expected = CGVector(dx: 20, dy: 25)

		let result = point.vector

		XCTAssertEqual(expected, result)
	}

	func testVectorNormalize() {
		let vectorA = CGVector(dx: 10, dy: 10)
		let vectorB = CGVector.zero
		let vectorC = CGVector(dx: -50, dy: 20)
		let vectorD = CGVector(dx: 0, dy: 20)

		let expectedA = CGVector(dx: 0.7071067811865475, dy: 0.7071067811865475)
		let expectedB = CGVector(dx: 0, dy: 1)
		let expectedC = CGVector(dx: -0.9284766908852593, dy: 0.3713906763541037)
		let expectedD = CGVector(dx: 0, dy: 1)

		XCTAssertEqual(expectedA, vectorA.normalized)
		XCTAssertEqual(expectedB, vectorB.normalized)
		XCTAssertEqual(expectedC, vectorC.normalized)
		XCTAssertEqual(expectedD, vectorD.normalized)
	}

	func testGetVectorFromTwoPoints() {
		let pointA = CGPoint.zero
		let pointB = CGPoint(x: 0, y: 20)
		let pointC = CGPoint(x: -14, y: 60)
		let pointD = CGPoint(x: -38.54, y: -96.2)

		let expectedABNormalized = CGVector(dx: 0, dy: 1)
		let expectedAB = CGVector(dx: 0, dy: 20)
		let expectedBANormalized = CGVector(dx: 0, dy: -1)
		let expectedBA = CGVector(dx: 0, dy: -20)
		let expectedAANormalized = CGVector(dx: 0, dy: 1)
		let expectedAA = CGVector(dx: 0, dy: 0)

		let expectedBC = CGVector(dx: -14, dy: 40)
		let expectedBCNormalized = CGVector(dx: -0.3303504247281061, dy: 0.9438583563660173)

		let expectedCD = CGVector(dx: -24.54, dy: -156.2)
		let expectedCDNormalized = CGVector(dx: -0.15520256497441642, dy: -0.9878826670335714)


		XCTAssertEqual(expectedABNormalized, pointA.vector(facing: pointB))
		XCTAssertEqual(expectedAB, pointA.vector(facing: pointB, normalized: false))
		XCTAssertEqual(expectedBANormalized, pointB.vector(facing: pointA))
		XCTAssertEqual(expectedBA, pointB.vector(facing: pointA, normalized: false))
		XCTAssertEqual(expectedAANormalized, pointA.vector(facing: pointA))
		XCTAssertEqual(expectedAA, pointA.vector(facing: pointA, normalized: false))

		XCTAssertEqual(expectedBCNormalized, pointB.vector(facing: pointC))
		XCTAssertEqual(expectedBC, pointB.vector(facing: pointC, normalized: false))

		XCTAssertEqual(expectedCDNormalized, pointC.vector(facing: pointD))
		XCTAssertEqual(expectedCD, pointC.vector(facing: pointD, normalized: false))
	}

	func testVectorInversion() {
		let vectorA = CGVector.zero
		let vectorB = CGVector(dx: -50, dy: 20)

		let expectedA = CGVector.zero
		let expectedB = CGVector(dx: 50, dy: -20)

		XCTAssertEqual(expectedA, vectorA.inverted)
		XCTAssertEqual(expectedB, vectorB.inverted)
	}

	func testVectorMultiplyByScalar() {
		let vectorA = CGVector.zero
		let vectorB = CGVector(dx: -50, dy: 20)

		let expectedA = CGVector.zero
		let expectedB = CGVector(dx: -100, dy: 40)

		XCTAssertEqual(expectedA, vectorA * 2)
		XCTAssertEqual(expectedB, vectorB * 2)
	}

	// MARK: - CGSize
	func testSizeMultiplyByScalar() {
		let sizeA = CGSize(width: 3, height: 5)
		let sizeB = CGSize(width: -20, height: 60)

		let scalarA: CGFloat = 10
		let scalarB: CGFloat = -2

		let expected = CGSize(width: 30, height: 50)
		let expectedB = CGSize(width: 40, height: -120)

		XCTAssertEqual(expected, sizeA * scalarA)
		XCTAssertEqual(expectedB, sizeB * scalarB)
	}

	// MARK: - CGPoint
	func testConvertFromSize() {
		let size = CGSize(width: -20, height: 50)
		let expected = CGPoint(x: -20, y: 50)

		XCTAssertEqual(expected, size.toPoint)
	}

	func testPointDistance() {
		let pointA = CGPoint(x: 0, y: 20)
		let pointB = CGPoint(x: 50, y: 30)
		let pointC = CGPoint(x: -14, y: 60)
		let pointD = CGPoint(x: -38.54, y: -96.205)
		let pointE = CGPoint.zero

		XCTAssertEqual(20, pointA.distance(to: pointE))
		XCTAssertEqual(70.6824, pointB.distance(to: pointC), accuracy: 0.0001)
		XCTAssertEqual(58.3095, pointB.distance(to: pointE), accuracy: 0.0001)
		XCTAssertEqual(122.4293, pointD.distance(to: pointA), accuracy: 0.0001)
		XCTAssertEqual(103.6375, pointD.distance(to: pointE), accuracy: 0.0001)
	}

	func testPointDistanceWithin() {
		let pointA = CGPoint.zero
		let pointB = CGPoint(x: 0, y: 1)
		let pointC = CGPoint(x: 0, y: 0.5)

		XCTAssertTrue(pointA.distance(to: pointB, isWithin: 1))
		XCTAssertTrue(pointA.distance(to: pointB, isWithin: 1.0001))
		XCTAssertFalse(pointA.distance(to: pointB, isWithin: 0.999))
		XCTAssertTrue(pointA.distance(to: pointB, isWithin: 100))

		XCTAssertTrue(pointA.distance(to: pointC, isWithin: 1))
		XCTAssertTrue(pointA.distance(to: pointC, isWithin: 0.5))
		XCTAssertFalse(pointA.distance(to: pointC, isWithin: 0.4999))
		XCTAssertTrue(pointA.distance(to: pointC, isWithin: 100))

	}
}
