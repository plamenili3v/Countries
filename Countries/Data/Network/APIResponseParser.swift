//
//  APIResponseParser.swift
//  Countries
//
//  Created by Plamen I. Iliev on 22.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import Foundation

protocol APIResponseParserProtocol {
    func decodeJsonArray<T: Decodable>(from jsonData: Data, returning type: T.Type) -> [T]?
}

class APIResponseParser: APIResponseParserProtocol {
    
    lazy var decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    func decodeJsonArray<T: Decodable>(from jsonData: Data, returning type: T.Type) -> [T]? {
        do {
            return try decoder.decode([T].self, from: jsonData)
        } catch (let error){
            print(error.localizedDescription)
            return nil
        }
    }
}
