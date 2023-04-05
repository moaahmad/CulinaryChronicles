//
//  RecipeServiceTests.swift
//  CulinaryChroniclesTests
//
//  Created by Mo Ahmad on 04/04/2023.
//

import Combine
import XCTest
@testable import CulinaryChronicles

final class RecipeServiceTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = .init()
    }

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
}

// MARK: - Load Feed Failure Tests

extension RecipeServiceTests {
    func test_fetchRecipes_onSuccessWithNon200Code_returnsError() {
        // Given
        let (sut, client) = makeSUT()

        var returnedError: ResponseError?
        let exp = expectation(description: "Wait for fetch completion")

        // When
        sut.fetchRecipes()
            .sink { completion in
                switch completion {
                case .failure(let error as ResponseError):
                    returnedError = error
                    exp.fulfill()
                default:
                    XCTFail("Expected fetch to fail with invalidResponse error")
                }
            } receiveValue: { result in
                XCTFail("Expected fetch to fail with invalidResponse error")
            }
            .store(in: &cancellables)

        client.complete(withStatusCode: 100, data: .init())
        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertEqual(returnedError, .invalidResponse)
    }

    func test_fetchRecipes_onSuccessWithNonInvalidData_returnsError() {
        // Given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for fetch completion")
        var returnedError: ResponseError?

        // When
        sut.fetchRecipes()
            .sink { completion in
                switch completion {
                case .failure(let error as ResponseError):
                    returnedError = error
                    exp.fulfill()
                default:
                    XCTFail("Expected fetch to fail with invalidData error")
                }
            } receiveValue: { result in
                XCTFail("Expected fetch to fail with invalidData error")
            }
            .store(in: &cancellables)

        client.complete(withStatusCode: 200, data: MockServer.loadLocalJSON("BadJSON"))
        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertEqual(returnedError, .invalidData)
    }

    func test_fetchRecipes_onFailure_returnsError() {
        // Given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for fetch completion")
        var returnedError: Error?

        // When
        sut.fetchRecipes()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    returnedError = error
                    exp.fulfill()
                default:
                    XCTFail("Expected fetch to fail with invalidData error")
                }
            } receiveValue: { result in
                XCTFail("Expected fetch to fail with error")
            }
            .store(in: &cancellables)

        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)

        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertNotNil(returnedError)
    }
}

// MARK: - Load Feed Success Tests

extension RecipeServiceTests {
    func test_fetchRecipes_onSuccess_returnsStocks() {
        // Given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for fetch completion")
        var returnedRecipes: [Recipe] = []

        // When
        sut.fetchRecipes()
            .sink { _ in } receiveValue: { recipes in
                returnedRecipes = recipes.response.results
                exp.fulfill()
            }
            .store(in: &cancellables)

        let data = MockServer.loadLocalJSON("Recipes")
        let expectedResponse = try! JSONDecoder().decode(RecipeResponse.self, from: data)
        client.complete(withStatusCode: 200, data: data)
        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertEqual(returnedRecipes, expectedResponse.response.results)
    }
}

// MARK: - Make SUT

private extension RecipeServiceTests {
    func makeSUT() -> (sut: RecipeService, client: HTTPClientSpy)  {
        let client = HTTPClientSpy()
        let sut = RecipeService(client: client)
        return (sut, client)
    }
}
