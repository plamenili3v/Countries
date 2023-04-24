//
//  NetworkError.swift
//  Countries
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import Foundation

public enum NetworkError: Error, Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        guard type(of: lhs) == type(of: rhs) else { return false }
        let error1 = lhs as NSError
        let error2 = rhs as NSError
        return error1.domain == error2.domain && error1.code == error2.code && "\(lhs)" == "\(rhs)"
    }
    
    case notConnected
    case cancelled
    case invalidUrl
    case noResponseData
    case generic(Error)
    case error(error: Error?, statusCode: Int)
}

extension NetworkError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .notConnected:
            return Message.Error.notConnectedToInternet
        case .cancelled, .invalidUrl, .noResponseData:
            return Message.Error.couldntReachServerError
        case .generic(let error):
            return error.localizedDescription
        
        default: return Message.Error.couldntReachServerError
        }
    }
}
