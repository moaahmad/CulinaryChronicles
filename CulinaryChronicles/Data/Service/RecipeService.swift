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

    private let dataProvider: DataProviding
    private let urlRequestPool: URLRequestPooling

    // MARK: - Initializer

    init(
        dataProvider: DataProviding = DataProvider(),
        urlRequestPool: URLRequestPooling = URLRequestPool()
    ) {
        self.dataProvider = dataProvider
        self.urlRequestPool = urlRequestPool
    }

    // MARK: - RecipeServicing Functions
    
    func fetchRecipes(page: Int = 1) -> Future<RecipeResponse, Error> {
        let request = urlRequestPool.fetchRecipesRequest(forPage: page)
        return Future<RecipeResponse, Error> { promise in
            dataProvider.fetch(type: RecipeResponse.self, urlRequest: request) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}
