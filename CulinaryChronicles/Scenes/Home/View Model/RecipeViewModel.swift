//
//  RecipeViewModel.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 01/04/2023.
//

import Combine
import Foundation

protocol RecipeViewModeling {
    var recipes: [Recipe] { get }

    func loadMoreContentIfNeeded(currentItem: Recipe?)
    func refreshFeed()
}

final class RecipeViewModel: RecipeViewModeling & ObservableObject {
    // MARK: - Properties

    private let service: RecipeServicing

    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var isLoading = false
    private var isRefreshing = false
    private var isLastPage = false

    // MARK: - Published Properties

    @Published var recipes: [Recipe] = []

    // MARK: - Initializer

    init(service: RecipeServicing = RecipeService()) {
        self.service = service
        fetchRecipes()
    }

    // MARK: - RecipeViewModeling Functions
    
    func loadMoreContentIfNeeded(currentItem: Recipe?) {
        guard let currentItem = currentItem else { return }
        let thresholdIndex = recipes.index(recipes.endIndex, offsetBy: -4)
        if let lastIndex = recipes.firstIndex(where: { $0.id == currentItem.id }),
            lastIndex >= thresholdIndex {
            fetchRecipes()
        }
    }

    func refreshFeed() {
        isRefreshing = true
        fetchRecipes { [weak self] in
            self?.isRefreshing = false
        }
    }
}

// MARK: - Private Functions

private extension RecipeViewModel {
    func fetchRecipes(completion: (() -> Void)? = nil) {
        guard !isLoading && !isLastPage else { return }
        isLoading = true
        currentPage = isRefreshing ? 1 : currentPage

        service.fetchRecipes(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                self.isRefreshing = false

                if case let .failure(error) = completion {
                    print("Error fetching recipes: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] recipes in
                guard let self else { return }

                if self.isRefreshing { self.recipes = [] }
                self.recipes.append(contentsOf: recipes)
                recipes.isEmpty ? (self.isLastPage = true) : (self.currentPage += 1)
                completion?()
            }
            .store(in: &cancellables)
    }
}
