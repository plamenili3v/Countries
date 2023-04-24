//
//  CountryListItemViewModelTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
@testable import Countries

class CountryListItemViewModelTests: XCTestCase {

    func test_InitWith_CountryName_AndRegion() throws {
        let countryWithNameAndRegion = Country(capitalName: nil, code: nil, flag: nil, latLng: nil, name: "Country Name",
                                               population: nil, region: "Country Region", subregion: nil)
        let countryListItem = CountryListItemViewModel(country: countryWithNameAndRegion)
        
        XCTAssertEqual(countryListItem.titleText, "Country Name, Country Region")
    }
    
    func test_InitWith_CountryName_NoRegion() throws {
        let countryWithNameAndRegion = Country(capitalName: nil, code: nil, flag: nil, latLng: nil, name: "Country Name",
                                               population: nil, region: nil, subregion: nil)
        let countryListItem = CountryListItemViewModel(country: countryWithNameAndRegion)
        
        XCTAssertEqual(countryListItem.titleText, "Country Name")
    }
    
    func test_InitWith_NoCountryName_HavingRegion() throws {
        let countryWithNameAndRegion = Country(capitalName: nil, code: nil, flag: nil, latLng: nil, name: nil,
                                               population: nil, region: "Country Region", subregion: nil)
        let countryListItem = CountryListItemViewModel(country: countryWithNameAndRegion)
        
        XCTAssertEqual(countryListItem.titleText, "Unknown, Country Region")
    }
    
    func test_InitWith_NoCountryName_NoRegion() throws {
        let countryWithNameAndRegion = Country(capitalName: nil, code: nil, flag: nil, latLng: nil, name: nil,
                                               population: nil, region: nil, subregion: nil)
        let countryListItem = CountryListItemViewModel(country: countryWithNameAndRegion)
        
        XCTAssertEqual(countryListItem.titleText, "Unknown")
    }
}
