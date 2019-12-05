//
//  GQuery.swift
//  swaap
//
//  Created by Michael Redig on 12/5/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

struct GQuery<T: Codable>: Codable {
	let query: String
	let variables: [String: T]?
}

struct UserMutationResponse: Codable {
	let code: Int
	let success: Bool
	let message: String
	let user: UserProfile?
}
