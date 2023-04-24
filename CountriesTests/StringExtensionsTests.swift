//
//  StringExtensionsTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
import Foundation
@testable import Countries

class StringExtensionsTests: XCTestCase {

    func testFormatPoints_LessThanThousand() throws {
        let number = 999
        
        let expected = String(describing: number)
        let actual = String.formatPoints(from: number)
        
        XCTAssertEqual(actual, expected)
    }
    
    func testFormatPoints_Thousands() throws {
        let number = 99_999
        
        let expected = "100.0K"
        let actual = String.formatPoints(from: number)
        
        XCTAssertEqual(actual, expected)
    }
    
    func testFormatPoints_Millions() throws {
        let number = 999_999
        
        let expected = "1.0M"
        let actual = String.formatPoints(from: number)
        
        XCTAssertEqual(actual, expected)
    }
    
    func testFormatPoints_Billions() throws {
        let number = 999_999_999
        
        let expected = "1.0B"
        let actual = String.formatPoints(from: number)
        
        XCTAssertEqual(actual, expected)
    }
}
