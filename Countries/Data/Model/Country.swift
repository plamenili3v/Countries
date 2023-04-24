//
//  Country.swift
//  Countries
//
//  Created by Plamen I. Iliev on 20.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import Foundation

struct Country: Codable, Equatable {
    let capitalName: String?
    let code: String?
    let flag: String?
    let latLng: [Double]?
    let name: String?
    let population: Int?
    let region: String?
    let subregion: String?
}
