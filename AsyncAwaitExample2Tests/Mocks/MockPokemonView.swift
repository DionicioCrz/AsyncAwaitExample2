//
//  MockPokemonView.swift
//  AsyncAwaitExample2Tests
//
//  Created by Dionicio Cruz Velázquez on 12/4/24.
//

import Foundation
@testable import AsyncAwaitExample2

class MockPokemonView: PokemonView {
    var displayedPokemon: [DisplayablePokemon]?
    var didShowErrorMessage = false
    var didShowLoader = false
    var didHideLoader = false

    var onShowResult: (() -> Void)?

    func display(pokemon: [DisplayablePokemon]) {
    displayedPokemon = pokemon
        onShowResult?()
    }

    func showErrorMessage() {
        didShowErrorMessage = true
        onShowResult?()
    }

    func showLoader() {
        didShowLoader = true
    }

    func hideLoader() {
        didHideLoader = true
    }
}
