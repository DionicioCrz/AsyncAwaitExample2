//
//  AsyncAwaitExample2Tests.swift
//  AsyncAwaitExample2Tests
//
//  Created by Dionicio Cruz Velázquez on 12/4/24.
//

import XCTest
@testable import AsyncAwaitExample2

final class PokemonPresenterTests: XCTestCase {
    var presenter: Presenter!
    var mockService: MockPokemonService!
    var mockView: MockPokemonView!

    override func setUp() async throws {
        try await super.setUp()
        mockService = MockPokemonService()
        mockView = MockPokemonView()
        presenter = Presenter(service: mockService)
        presenter.setView(view: mockView)
    }
    
    override func tearDown() async throws {
        mockView = nil
        mockService = nil
        presenter = nil
        try await super.tearDown()
    }

    func testFetchPokemonSucces() async throws {
        // Given
        mockService.mockPokemon = [Pokemon(name: "Pikachu", url: "someUrl")]
        mockService.mockPokemonDetails = PokemonDetails(abilities: [], types: [])
        
        let expectation = XCTestExpectation(description: "Presenter fetches and displays Pokémon")
        
        // Fulfill expectation when display(pokemon:) is called
//        mockView.onShowResult = { expectation.fulfill() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { expectation.fulfill() }
        
        // When
        presenter.fetchPokemon()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(mockView.didShowErrorMessage, "Error message should not be shown")
        XCTAssertTrue(mockView.didShowLoader, "Loader should be shown")
        XCTAssertTrue(mockView.didHideLoader, "Loader should be hidden")
        XCTAssertEqual(mockView.displayedPokemon?.first?.name, "Pikachu", "Displayed Pokémon name should be Pikachu")
    }
    
    func testFetchPokemonEmpty() async {
        // Given
        mockService.mockPokemon = []
        
        let expectation = XCTestExpectation(description: "Presenter handles empty response")
        
//        mockView.onShowResult = { expectation.fulfill() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { expectation.fulfill() }
        
        // When
        presenter.fetchPokemon()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(mockView.didShowErrorMessage, "Error message should be shown")
        XCTAssertTrue(mockView.didShowLoader, "Loader should be shown")
        XCTAssertTrue(mockView.didHideLoader, "Loader should be hidden")
        XCTAssertNil(mockView.displayedPokemon)
    }

    func testFetchPokemonSingleResult() async throws {
        // Given
        mockService.mockPokemon = [Pokemon(name: "Charmander", url: "someUrl")]
        mockService.mockPokemonDetails = PokemonDetails(abilities: [], types: [])
        let expectation = XCTestExpectation(description: "Presenter displays single Pokémon")

//        mockView.onShowResult = { expectation.fulfill() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { expectation.fulfill() }

        // When
        presenter.fetchPokemon()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(mockView.displayedPokemon?.count, 1, "Only one Pokémon should be displayed")
        XCTAssertEqual(mockView.displayedPokemon?.first?.name, "Charmander", "Displayed Pokémon name should be Charmander")
    }

    
    func testFetchPokemonFailure() async {
        // Given
        mockService.shouldFail = true
        let expectation = XCTestExpectation(description: "Presenter handles failure")
        
//        mockView.onShowResult = { expectation.fulfill() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { expectation.fulfill() }
        
        // When
        presenter.fetchPokemon()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(mockView.didShowErrorMessage, "Error message should be shown")
        XCTAssertTrue(mockView.didShowLoader, "Loader should be shown")
        XCTAssertTrue(mockView.didHideLoader, "Loader should be hidden")
        XCTAssertNil(mockView.displayedPokemon, "No Pokémon should be displayed in case of failure")
    }

    func testFetchPokemonDetailsPartialError() async throws {
        // Given
        mockService.mockPokemon = [
            Pokemon(name: "Bulbasaur", url: "validUrl"),
            Pokemon(name: "Squirtle", url: "invalidUrl")
        ]
        mockService.mockPokemonDetails = PokemonDetails(
            abilities: [Ability(ability: AbilityDetail(name: "Overgrow"))],
            types: [TypeElement(type: TypeDetail(name: "Grass"))]
        )
        mockService.shouldFail = false // Ensure only Squirtle fails based on URL logic

        let expectation = XCTestExpectation(description: "Presenter should display valid Pokémon despite partial errors")
        
//        mockView.onShowResult = { expectation.fulfill() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { expectation.fulfill() }

        // When
        presenter.fetchPokemon()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(mockView.didShowLoader, "Loader should be shown")
        XCTAssertTrue(mockView.didHideLoader, "Loader should be hidden")
        XCTAssertFalse(mockView.didShowErrorMessage, "Error message should not be shown")
        XCTAssertEqual(mockView.displayedPokemon?.count, 1, "Only one Pokémon should be displayed due to partial error")
        XCTAssertEqual(mockView.displayedPokemon?.first?.name, "Bulbasaur", "The Pokémon name should be Bulbasaur")
    }




}
