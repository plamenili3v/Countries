//
//  String+Extensions.swift
//  Countries
//
//  Created by Plamen I. Iliev on 23.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import Foundation

extension String {
    static func formatPoints(from: Int) -> String {
        let number = Double(from)
        let billion = number / 999_999_999
        let million = number / 999_999
        let thousand = number / 1000
        
        if billion >= 1.0 {
            return "\(round(billion * 10) / 10)B"
        } else if million >= 1.0 {
            return "\(round(million * 10) / 10)M"
        } else if thousand >= 1.0 {
            return "\(round(thousand * 10) / 10)K"
        } else {
            return "\(Int(number))"
        }
    }
}
