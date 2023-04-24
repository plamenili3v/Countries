//
//  RepositoryTests.swift
//  CountriesTests
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import XCTest
import Foundation
@testable import Countries

final class RepositoryTests: XCTestCase {
    
    var sut: Repository!
    var mockRemoteRepository: MockRemoteRepository!
    
    override func setUpWithError() throws {
        mockRemoteRepository = MockRemoteRepository()
        sut = Repository(remoteRepository: mockRemoteRepository)
    }

    override func tearDownWithError() throws {
        mockRemoteRepository = nil
        sut = nil
    }
    
    func testFetchCountries_IsExecutedOnBackgroundThread() throws {
        let expectation = expectation(description: "Countries Are Being Fetched On Background Thread")
        mockRemoteRepository.mockResult = .success(ModelMockFactory.mockCountries)
        
        sut.fetchCountries() { result in
            switch result {
            case .success(_):
                if self.mockRemoteRepository.invokationThread != Thread.main {
                    expectation.fulfill()
                }
            default:
                break
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

final class MockRemoteRepository: RemoteRepositoryProtocol {
    func parseCountriesAPIResponse(data: Data) -> [Country] {
        return []
    }
    
    var invokationThread: Thread?
    var mockResult: Result<[Country], NetworkError> = .success([])
    
    func fetchCountries(parameters: [String : String], completion: @escaping (Result<[Country], NetworkError>) -> ()) {
        invokationThread = Thread.current
        completion(mockResult)
    }
}

