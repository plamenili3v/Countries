//
//  CountriesUITests.swift
//  CountriesUITests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest

class CountriesUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSearchCountryFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tableView = app.tables.firstMatch
        XCTAssert(tableView.exists)
        
        tableView.swipeDown()
        
        let searchField = app.searchFields.firstMatch
        XCTAssert(searchField.exists)
        XCTAssertEqual(searchField.placeholderValue, "Search For Country")
        
        searchField.tap()
        searchField.typeText("ASDF")
        
        XCTAssert(app.staticTexts["NO RESULTS"].waitForExistence(timeout: 5))
        XCTAssertEqual(tableView.cells.count, 1)
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssert(cancelButton.exists)
        XCTAssert(cancelButton.isHittable)
        
        cancelButton.tap()
        
        searchField.tap()
        searchField.typeText("Bul")
        
        tableView.cells.firstMatch.tap()
        
        XCTAssert(app.staticTexts["Bulgaria, Europe"].exists)
        XCTAssert(app.staticTexts["Capital"].exists)
        XCTAssert(app.staticTexts["Sofia"].exists)
        XCTAssert(app.staticTexts["Population"].exists)
        XCTAssert(app.staticTexts["6.9M"].exists)
        
        let backButton = app.navigationBars.children(matching: .button).firstMatch
        XCTAssert(backButton.exists)
        backButton.tap()
        
        cancelButton.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
