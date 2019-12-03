//
//  HapticFeedback.swift
//  tipsy
//
//  Created by Marlon Raskin on 11/10/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

enum HapticFeedback {
	static let lightFeedback = UIImpactFeedbackGenerator(style: .light)
	static let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
	static let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
	static let softFeedback = UIImpactFeedbackGenerator(style: .soft)
	static let feedback = UISelectionFeedbackGenerator()


	static func produceLightFeedback() {
		if true {
			lightFeedback.impactOccurred()
		}
	}

	static func produceMediumFeedback() {
		if true {
			mediumFeedback.impactOccurred()
		}
	}

	static func produceHeavyFeedback() {
		if true {
			heavyFeedback.impactOccurred()
		}
	}

	static func produceSoftFeedback() {
		if true {
			softFeedback.impactOccurred()
		}
	}

	static func produceSelectionFeedback() {
		if true {
			feedback.selectionChanged()
		}
	}
}
