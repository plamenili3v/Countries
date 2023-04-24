//
//  CountryListItemViewModel.swift
//  Countries
//
//  Created by Plamen I. Iliev on 21.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

struct CountryListItemViewModel: Equatable {
    let titleText: String?
}

extension CountryListItemViewModel {

    init(country: Country) {
        let locationMetaData = [country.name ?? "Unknown", country.region]
        titleText = locationMetaData.compactMap{$0}.joined(separator: ", ")
    }
}
