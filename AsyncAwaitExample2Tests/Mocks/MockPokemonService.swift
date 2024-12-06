//
//  ServiceMock.swift
//  AsyncAwaitExample2Tests
//
//  Created by Dionicio Cruz Velázquez on 12/4/24.
//

import Foundation
@testable import AsyncAwaitExample2

class MockPokemonService: PokemonService {
    var mockPokemon: [Pokemon] = []
    var mockPokemonDetails: PokemonDetails?
    var shouldFail = false

    func fetchPokemon() async throws -> [Pokemon] {
        if shouldFail {
            throw NetworkError.invalidURL
        }
        return mockPokemon
    }
    
    func fetchPokemonDetails(url: String) async throws -> PokemonDetails {
        if shouldFail || url == "invalidUrl" {
            throw NetworkError.invalidURL
        }

        return mockPokemonDetails ?? PokemonDetails(abilities: [], types: [])
    }
}
