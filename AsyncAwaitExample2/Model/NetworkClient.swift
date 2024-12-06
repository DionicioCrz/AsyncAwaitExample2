//
//  NetworkClient.swift
//  AsyncAwaitExample2
//
//  Created by Dionicio Cruz Velázquez on 12/2/24.
//
import Foundation

protocol NetworkClient {
    // Here our function is generic, which means it can receive any type comforming to the Decodable protocol
    func fetchData<T: Decodable>(from urlString: String, type: T.Type) async throws -> T
}

class NetworkClientImpl: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchData<T: Decodable>(from urlString: String, type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: - Helpers for the error handling and constants enum
enum NetworkError: Error {
    case invalidURL
    case noData
}

enum Constants {
    static let pokemonURL = "https://pokeapi.co/api/v2/pokemon?limit=100"
}
