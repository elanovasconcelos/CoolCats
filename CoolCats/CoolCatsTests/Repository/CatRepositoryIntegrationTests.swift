//
//  CatRepositoryIntegrationTests.swift
//  CoolCatsTests
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import XCTest
@testable import CoolCats

final class CatRepositoryIntegrationTests: XCTestCase {

    var repository: CatRepositoryImpl!
    var networkService: NetworkService!
    
    override func setUpWithError() throws {
        networkService = NetworkService()
        repository = CatRepositoryImpl(networkService: networkService)
    }

    override func tearDownWithError() throws {
        repository = nil
        networkService = nil
    }

    func testFetchPropertiesFromAPI() async throws {
        // Act & Arrange
        let cats = try await repository.fetchCats()
        
        // Assert
        XCTAssertEqual(cats.count, 10)
        
        if !cats.isEmpty {
            XCTAssertEqual(cats[0].id, "abys")
            XCTAssertEqual(cats[0].name, "Abyssinian")
            XCTAssertEqual(cats[0].image?.url, "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")
            XCTAssertEqual(cats[0].weight.metric, "3 - 5")
        }
    }

}
