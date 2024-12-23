//
//  CatRepositoryImpl.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import Foundation

protocol CatRepository {
    func fetchCats(limit: Int, page: Int) async throws -> [Cat]
}

final class CatRepositoryImpl: CatRepository {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCats(limit: Int = 10, page: Int = 0) async throws -> [Cat] {
        let endpoint = APIEndpoint.breeds(limit: limit, page: page)
        let response: [Cat] = try await networkService.fetch(endpoint: endpoint)
        
        return response
    }
}
