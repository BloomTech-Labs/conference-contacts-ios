//
//  JWTClaims.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

struct Auth0IDClaims: Codable {
	let nickname: String
	let name: String
	let email: String
	let sub: String
	// some auth methods provide a string "true/false" and others provide a true boolean. not worth fixing unless we actually need it
//	let emailVerified: Bool
	let picture: URL?
	let iat: Date
	let exp: Date
}
