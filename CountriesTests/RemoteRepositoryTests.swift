//
//  RemoteRepositoryTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
import Foundation
@testable import Countries

final class RemoteRepositoryTests: XCTestCase {
    
    var sut: RemoteRepository!
    var mockAPIResponseParser: MockApiResponseParser!
    var mockAPIClient: MockAPIClient!
    
    override func setUpWithError() throws {
        mockAPIResponseParser = MockApiResponseParser()
        mockAPIClient = MockAPIClient()
        sut = RemoteRepository(apiClient: mockAPIClient, apiResponseParser: mockAPIResponseParser)
    }

    override func tearDownWithError() throws {
        mockAPIResponseParser = nil
        mockAPIClient = nil
        sut = nil
    }
    
    func testParseCountriesAPIResponse_InvokesResponseParser_WithData() {
        let data = Data()
        let _ = sut.parseCountriesAPIResponse(data: data)
        XCTAssertEqual(mockAPIResponseParser.decodeJsonArrayInvokedData, data)
    }
    
    func testFetchCountriesSuccess_WithoutParameters() throws {
        let expectation = expectation(description: "Countries Response Is Decoded To Model Type")
        mockAPIClient.mockResult = .success(Data())

        sut.fetchCountries(parameters: [:]) { result in
            switch result {
            case .success(_):
                if self.mockAPIClient.getCountriesInvokationParameters.isEmpty {
                    expectation.fulfill()
                }
            default:
                break
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchCountriesFailure_WithParameters() throws {
        let expectation = expectation(description: "Countries Response Is Decoded To Model Type")
        mockAPIClient.mockResult = .failure(NetworkError.noResponseData)

        let parameters = ["testQueryKey": "testQueryParam"]
        
        sut.fetchCountries(parameters: parameters) { result in
            switch result {
            case .failure(_):
                if self.mockAPIClient.getCountriesInvokationParameters == parameters {
                    expectation.fulfill()
                }
            default:
                break
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

final class MockApiResponseParser: APIResponseParserProtocol {
    var decodeJsonArrayInvokedData: Data?
    
    func decodeJsonArray<T>(from jsonData: Data, returning type: T.Type) -> [T]? where T : Decodable {
        decodeJsonArrayInvokedData = jsonData
        return nil
    }
}

final class MockAPIClient: APIClientProtocol {

    var getCountriesInvokationParameters = [String: String]()
    var mockResult: Result<Data, NetworkError> = .success(Data())
    
    func getCountries(with parameters: [String : String], completion: @escaping APIResponseCompletion) {
        getCountriesInvokationParameters = parameters
        completion(mockResult)
    }
    
    func sendGetRequest(with url: URL, completion: @escaping APIResponseCompletion) {
        //no-op
    }
}
