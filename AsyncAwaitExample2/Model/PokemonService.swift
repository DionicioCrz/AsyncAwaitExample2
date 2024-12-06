//
//  PokemonService.swift
//  AsyncAwaitExample2
//
//  Created by Dionicio Cruz Velázquez on 12/2/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol PokemonService {
    func fetchPokemon() async throws -> [Pokemon]
    func fetchPokemonDetails(url: String) async throws -> PokemonDetails
}

// MARK: Code without refactor
class PokemonServiceImpl: PokemonService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init (session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    // On both of these functions we can identify boilerplate code, which can help us to think on refactor them using generics
    func fetchPokemon() async throws -> [Pokemon] {
        guard let url = URL(string: Constants.pokemonURL) else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, _) = try await session.data(from: url)
            let pokemonResponse = try decoder.decode(PokemonResponse.self, from: data)
            return pokemonResponse.results
        } catch {
            throw error
        }
    }
    
    func fetchPokemonDetails(url: String) async throws -> PokemonDetails {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, _) = try await session.data(from: url)
            let pokemonDetails = try decoder.decode(PokemonDetails.self, from: data)
            return pokemonDetails
        } catch {
            throw error
        }
    }
}

//MARK: - Code refactored to use generics
class PokemonServiceImpl2: PokemonService {
    
    private let session: URLSessionProtocol// = .shared
    private let decoder: JSONDecoder //= JSONDecoder()

    init(session: URLSessionProtocol = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    // Refactoring to have a generic function and avoid boilerplate code
    private func fetchData<T: Decodable>(from urlString: String, type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        do {
            return try decoder.decode(T.self, from: try await session.data(from: url).0)
        }
    }
    
    func fetchPokemon() async throws -> [Pokemon] {
        return try await fetchData(from: Constants.pokemonURL, type: PokemonResponse.self).results
    }
    
    func fetchPokemonDetails(url: String) async throws -> PokemonDetails {
        return try await fetchData(from: url, type: PokemonDetails.self)
    }
}


// MARK: Moving the Network implementation to a separate class
// This class does the same as the previous one, we only move the networking implementation to a separated class
class PokemonServiceImpl3: PokemonService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClientImpl()) { // Dependency injection
        self.networkClient = networkClient
    }
    
    func fetchPokemon() async throws -> [Pokemon] {
        return try await networkClient.fetchData(from: Constants.pokemonURL, type: PokemonResponse.self).results
    }
    
    func fetchPokemonDetails(url: String) async throws -> PokemonDetails {
        return try await networkClient.fetchData(from: url, type: PokemonDetails.self)
        
    }
}
