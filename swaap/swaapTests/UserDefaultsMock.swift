//
//  UserDefaultsMock.swift
//  swaapTests
//
//  Created by Chad Rutherford on 4/20/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import Foundation
@testable import swaap

class UserDefaultsMock: NSObject, UserDefaultsProtocol {
	private var dict = [String: Any]()
	
	deinit {
		dict.removeAll()
	}
	
	func objectForKey(_ key: String) -> Any? {
		dict[key]
	}
	
	func setObject(_ object: Any, forKey key: String) {
		dict[key] = object
	}
	
	func removeObjectForKey(_ key: String) {
		dict.removeValue(forKey: key)
	}
	
	func synchronizeAll() {
		
	}
}
