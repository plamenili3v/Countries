//
//  ModelMockFactory.swift
//  Countries
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

struct ModelMockFactory {
    static let mockCountry1 = Country(capitalName: "Sofia", code: "BGR", flag: "", latLng: [43.0, 25.0], name: "Bulgaria", population: 6927288, region: "Europe", subregion: "Eastern Europe")
    
    static let mockCountry2 = Country(capitalName: "Gibraltar", code: "GIB", flag: "", latLng: [36.13333333, -5.35], name: "Gibraltar", population: 33691, region: "Europe", subregion: "Central Europe")
    
    static let mockCountry3 = Country(capitalName: "Vienna", code: "AUT", flag: "", latLng: [22.34, 22.34], name: "Austria", population: 8917205, region: "Europe", subregion: "Eastern Europe")
    
    static let mockCountries = [mockCountry1, mockCountry2, mockCountry3]
}
