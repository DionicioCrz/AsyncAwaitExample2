//
//  PokemonResponse.swift
//  AsyncAwaitExample2
//
//  Created by Dionicio Cruz Velázquez on 12/2/24.
//

import Foundation

struct PokemonResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
    var details: PokemonDetails?
}

struct PokemonDetails: Codable {
    let abilities: [Ability]
    let types: [TypeElement]
}

struct Ability: Codable {
    let ability: AbilityDetail
}

struct AbilityDetail: Codable {
    let name: String
}

struct TypeElement: Codable {
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
}
