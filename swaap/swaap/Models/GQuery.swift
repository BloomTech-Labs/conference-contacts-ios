//
//  GQuery.swift
//  swaap
//
//  Created by Michael Redig on 12/5/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation
import NetworkHandler

// MARK: - sending
typealias GQuery = GQMutation
struct GQMutation {
	let query: String
	let variables: [String: Any]?

	init(query: String, variables: [String: Any]? = nil) {
		self.query = query
		self.variables = variables
	}

	func jsonData(_ prettyPrinted: Bool = false) throws -> Data {
		var theDict: [String: Any] = ["query": query]
		if let variables = variables {
			theDict["variables"] = variables
		}
		let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
		return try JSONSerialization.data(withJSONObject: theDict, options: options)
	}
}

// MARK: - receiving
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
		case createProfileField
		case updateProfileField
		case deleteProfileField
		case createProfileFields
		case updateProfileFields
		case deleteProfileFields
		case createQRCode
		case createConnection
		case acceptConnection
		case deleteConnection
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
		guard let key = dataContainer.allKeys.first else {
			throw NetworkError.unspecifiedError(reason: "Error decoding response (check coding keys in \(#file)\(#line): \(dataContainer.codingPath) - \(dataContainer)")
		}
		response = try dataContainer.decode(GQLMutationResponse.self, forKey: key)
	}
}
