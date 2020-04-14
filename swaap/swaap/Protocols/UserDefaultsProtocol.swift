//
//  UserDefaultsProtocol.swift
//  swaap
//
//  Created by Chad Rutherford on 4/14/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
	func objectForKey(_ key: String) -> Any?
	func setObject(_ object: Any, forKey key: String)
	func removeObjectForKey(_ key: String)
	func synchronizeAll()
}

extension UserDefaults: UserDefaultsProtocol {
	func objectForKey(_ key: String) -> Any? {
		self.object(forKey: key)
	}
	
	func setObject(_ object: Any, forKey key: String) {
		self.set(object, forKey: key)
	}
	
	func removeObjectForKey(_ key: String) {
		self.removeObject(forKey: key)
	}
	
	func synchronizeAll() {
		self.synchronize()
	}
}
