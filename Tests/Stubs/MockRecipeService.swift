//
//  MockRecipeService.swift
//  CulinaryChroniclesTests
//
//  Created by Mo Ahmad on 05/04/2023.
//

import Combine
import Foundation
@testable import CulinaryChronicles

final class MockRecipeService: RecipeServicing {
    var recipeResult: Result<RecipeResponse, Error>?
    var fetchRecipesCalledCount = 0

    init(recipeResult: Result<RecipeResponse, Error>? = nil) {
        self.recipeResult = recipeResult
    }

    func fetchRecipes(page: Int) -> Future<RecipeResponse, Error> {
        return Future<RecipeResponse, Error> { [weak self] promise in
            guard let result = self?.recipeResult else { return }
            switch result {
            case .success(let response):
                self?.fetchRecipesCalledCount += 1
                promise(.success(response))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
}
