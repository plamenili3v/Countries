//
//  MobileTaskTests.swift
//  MobileTaskTests
//
//  Created by Plamen I. Iliev on 27.08.20.
//  Copyright © 2020 Plamen I. Iliev. All rights reserved.
//

import XCTest
@testable import MobileTask


class RatingViewTests: XCTestCase {

    var starsView: TitledRatingView!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        starsView = TitledRatingView(frame: .zero)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
         starsView = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let maxRating = 5
        
        starsView.setupRatingView(maxRating: 5, ratingImage: UIKitConstants.ImageAssets.kStar!,
                                   ratingImageEmptyColor: .black, ratingImageFillColor: .orange)
        
        XCTAssert(starsView.starsContainer.arrangedSubviews.count == maxRating)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
