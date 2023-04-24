//
//  APIResponserParserTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 23.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
@testable import Countries

final class APIResponserParserTests: XCTestCase {

    var sut: APIResponseParser!
    
    override func setUpWithError() throws {
        sut = APIResponseParser()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testParserDecodesTypeFromValidJSONArray() throws {
        let validMockCountryArray = ModelMockFactory.mockCountries
        let jsonData = try JSONEncoder().encode(validMockCountryArray)
        let parseResult = sut.decodeJsonArray(from: jsonData, returning: Country.self)
        XCTAssertEqual(parseResult?.count, validMockCountryArray.count)
    }
}
