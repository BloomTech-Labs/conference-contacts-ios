//
//  isUITesting.swift
//  swaap
//
//  Created by Chad Rutherford on 4/20/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import UIKit

var isUITesting: Bool {
	CommandLine.arguments.contains("UITesting")
}
