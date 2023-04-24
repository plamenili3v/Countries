//
//  CountriesListViewModel.swift
//  Countries
//
//  Created by Plamen I. Iliev on 21.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//
import CoreLocation

protocol CountriesListViewModelProtocol {
    // MARK: - INPUT
    func viewDidLoad()
    func didRequestRefreshItems()
    func searchCountry(searchTerm: String)
    func countryAtIndex(_ index: Int) -> Country
    
    // MARK: - OUTPUT
    var items: Observable<[CountryListItemViewModel]> { get }
    var error: Observable<String> { get }
}

final class CountriesListViewModel: CountriesListViewModelProtocol {
    private let repository: RepositoryProtocol
    private(set) var countries = [Country]()
    private(set) var searchResultCountries = [Country]()
    
    // MARK: - OUTPUT
    let items: Observable<[CountryListItemViewModel]> = Observable([])
    var error = Observable<String>("")
    
    // MARK: - Initialization
    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    // MARK: - INPUT
    func viewDidLoad() {
        fetchCountries()
    }
    
    func didRequestRefreshItems() {
        fetchCountries()
    }
    
    func fetchCountries() {
        repository.fetchCountries() { [weak self] result in
            guard let safeSelf = self else { return }
            switch result {
            case .success(let countries):
                safeSelf.countries = countries
                safeSelf.sortCountries()
                safeSelf.items.value = safeSelf.countries.map(CountryListItemViewModel.init)
            case .failure(let error):
                safeSelf.error.value = error.localizedDescription
            }
        }
    }
    
    func sortCountries() {
        countries.sort(by: { country1, country2 in
            country1.population ?? 0 > country2.population ?? 0
        })
    }
    
    func searchCountry(searchTerm: String) {
        if searchTerm.isEmpty {
            searchResultCountries = []
            items.value = countries.map(CountryListItemViewModel.init)
        } else if searchTerm.count >= 3 {
            searchResultCountries = countries.filter { $0.name?.lowercased().contains(searchTerm.lowercased()) ?? false }
            items.value = searchResultCountries.map(CountryListItemViewModel.init)
        }
    }
    
    func countryAtIndex(_ index: Int) -> Country {
        if !searchResultCountries.isEmpty {
            return searchResultCountries[index]
        }
        
        return countries[index]
    }
}
