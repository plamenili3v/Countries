//
//  Constants.swift
//  Countries
//
//  Created by Plamen I. Iliev on 21.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

struct SegueIds {
    static let showCountryDetails = "showCountryDetails"
}

struct Title {
    static let OK = "OK"
    static let noResults = "NO RESULTS"
    static let population = "Population"
    static let capital = "Capital"
    static let countryDetails = "Country Details"
    static let searchCountryPlaceholder = "Search For Country"
}

struct Message {
    static let errorOccured = "An Error Occured"
    
    struct Error {
        static let notConnectedToInternet = "Please check your internet connection."
        static let couldntReachServerError = "Couldn't reach server."
        static let parseServerResponseError = "Couldn't parse server response."
        static let somethingWentWrong = "Something went wrong."
    }
}

