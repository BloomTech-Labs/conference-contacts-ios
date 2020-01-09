//
//  String+Emqail.swift
//  swaap
//
//  Created by Marlon Raskin on 11/20/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

// MARK: - Validation
extension String {
    public var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

	func hasAtLeastXCharacters(_ number: Int) -> Bool { count >= number }

	var hasALowercaseCharacter: Bool { rangeOfCharacter(from: .lowercaseLetters) != nil }

	var hasAnUppercaseCharacter: Bool { rangeOfCharacter(from: .uppercaseLetters) != nil }

	var hasANumericalCharacter: Bool { rangeOfCharacter(from: .decimalDigits) != nil }

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

// MARK: - Base64 Coding
extension String {
	/// Meant to be used when the string is alread Base64 encoded data
	var toBase64URL: String {
		replacingOccurrences(of: "+", with: "-")
		.replacingOccurrences(of: "/", with: "_")
		.replacingOccurrences(of: "=", with: "")
	}

	/// Meant to be used when the string is Base64URL encoded data
	var toBase64: String {
		var base64 = replacingOccurrences(of: "-", with: "+")
			.replacingOccurrences(of: "_", with: "/")
		if !base64.count.isMultiple(of: 4) {
			let padding = String(repeating: "=", count: 4 - base64.count % 4)
			base64 += padding
		}
		return base64
	}
}
