//
//  GQuery.swift
//  swaap
//
//  Created by Michael Redig on 12/5/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation
import NetworkHandler

typealias GQuery = GQMutation<String>
struct GQMutation<T: Codable>: Codable {
	let query: String
	let variables: [String: T]?

	init(query: String, variables: [String: T]? = nil) {
		self.query = query
		self.variables = variables
	}
}

struct GQLMutationResponse: Codable {
	let code: Int
	let success: Bool
	let message: String
}

struct GQLMutationResponseContainer: Decodable {
	let response: GQLMutationResponse

	enum CodingKeys: String, CodingKey {
		case data
		case createUser
		case updateUser
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
		guard let key = dataContainer.allKeys.first else {
			throw NetworkError.unspecifiedError(reason: "Error decoding response: \(dataContainer.codingPath) - \(dataContainer)")
		}
		response = try dataContainer.decode(GQLMutationResponse.self, forKey: key)
	}
}
