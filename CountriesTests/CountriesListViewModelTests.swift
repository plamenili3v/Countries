//
//  CountriesListViewModelTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
@testable import Countries

class CountriesListViewModelTests: XCTestCase {

    var sut: CountriesListViewModel!
    var mockRepository: MockRepository!
    
    override func setUpWithError() throws {
        mockRepository = MockRepository()
        sut = CountriesListViewModel(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        sut = nil
    }

    func testFetchCountries_Success() throws {
        let mockCountries = ModelMockFactory.mockCountries
        
        mockRepository.mockResult = .success(mockCountries)
        sut.fetchCountries()
        
        XCTAssertEqual(sut.countries.count, mockCountries.count)
        
        mockCountries.forEach{
            XCTAssert(sut.countries.contains($0))
        }
        
        XCTAssertEqual(sut.items.value, sut.countries.map(CountryListItemViewModel.init))
    }
    
    func testFetchCountries_Error() throws {
        mockRepository.mockResult = .failure(.notConnected)
        sut.fetchCountries()
        
        XCTAssertEqual(sut.error.value, NetworkError.notConnected.localizedDescription)
    }
    
    func testCountriesAreSorted_AfterFetch() throws {
        let mockCountries = ModelMockFactory.mockCountries
        
        mockRepository.mockResult = .success(mockCountries)
        sut.fetchCountries()
        
        let expected = mockCountries.sorted(by: { country1, country2 in
            country1.population ?? 0 > country2.population ?? 0
        })
        let actual = sut.countries
        
        XCTAssertEqual(actual, expected)
    }
    
    func testSearchCountry_ItemsPopulatedWithAllCountries_WhenSearchIsEmpty() {
        let mockCountries = ModelMockFactory.mockCountries
        
        mockRepository.mockResult = .success(mockCountries)
        sut.fetchCountries()
        
        sut.searchCountry(searchTerm: "")
        
        XCTAssert(sut.searchResultCountries.isEmpty)
        XCTAssertEqual(sut.countries.count, sut.items.value.count)
    }
    
    func testSearchCountry_ItemsPopulatedWithSearchResults_WhenSearchTermIsLongerThanThreeCharacters() {
        let mockCountries = ModelMockFactory.mockCountries
        let searchTerm = String(mockCountries.compactMap{ $0.name }.first!.prefix(3))
        
        mockRepository.mockResult = .success(mockCountries)
        sut.fetchCountries()
        
        sut.searchCountry(searchTerm: searchTerm)
        
        let mockCountriesMatchingSearch = mockCountries.filter{ $0.name!.contains(searchTerm) }
        
        XCTAssertEqual(sut.searchResultCountries, mockCountriesMatchingSearch)
    }
    
    func testSearchCountry_IgnoresSearchTerm_WithLessThanThreeCharacters() {
        let mockCountries = ModelMockFactory.mockCountries
        let searchTerm = "So"
        
        mockRepository.mockResult = .success(mockCountries)
        sut.fetchCountries()
        
        sut.searchCountry(searchTerm: searchTerm)
        
        XCTAssert(sut.searchResultCountries.isEmpty)
    }
    
    func testSearchCountry_IsCaseInsensitive() {
        let mockCountries = ModelMockFactory.mockCountries
        let searchTerm = String(mockCountries.compactMap{ $0.name }.first!.prefix(3)).uppercased()
        
        mockRepository.mockResult = .success(mockCountries)
        sut.fetchCountries()
        
        sut.searchCountry(searchTerm: String(searchTerm))
        
        let mockCountriesMatchingSearch = mockCountries.filter{ $0.name!.lowercased().contains(searchTerm.lowercased()) }
        
        XCTAssertEqual(sut.searchResultCountries, mockCountriesMatchingSearch)
    }
}

class MockRepository: RepositoryProtocol {
    var mockResult: Result<[Country], NetworkError> = .success([])
    
    func fetchCountries(completion: @escaping (Result<[Country], NetworkError>) -> ()) {
        completion(mockResult)
    }
}
