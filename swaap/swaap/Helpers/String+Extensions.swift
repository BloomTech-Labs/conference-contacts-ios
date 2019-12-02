//
//  String+Emqail.swift
//  swaap
//
//  Created by Marlon Raskin on 11/20/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

extension String {
    public var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

	func hasAtLeastXCharacters(_ number: Int) -> Bool {
		return count >= number
	}

	var hasALowercaseCharacter: Bool {
		return rangeOfCharacter(from: .lowercaseLetters) != nil
	}

	var hasAnUppercaseCharacter: Bool {
		return rangeOfCharacter(from: .uppercaseLetters) != nil
	}

	var hasANumericalCharacter: Bool {
		return rangeOfCharacter(from: .decimalDigits) != nil
	}

	var hasASpecialCharacter: Bool {
		let specialSet = CharacterSet(charactersIn: ##".!@#$%^&*()-=+~?[]{};/\`"##)
		return rangeOfCharacter(from: specialSet) != nil
	}

	func hasPartOfEmailAddress(_ emailAddress: String?) -> Bool {
		guard !self.isEmpty else { return true }
		let lcEmail = emailAddress?.lowercased()
		let emailParts = lcEmail?.split(separator: "@")
		guard let alias = emailParts?.first,
			let domain = emailParts?.last?.split(separator: ".").first else { return false }
		let lcSelf = lowercased()

		return (lcSelf.contains(alias) || lcSelf.contains(domain))
	}
}
