//
//  NetworkService.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    
    private let baseURL = "https://api.thecatapi.com/v1"
    private let apiKey = "" //TODO: get it from config file
    
    init() {
        let memoryCapacity = 10 * 1024 * 1024 // 10 MB
        let diskCapacity = 50 * 1024 * 1024 // 50 MB
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myCache")
        
        URLCache.shared = urlCache
    }
    
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.path += endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.cachePolicy = .returnCacheDataElseLoad
        
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let (data, response) = try await URLSession.shared.data(for : request) //TODO: it should be a protocol
        
        try validateResponse(response)
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            print(error)
            throw NetworkError.decodingFailed(error)
        }
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        print(response)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
    }
}
