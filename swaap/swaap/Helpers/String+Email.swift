//
//  String+Emqail.swift
//  swaap
//
//  Created by Marlon Raskin on 11/20/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

extension String {
    public var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
