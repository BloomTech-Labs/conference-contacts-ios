//
//  SwaapGQLQueries.swift
//  swaap
//
//  Created by Michael Redig on 12/20/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//
import Foundation

enum SwaapGQLQueries {

	// MARK: - ProfileController Queries
	static let userProfileFetchQuery = """
		query {
			user {
				\(SwaapGQLQueries.commonUserFields)
				qrcodes {
					id
					label
					scans
				}
			}
		}
		""".singleLine

	static let userProfileCreateMutation = """
		mutation CreateUser($user: CreateUserInput!) {
			createUser(data: $user) {
				success
				code
				message
			}
		}
		""".singleLine

	static let userProfileUpdateMutation = """
		mutation ($data: UpdateUserInput!) {
			updateUser(data:$data) {
				success
				code
				message
			}
		}
		""".singleLine

	static let userProfileCreateQRCodeMutation = """
		mutation ($label: String!) {
			createQRCode(label: $label) {
				success
				code
				message
			}
		}
		""".singleLine

	static let userProfileContactMethodsCreateMutation = """
		mutation CreateFields($data:[CreateProfileFieldInput]!) {
			createProfileFields(data: $data) {
				success
				code
				message
			}
		}
		""".singleLine

	static let userProfileContactMethodsUpdateMutation = """
		mutation UpdateFields($data:[UpdateProfileFieldsInput]!) {
			updateProfileFields(data: $data) {
				success
				code
				message
			}
		}
		""".singleLine

	static let userProfileContactMethodsDeleteMutation = """
		mutation($ids:[ID]!) {
			deleteProfileFields(ids: $ids) {
				success
				code
				message
			}
		}
		""".singleLine

	// MARK: - ContactsController Queries
	static let connectionCreateMutation = """
		mutation ($id:ID!, $coords: CoordinatesInput!) {
			createConnection(userID: $id, senderCoords: $coords) {
				success
				code
				message
			}
		}
		""".singleLine

	static let connectionFetchSingleUserQuery = """
		query ($id:ID!) {
			user(id: $id) {
		\(SwaapGQLQueries.commonUserFields)
			}
		}
		""".singleLine

	static let connectionFetchQRCodeQuery = """
		query ($id: ID!) {
			qrcode(id: $id) {
				id
				label
				scans
				user {
		\(SwaapGQLQueries.commonUserFields)
				}
			}
		}
		""".singleLine

	static let connectionFetchAllContactsQuery = """
		{
			user {
				sentConnections {
					id
					receiver {
		\(SwaapGQLQueries.commonUserFields)
					}
					senderLat
					senderLon
					receiverLat
					receiverLon
					status
				}
				receivedConnections {
					id
					sender {
		\(SwaapGQLQueries.commonUserFields)
					}
					senderLat
					senderLon
					receiverLat
					receiverLon
					status
				}
			}
		}
		""".singleLine

	// MARK: - Common
	private static let commonUserFields = """
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
		"""
}

fileprivate extension String {
	var singleLine: String {
		replacingOccurrences(of: ##"\s+"##, with: " ", options: .regularExpression, range: nil)
	}
}
