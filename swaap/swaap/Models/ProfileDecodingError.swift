//
//  ProfileDecodingError.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

enum ProfileDecodingError: Error {
	case unknownValue(value: String)
}
