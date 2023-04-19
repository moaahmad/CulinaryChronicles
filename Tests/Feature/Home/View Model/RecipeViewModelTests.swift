//
//  RecipeViewModelTests.swift
//  CulinaryChroniclesTests
//
//  Created by Mo Ahmad on 04/04/2023.
//

import Combine
import XCTest
@testable import CulinaryChronicles

final class RecipeViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = .init()
    }

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    func test_title_isCorrect() {
        let sut = makeSUT().0

        XCTAssertEqual(sut.title, "Recipes")
    }

    func test_recipes_init_empty() {
        // Given
        let sut = makeSUT().0

        // Then
        XCTAssertEqual(sut.recipes.count, 0)
    }

    func test_recipes_init_tenValues() throws {
        // Given
        let sut = makeSUT(
            service: MockRecipeService(
                recipeResult: .success(RecipeResponse.anyRecipeResponse())
            )
        ).0
        let exp = expectation(description: #function)

        // When
        sut.$recipes
            .receive(on: DispatchQueue.main)
            .sink { _ in
                guard !sut.recipes.isEmpty else { return }
                exp.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(sut.recipes.count, 10)
    }

    func test_loadMoreContentIfNeeded() {
        let sut = makeSUT().0

        sut.loadMoreContentIfNeeded(currentItem: Recipe.anyRecipe())
    }

    func test_refreshFeed_ShouldCallFetchRecipes() {
        // Given
        let (sut, service) = makeSUT(
            service: MockRecipeService(
                recipeResult: .success(RecipeResponse.anyRecipeResponse())
            )
        )
        let exp = expectation(description: #function)

        // When
        sut.refreshFeed()

        sut.$recipes
            .receive(on: DispatchQueue.main)
            .sink { _ in
                guard !sut.recipes.isEmpty else { return }
                exp.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        // Then
        let mockService = try? XCTUnwrap(service as? MockRecipeService)
        XCTAssertEqual(sut.recipes.count, 10)
        XCTAssertEqual(mockService?.fetchRecipesCalledCount, 1)
    }

    func test_refreshFeed_WhenFetchFails_ShouldNotFetchRecipes() {
        // Given
        let mockService = MockRecipeService(recipeResult: .failure(NSError(domain: "TestError", code: -1, userInfo: nil)))
        let sut = makeSUT(service: mockService).0

        // When
        sut.refreshFeed()

        // Then
        XCTAssertEqual(sut.recipes.count, 0)
        XCTAssertEqual(mockService.fetchRecipesCalledCount, 0)
    }
}

// MARK: - Make SUT

extension RecipeViewModelTests {
    func makeSUT(service: RecipeServicing = MockRecipeService()) -> (RecipeViewModel, RecipeServicing) {
        let sut = RecipeViewModel(service: service)
        return (sut, service)
    }
}

// MARK: - Mock Data

extension Recipe {
    static func anyRecipe() -> Recipe {
        .init(
            id: "food/2023/mar/18/recipes-for-ramadan-taysir-ghazis-ful-medames-four-ways",
            webTitle: "Recipes for Ramadan: Taysir Ghazi’s ful medames, four ways",
            fields: .init(thumbnail: "https://media.guim.co.uk/c15c453c8e89db724c3c427f8c37621701350894/70_7_2614_1568/500.jpg",
                          headline: "Recipes for Ramadan: Taysir Ghazi’s ful medames, four ways"
                         ),
            tags: [.init(id: "food/series/recipes-for-ramadan", webTitle: "Recipes for Ramadan")]
        )
    }
}

extension RecipeResponse {
    static func anyRecipeResponse() -> RecipeResponse {
        let data = MockServer.loadLocalJSON("Recipes")
        return try! JSONDecoder().decode(RecipeResponse.self, from: data)
    }
}
