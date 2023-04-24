//
//  CountryDetailsViewControllerTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Countries

class CountryDetailsViewControllerTests: XCTestCase {

    var sut: CountryDetailsViewController!
    
    func makeSUT() -> CountryDetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(identifier: "CountryDetailsViewController") as! CountryDetailsViewController
        sut.loadViewIfNeeded()
        return sut
    }
    
    override func setUpWithError() throws {
        sut = makeSUT()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testViewDidLoad_CallsViewModel() throws {
        let mockViewModel = MockCountryDetailsViewModel()
        
        sut.viewModel = mockViewModel
        sut.viewDidLoad()
        
        XCTAssertTrue(mockViewModel.onViewLoadedCalled)
    }
    
    func testLoadingIndicatorShownInNavBarDuringLoad_AndReplacedByTitleAfterLoad() throws {
        let testTitle = "Test Title"
        let mockViewModel = MockCountryDetailsViewModel()
        mockViewModel.title = testTitle
        
        sut.viewModel = mockViewModel
        sut.viewDidLoad()
        
        XCTAssert(sut.navigationItem.titleView?.isKind(of: UIActivityIndicatorView.self) ?? false)

        sut.updateUI()
        
        XCTAssert(sut.navigationItem.titleView?.isKind(of: UILabel.self) ?? false)
        XCTAssertEqual(sut.navigationItem.title, testTitle)
    }
    
    func testUpdateUI_WithAllCountryMetaDataPresent() throws {
        let testTitle = "Country Title, Region"
        let testCapital = "Country Capital"
        let testPopulation = "1.2M"
        let testLocation = CLLocationCoordinate2D(latitude: 23, longitude: 34)
        
        let mockViewModel = MockCountryDetailsViewModel()
        mockViewModel.title = testTitle
        mockViewModel.capital = testCapital
        mockViewModel.population = testPopulation
        mockViewModel.location = testLocation
        
        sut.viewModel = mockViewModel
        sut.viewDidLoad()
        sut.updateUI()
        
        XCTAssertEqual(sut.navigationItem.title, testTitle)
        XCTAssertFalse(sut.capitalView.isHidden)
        XCTAssertEqual(sut.capitalView.textLabel.text, testCapital)
        XCTAssertFalse(sut.populationView.isHidden)
        XCTAssertEqual(sut.populationView.textLabel.text, testPopulation)
        XCTAssertEqual(round(sut.mapView.region.center.latitude), round(testLocation.latitude))
        XCTAssertEqual(round(sut.mapView.region.center.longitude), round(testLocation.longitude))
    }
    
    func testUpdateUI_HidesUIComponents_WithMissingCountryMetaData() throws {
        let mockViewModel = MockCountryDetailsViewModel()
        mockViewModel.capital = nil
        mockViewModel.population = nil
        mockViewModel.location = nil
        mockViewModel.flagPhotoUrl = nil
        
        sut.viewModel = mockViewModel
        sut.viewDidLoad()
        sut.updateUI()
        
        XCTAssert(sut.capitalView.isHidden)
        XCTAssert(sut.populationView.isHidden)
        XCTAssert(sut.mapView.isHidden)
        XCTAssert(sut.flagPhotoImageView.isHidden)
    }
}

class MockCountryDetailsViewModel: CountryDetailsViewModelProtocol {
    var country: Country?
    
    var onViewLoadedCalled = false

    func viewDidLoad() {
        onViewLoadedCalled = true
    }

    var updateUI: Observable<Void> = Observable<Void>(())

    var title: String = ""

    var location: CLLocationCoordinate2D?

    var population: String?

    var capital: String?

    var flagPhotoUrl: URL?

    func updateOutput(with country: Country) {
        //no-op
    }
}
