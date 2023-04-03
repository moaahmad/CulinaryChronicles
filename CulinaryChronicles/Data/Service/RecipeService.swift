//
//  RecipeService.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 01/04/2023.
//

import Combine
import Foundation

protocol RecipeServicing {
    func fetchRecipes(page: Int) -> AnyPublisher<[Recipe], Error>
}

struct RecipeService: RecipeServicing {
    private let baseUrl = "https://content.guardianapis.com/search"
    private let apiKey = "fe8e58cf-cf66-4014-9b2d-b56cb3a7ea8d"

    func fetchRecipes(page: Int = 1) -> AnyPublisher<[Recipe], Error> {
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "tag", value: "tone/recipes"),
            URLQueryItem(name: "show-tags", value: "series"),
            URLQueryItem(name: "show-fields", value: "thumbnail,headline"),
            URLQueryItem(name: "api-key", value: apiKey),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        return URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .map { $0.data }
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .map { $0.response.results }
            .print()
            .eraseToAnyPublisher()
    }
}
