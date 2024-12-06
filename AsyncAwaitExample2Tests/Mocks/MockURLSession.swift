//
//  MockURLSession.swift
//  AsyncAwaitExample2Tests
//
//  Created by Dionicio Cruz Velázquez on 12/4/24.
//

import Foundation
@testable import AsyncAwaitExample2

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockError: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockData else {
            throw NetworkError.invalidURL
        }
        return (data, URLResponse())
    }
}
