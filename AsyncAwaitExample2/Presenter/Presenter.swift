//
//  Presenter.swift
//  AsyncAwaitExample2
//
//  Created by Dionicio Cruz Velázquez on 12/2/24.
//

import Foundation

protocol PokemonView: AnyObject {
    func display(pokemon: [DisplayablePokemon])
    func showErrorMessage()
    func showLoader()
    func hideLoader()
}

class Presenter {
    weak var view: PokemonView?

    func setView(view: PokemonView) {
        self.view = view
    }

    let service: PokemonService
    
    init(service: PokemonService) {
        self.service = service
    }

    func fetchPokemon() {
        view?.showLoader()
        Task(priority: .userInitiated) {
            do {
                let pokemon = try await service.fetchPokemon()
                let displayablePokemon = try await fetchDetailsForPokemon(pokemon: pokemon)
                if displayablePokemon.isEmpty {
                   await onError()
                } else {
                    await onSuccess(pokemon: displayablePokemon)
                }
            } catch {
                await onError()
            }
        }
    }

    private func fetchDetailsForPokemon(pokemon: [Pokemon]) async throws -> [DisplayablePokemon] {
        var displayablePokemonList: [DisplayablePokemon] = []
        
        for pokemon in pokemon {
            do {
                let details = try await service.fetchPokemonDetails(url: pokemon.url)
                let types = details.types.map { $0.type.name.capitalized }.joined(separator: ",")
                let abilities = details.abilities.map{ $0.ability.name.capitalized }.joined(separator: ",")
                
                let displayablePokemon = DisplayablePokemon(
                    name: pokemon.name.capitalized,
                    ability: types,
                    type: abilities
                )
                displayablePokemonList.append(displayablePokemon)
            } catch {
                print("Error fetching details for \(pokemon.name): \(error)")
                continue
            }
        }
        return displayablePokemonList
    }

    @MainActor
    func onError() {
        view?.hideLoader()
        view?.showErrorMessage()
    }

    @MainActor
    func onSuccess(pokemon: [DisplayablePokemon]) {
        view?.hideLoader()
        view?.display(pokemon: pokemon)
    }
}
