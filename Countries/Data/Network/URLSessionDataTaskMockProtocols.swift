//
//  URLSessionDataTaskMockProtocols.swift
//  Countries
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol APIClientProtocol {
    typealias APIResponseCompletion = (_ result: Result<Data, NetworkError>) -> Void
    
    func getCountries(with parameters: [String: String], completion: @escaping APIResponseCompletion)
    func sendGetRequest(with url: URL, completion: @escaping APIResponseCompletion)
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
