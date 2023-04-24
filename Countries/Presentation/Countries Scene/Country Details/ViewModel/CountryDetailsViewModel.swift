//
//  CountryDetailsViewModel.swift
//  Countries
//
//  Created by Plamen I. Iliev on 23.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//
import Foundation
import CoreLocation

protocol CountryDetailsViewModelProtocol {
    // MARK: - INPUT
    var country: Country? {get}
    func viewDidLoad()
    
    // MARK: - OUTPUT
    var updateUI: Observable<Void> { get }
    
    var title: String { get }
    var location: CLLocationCoordinate2D? { get }
    var population: String? { get }
    var capital: String? { get }
    var flagPhotoUrl: URL?  { get }
    
    func updateOutput(with country: Country)
}

final class CountryDetailsViewModel: CountryDetailsViewModelProtocol {
    var country: Country?
    
    // MARK: - OUTPUT
    var updateUI: Observable<Void> = Observable<Void>(())
    var title: String = Title.countryDetails
    var location: CLLocationCoordinate2D?
    var flagPhotoUrl: URL?
    var population: String?
    var capital: String?
    
    // MARK: - Initialization
    init(country: Country?) {
        self.country = country
    }
    
    // MARK: - INPUT
    func viewDidLoad() {
        guard let country = country else {
            return
        }

        updateOutput(with: country)
    }
    
    func updateOutput(with country: Country) {
        let locationMetaData = [country.name, country.region]
        self.title = locationMetaData.compactMap{$0}.joined(separator: ", ")
        
        if let latitude = country.latLng?.first, let longitude = country.latLng?.last {
            self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }

        population = String.formatPoints(from: country.population ?? 0)
        capital = country.capitalName

        if let flagPhoto = country.flag, let photoUrl = URL(string: flagPhoto) {
            flagPhotoUrl = photoUrl
        }

        updateUI.value = ()
    }
}
