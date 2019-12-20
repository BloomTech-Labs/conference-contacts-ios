//
//  HapticFeedback.swift
//  tipsy
//
//  Created by Marlon Raskin on 11/10/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class HapticFeedback {

	static let shared = HapticFeedback()

	private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
	private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
	private let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
	private let softFeedback = UIImpactFeedbackGenerator(style: .soft)
	private let rigidFeedback = UIImpactFeedbackGenerator(style: .rigid)
	private let selectionFeedback = UISelectionFeedbackGenerator()

	private init() {
		[lightFeedback, mediumFeedback, heavyFeedback, softFeedback, rigidFeedback, selectionFeedback].forEach { $0.prepare() }
	}

	static func produceLightFeedback() {
		shared.lightFeedback.impactOccurred()
	}

	static func produceMediumFeedback() {
		shared.mediumFeedback.impactOccurred()
	}

	static func produceHeavyFeedback() {
		shared.heavyFeedback.impactOccurred()
	}

	static func produceSoftFeedback() {
		shared.softFeedback.impactOccurred()
	}

	static func produceRigidFeedback() {
		shared.rigidFeedback.impactOccurred()
	}

	static func produceSelectionFeedback() {
		shared.selectionFeedback.selectionChanged()
	}
}
