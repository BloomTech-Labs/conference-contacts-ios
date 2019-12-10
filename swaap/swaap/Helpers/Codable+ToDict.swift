//
//  Codable+ToDict.swift
//  swaap
//
//  Created by Michael Redig on 12/10/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation
import NetworkHandler

extension Encodable {
	func toDict() throws -> [String: Any] {
		let data = try JSONEncoder().encode(self)

		let jsonSerial = try JSONSerialization.jsonObject(with: data)
		guard let unwrapped = jsonSerial as? [String: Any] else {
			throw NetworkError.unspecifiedError(reason: "Error encoding to json dict: \(self)")
		}
		return unwrapped
	}
}
