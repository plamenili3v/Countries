//
//  APIClientTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//
import XCTest
import Foundation
@testable import Countries

final class APIClientTests: XCTestCase {
    let validMockUrl = URL(string: "https://mockHost.com/mockEndpoint")!
    let invalidMockUrl = URL(string: "https$:/mockHost&.com^/mockEndpoint")
    
    var sut: APIClient!
    var mockUrlSession: MockURLSession!
    var mockAPIRequestBuilder: MockAPIRequestBuilder!
    
    override func setUpWithError() throws {
        mockUrlSession = MockURLSession()
        mockAPIRequestBuilder = MockAPIRequestBuilder()
        sut = APIClient(urlSession: mockUrlSession, requestBuilder: mockAPIRequestBuilder)
    }

    override func tearDownWithError() throws {
        mockUrlSession = nil
        sut = nil
    }
    
    func testSendGetRequest() throws {
        let dataTask = MockURLSessionDataTask()
        mockUrlSession.dataTask = dataTask

        sut.sendGetRequest(with: validMockUrl) { _ in
            // no-op
        }

        XCTAssert(dataTask.resumeWasCalled)
        XCTAssertEqual(mockUrlSession.requestURL, validMockUrl)
    }
    
    func testGetCountries_InvalidUrl_ReturnsErrorWithoutSendingRequest() throws {
        let dataTask = MockURLSessionDataTask()
        mockUrlSession.dataTask = dataTask
        mockAPIRequestBuilder.mockUrl = invalidMockUrl
        
        let expectation = expectation(description: "Fetch Failure Invalid Url")
        
        sut.getCountries(with: [:]) { result in
            switch result {
            case .failure(let error) where error == NetworkError.invalidUrl:
                expectation.fulfill()
            default:
                break
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetCountries_ValidUrl_ReturnsDataFromRequest() throws {
        let mockData = Data()
        
        mockAPIRequestBuilder.mockUrl = validMockUrl
        mockUrlSession.data = Data()
        
        let expectation = expectation(description: "Fetch Success And Received Data")
        
        sut.getCountries(with: [:]) { result in
            switch result {
            case .success(let data) where data == mockData :
                expectation.fulfill()
            default:
                break
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetCountries_ValidUrl_ReturnsErrorFromRequest() throws {
        mockAPIRequestBuilder.mockUrl = validMockUrl
        mockUrlSession.error = NetworkError.noResponseData
        
        let expectation = expectation(description: "Fetch Failure No Received Data")
        
        sut.getCountries(with: [:]) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testResolveError_Generic() throws {
        let expected = NetworkError.generic(URLError(.cannotFindHost))
        let actual = sut.resolve(errorCode: URLError.cannotFindHost.rawValue)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testResolveError_NotConnectedToInternet() throws {
        let expected = NetworkError.notConnected
        let actual = sut.resolve(errorCode: URLError.notConnectedToInternet.rawValue)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testResolveError_Cancelled() throws {
        let expected = NetworkError.cancelled
        let actual = sut.resolve(errorCode: URLError.cancelled.rawValue)
        
        XCTAssertEqual(expected, actual)
    }
}

final class MockAPIRequestBuilder: APIRequestBuilder {
    var mockUrl: URL?
    
    override func buildUrlForExcitelEndpoint(_ endpoint: APIConstants.Endpoint, with parameters: [String : Any]) -> URL? {
        return mockUrl
    }
}

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}

final class MockURLSession: URLSessionProtocol {
    
    var dataTask = MockURLSessionDataTask()
    var data: Data?
    var error: Error?
    
    private (set) var requestURL: URL?
    
    func successResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func errorResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        requestURL = request.url
        
        if let data = data {
            completionHandler(data, successResponse(request: request), error)
        }
        
        if let error = error {
            completionHandler(data, errorResponse(request: request), error)
        }
        
        return dataTask
    }
}
