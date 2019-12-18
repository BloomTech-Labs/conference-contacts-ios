//
//  ProfileQRCode.swift
//  swaap
//
//  Created by Michael Redig on 12/18/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

struct ProfileQRCode: Codable, Hashable {
	let id: String
	let label: String
	let scans: Int
}
