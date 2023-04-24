//
//  RemoteRepository.swift
//  Countries
//
//  Created by Plamen I. Iliev on 21.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import Foundation

protocol RemoteRepositoryProtocol {
    func fetchCountries(parameters: [String: String], completion: @escaping (Result<[Country], NetworkError>) -> ())
    func parseCountriesAPIResponse(data: Data) -> [Country]
}

class RemoteRepository: RemoteRepositoryProtocol {
    private let apiClient: APIClientProtocol
    private let apiResponseParser: APIResponseParserProtocol
        
    // MARK: - Initialization
    init(apiClient: APIClientProtocol = APIClient(),
         apiResponseParser: APIResponseParserProtocol = APIResponseParser()) {
        self.apiClient = apiClient
        self.apiResponseParser = apiResponseParser
    }
    
    // MARK: - API Calls
    func fetchCountries(parameters: [String: String], completion: @escaping (Result<[Country], NetworkError>) -> ()) {
        apiClient.getCountries(with: parameters) { [weak self] result in
            guard let safeSelf = self else { return }
            
            switch result {
            case .success(let data):
                completion(.success(safeSelf.parseCountriesAPIResponse(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - API Response Parse
    func parseCountriesAPIResponse(data: Data) -> [Country] {
        apiResponseParser.decodeJsonArray(from: data, returning: Country.self) ?? []
    }
}
