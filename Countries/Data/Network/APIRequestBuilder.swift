//
//  APIRequestBuilder.swift
//  Countries
//
//  Created by Plamen I. Iliev on 22.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import Foundation

class APIRequestBuilder {

    private var components = URLComponents(string: "")

    @discardableResult
    func appendScheme(scheme: String) -> APIRequestBuilder {
        components?.scheme = scheme
        return self
    }
    
    @discardableResult
    func appendHost(host: String) -> APIRequestBuilder {
        components?.host = host
        return self
    }
    
    @discardableResult
    func appendPath(path: String) -> APIRequestBuilder {
        components?.path = path
        return self
    }
    
    @discardableResult
    func appendQueryParameters(parameters: [String : Any]) -> APIRequestBuilder {
        components?.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        return self
    }
    
    func buildURL() -> URL? {
        guard let urlComponets = components, let url = urlComponets.url else { return nil }
        components = URLComponents(string: "")
        return url
    }
    
    func appendExcitelCountriesBaseURL() -> APIRequestBuilder {
        appendScheme(scheme: APIConstants.scheme).appendHost(host: APIConstants.host)
    }
    
    func buildUrlForExcitelEndpoint(_ endpoint: APIConstants.Endpoint, with parameters: [String: Any] = [:]) -> URL? {
        return appendExcitelCountriesBaseURL()
            .appendPath(path: "\(endpoint.rawValue)")
            .appendQueryParameters(parameters: parameters)
            .buildURL()
    }
}
