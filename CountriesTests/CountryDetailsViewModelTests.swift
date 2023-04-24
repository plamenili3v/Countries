//
//  CountryDetailsViewModelTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
@testable import Countries

class CountryDetailsViewModelTests: XCTestCase {

    var sut: CountryDetailsViewModel!
    
    let mockCountry = ModelMockFactory.mockCountry1
    
    override func setUpWithError() throws {
        sut = CountryDetailsViewModel(country: mockCountry)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testUpdateOutput() throws {
        sut.updateOutput(with: mockCountry)
        XCTAssertEqual(sut.title, "\(mockCountry.name!), \(mockCountry.region!)")
        XCTAssertEqual(sut.capital, mockCountry.capitalName)
        XCTAssertEqual(sut.population, (String.formatPoints(from: mockCountry.population!)))
        XCTAssertEqual(sut.location?.latitude, mockCountry.latLng?.first)
        XCTAssertEqual(sut.location?.longitude, mockCountry.latLng?.last)
    }
}
