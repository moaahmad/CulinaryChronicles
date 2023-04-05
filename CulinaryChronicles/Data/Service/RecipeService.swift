//
//  RecipeService.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 01/04/2023.
//

import Combine
import Foundation

protocol RecipeServicing {
    func fetchRecipes(page: Int) -> Future<RecipeResponse, Error>
}

struct RecipeService: RecipeServicing {
    // MARK: - Properties

    private let client: HTTPClient
    private let urlRequestPool: URLRequestPooling
    private let decoder: JSONDecoder

    // MARK: - Initializer

    init(
        client: HTTPClient = URLSessionHTTPClient(),
        urlRequestPool: URLRequestPooling = URLRequestPool(),
        decoder: JSONDecoder = .init()
    ) {
        self.client = client
        self.urlRequestPool = urlRequestPool
        self.decoder = decoder
    }

    // MARK: - RecipeServicing Functions
    
    func fetchRecipes(page: Int = 1) -> Future<RecipeResponse, Error> {
        let request = urlRequestPool.fetchRecipesRequest(forPage: page)
        return Future<RecipeResponse, Error> { promise in
            client.performRequest(request) { result in
                switch result {
                case let .success((data, response)):
                    handleFetchRecipesSuccessResponse(data: data, response: response, promise: promise)
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}

private extension RecipeService {
    func handleFetchRecipesSuccessResponse(
        data: Data,
        response: HTTPURLResponse,
        promise: (Result<RecipeResponse, Error>) -> Void
    ) {
        do {
            if response.statusCode != 200 {
                promise(.failure(ResponseError.invalidResponse))
            } else {
                let response = try decoder.decode(RecipeResponse.self, from: data)
                promise(.success(response))
            }
        } catch {
            promise(.failure(ResponseError.invalidData))
        }
    }
}
