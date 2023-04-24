//
//  APIRequestBuilderTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 23.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
@testable import Countries

final class APIRequestBuilderTests: XCTestCase {

    var sut: APIRequestBuilder!
    
    override func setUpWithError() throws {
        sut = APIRequestBuilder()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testBuilder_BuildsValidExcitelBaseURL() throws {
        let excitelBaseUrl = sut.appendExcitelCountriesBaseURL().buildURL()
        let expectedUrl = URL(string: "\(APIConstants.scheme)://\(APIConstants.host)")
        XCTAssertEqual(excitelBaseUrl, expectedUrl)
    }
    
    func testBuilder_BuildsValidEndpointUrl() throws {
        let endpoint: APIConstants.Endpoint = .countries
        
        let expectedEndpointUrl = URL(string: "\(APIConstants.scheme)://\(APIConstants.host)\(endpoint.rawValue)?")
        
        let actualEndpointUrl = sut.buildUrlForExcitelEndpoint(.countries, with: [:])
        
        XCTAssertEqual(actualEndpointUrl, expectedEndpointUrl)
    }
    
    func testBuilder_IncludesParameters_AsQueryParam() throws {
        let testParameters: [String: String] = ["testParamName1": "testParamValue1", "testParamName2": "testParamValue2"]
        
        guard let testUrl = sut.buildUrlForExcitelEndpoint(.countries, with: testParameters),
            let urlComponents = URLComponents(url: testUrl, resolvingAgainstBaseURL: true) else {
                XCTFail()
                return
        }
        
        testParameters.map(URLQueryItem.init).forEach {
            if !(urlComponents.queryItems?.contains($0) ?? false) {
                XCTFail()
                return
            }
        }

       XCTAssert(true)
    }
}
