//
//  APIConstants.swift
//  Countries
//
//  Created by Plamen I. Iliev on 22.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

struct APIConstants {
    static let scheme = "https"
    static let host = "excitel-countries.azurewebsites.net"
    
    enum Endpoint: String {
        case countries = "/countries"
    }
}
