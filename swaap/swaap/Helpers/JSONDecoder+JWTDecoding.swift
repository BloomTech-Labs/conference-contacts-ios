//
//  JSONDecoder+JWTDecoding.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

extension JSONDecoder {
	enum JWTError: Error {
		case invalidJWTString
	}
	func decode<T>(_ type: T.Type, fromJWT jwtString: String) throws -> T where T: Decodable {
		let splitString = jwtString.split(separator: ".")
		guard splitString.count == 3 else { throw JWTError.invalidJWTString }
		let base64Data = String(splitString[1])
		guard let data = Data(base64Encoded: base64Data.toBase64) else {
			throw JWTError.invalidJWTString
		}

		return try decode(type, from: data)
	}
}
