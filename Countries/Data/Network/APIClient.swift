//
//  APIClient.swift
//  Countries
//
//  Created by Plamen I. Iliev on 22.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import Foundation

class APIClient: APIClientProtocol {
    
    private let requestBuilder: APIRequestBuilder
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared,
         requestBuilder: APIRequestBuilder = APIRequestBuilder()) {
        self.urlSession = urlSession
        self.requestBuilder = requestBuilder
    }
    
    func getCountries(with parameters: [String: String], completion: @escaping APIResponseCompletion) {

        guard let url = requestBuilder.buildUrlForExcitelEndpoint(.countries, with: parameters) else {
            completion(.failure(.invalidUrl))
            return
        }
                
        sendGetRequest(with: url, completion: { result in
            completion(result)
        })
    }
    
    func resolve(errorCode: Int) -> NetworkError {
        let code = URLError.Code(rawValue: errorCode)
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        
        default: return .generic(URLError(code))
        }
    }
    
    // MARK: - API Requests
    func sendGetRequest(with url: URL, completion: @escaping APIResponseCompletion) {
        let request = URLRequest(url: url)
                
        urlSession.dataTask(with: request) { (data, response, error) in
            if let requestError = error {
                var networkError: NetworkError
                if let response = response as? HTTPURLResponse {
                    networkError = .error(error: error, statusCode: response.statusCode)
                } else {
                    networkError = self.resolve(errorCode: (requestError as NSError).code)
                }
                
                completion(.failure(networkError))
            } else if let safeData = data {
                completion(.success(safeData))
            } else {
                completion(.failure(.noResponseData))
            }
        }.resume()
    }
}
