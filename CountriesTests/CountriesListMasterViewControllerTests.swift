//
//  CountriesListMasterViewControllerTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
@testable import Countries

class CountriesListMasterViewControllerTests: XCTestCase {

    var sut: CountriesListMasterViewController!
    
    func makeSUT() -> CountriesListMasterViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(identifier: "CountriesListMasterViewController") as! CountriesListMasterViewController
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
        let mockViewModel = MockCountriesListViewModel()
        
        sut.viewModel = mockViewModel
        sut.viewDidLoad()
        
        XCTAssertTrue(mockViewModel.onViewLoadedCalled)
    }
    
    func testRefreshItems_CallsViewModel() throws {
        let mockViewModel = MockCountriesListViewModel()
        
        sut.viewModel = mockViewModel
        sut.refreshItems()
        
        XCTAssertTrue(mockViewModel.onRefreshItemsCalled)
    }
    
    func testSearchTerm_CallsViewModel() throws {
        let searchTerm = "Search"
        let mockViewModel = MockCountriesListViewModel()
        
        sut.viewModel = mockViewModel
        sut.viewDidLoad()
        sut.handleSearchBarInputText(searchTerm)
        
        XCTAssertEqual(searchTerm, mockViewModel.searchTermInvoked)
    }
    
    func testLoadingIndicatorShownInNavBarDuringLoad_AndReplacedByTitleAfterLoad() throws {
        let title = sut.title
        
        let mockViewModel = MockCountriesListViewModel()
        mockViewModel.items.value = [CountryListItemViewModel(titleText: "Test")]
        
        sut.viewModel = mockViewModel
        sut.viewDidLoad()
        
        XCTAssert(sut.navigationItem.titleView?.isKind(of: UIActivityIndicatorView.self) ?? false)

        sut.updateUI()
        
        XCTAssert(sut.navigationItem.titleView?.isKind(of: UILabel.self) ?? false)
        XCTAssertEqual(sut.navigationItem.title, title)
    }
    
    func testRefreshControl_AndLoadingIndicator_BecomeHiddenWhenErrorOccurs() throws {
        let mockViewModel = MockCountriesListViewModel()
        
        sut.viewModel = mockViewModel
        sut.showError("Error")
        
        XCTAssert(sut.navigationItem.titleView?.isKind(of: UILabel.self) ?? false)
        XCTAssertFalse(sut.refreshControl?.isRefreshing ?? true)
    }
}

class MockCountriesListViewModel: CountriesListViewModelProtocol {
    var onViewLoadedCalled = false
    var onRefreshItemsCalled = false
    var searchTermInvoked = ""
    
    func viewDidLoad() {
        onViewLoadedCalled = true
    }
    
    func didRequestRefreshItems() {
        onRefreshItemsCalled = true
    }
    
    func searchCountry(searchTerm: String) {
        searchTermInvoked = searchTerm
    }
    
    func countryAtIndex(_ index: Int) -> Country {
        return ModelMockFactory.mockCountry1
    }
    
    var items: Observable<[CountryListItemViewModel]> = Observable<[CountryListItemViewModel]>([])
    var error: Observable<String> = Observable<String>("")
}
