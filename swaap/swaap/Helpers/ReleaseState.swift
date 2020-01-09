//
//  TestFlight.swift
//  swaap
//
//  Created by Michael Redig on 1/9/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import Foundation

/// To be used in determining the current release state of the build. For example, if it's in debug or on testflight,
/// it should use the staging backend server, but if it's on the app store it should use the production server.
enum ReleaseState: String {
	case debug
	case testFlight
	case appStore

	// untested as of writing - only once it's on the app store will it be confirmed
	private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

	static var current: ReleaseState {
		#if DEBUG
		return .debug
		#else
		return isTestFlight ? .testFlight : .appStore
		#endif
	}
}
