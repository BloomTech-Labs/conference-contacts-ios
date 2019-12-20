//
//  SwaapGQLQueries.swift
//  swaap
//
//  Created by Michael Redig on 12/20/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable line_length

import Foundation

enum SwaapGQLQueries {

	static let createConnectionMutation = "mutation ($id:ID!, $coords: CoordinatesInput!) { createConnection(userID: $id, senderCoords: $coords) { success code message } }"

	static let fetchUserProfileQuery = """
										query {
											user {
												id
												authId
												name
												picture
												birthdate
												location
												industry
												jobtitle
												tagline
												bio
												profile {
													id
													value
													type
													privacy
													preferredContact
												}
												qrcodes {
													id
													label
													scans
												}
											}
										}
										""".singleLine

	

}

fileprivate extension String {
	var singleLine: String {
		replacingOccurrences(of: ##"\s+"##, with: " ", options: .regularExpression, range: nil)
	}
}
