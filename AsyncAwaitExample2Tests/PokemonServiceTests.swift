//
//  PokemonServiceTests.swift
//  AsyncAwaitExample2Tests
//
//  Created by Dionicio Cruz Velázquez on 12/4/24.
//

import XCTest
@testable import AsyncAwaitExample2

final class PokemonServiceTests: XCTestCase {
    var mockSession: MockURLSession!
    var pokemonService: PokemonServiceImpl2!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        pokemonService = PokemonServiceImpl2(session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        pokemonService = nil
        super.tearDown()
    }

    func testServiceFetchPokemonSuccess() async throws {
        let mockResponse = PokemonResponse(results: [
            Pokemon(name: "Pikachu", url: "SomeURL"),
            Pokemon(name: "Raychu", url: "SomeURL")
        ])
        mockSession.mockData = try JSONEncoder().encode(mockResponse)

        let pokemon = try await pokemonService.fetchPokemon()
        XCTAssertEqual(pokemon.count, 2)
        XCTAssertEqual("Pikachu", pokemon[0].name)
    }

    func testServiceFetchPokemonFailure() async throws {
        mockSession.mockError = NetworkError.invalidURL

        do {
            _ = try await pokemonService.fetchPokemon()
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
