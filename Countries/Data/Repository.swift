//
//  Repository.swift
//  Countries
//
//  Created by Plamen I. Iliev on 22.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//
import Foundation

protocol RepositoryProtocol {
    func fetchCountries(completion: @escaping (Result<[Country], NetworkError>) -> ())
}

class Repository: RepositoryProtocol {
    private let remoteRepository: RemoteRepositoryProtocol
    
    // MARK: - Initialization
    init(remoteRepository: RemoteRepositoryProtocol = RemoteRepository()) {
        self.remoteRepository = remoteRepository
    }
    
    func fetchCountries(completion: @escaping (Result<[Country], NetworkError>) -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.remoteRepository.fetchCountries(parameters: [:], completion: completion)
        }
    }
}
