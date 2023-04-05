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
    var isLoading: Bool { get }
    var title: String { get }

    func loadMoreContentIfNeeded(currentItem: Recipe?)
    func refreshFeed()
}

final class RecipeViewModel: RecipeViewModeling & ObservableObject {
    // MARK: - Properties

    private let service: RecipeServicing

    private var cancellables: Set<AnyCancellable> = .init()
    private var currentPage = 1
    private var isFetching = false
    private var isRefreshing = false
    private var isLastPage = false

    lazy var title = "recipes_feed_title".localized()

    // MARK: - Published Properties

    @Published var recipes: [Recipe] = []
    @Published var isLoading = true

    // MARK: - Initializer

    init(service: RecipeServicing = RecipeService()) {
        self.service = service
        fetchRecipes()
    }

    // MARK: - RecipeViewModeling Functions
    
    func loadMoreContentIfNeeded(currentItem: Recipe?) {
        guard let currentItem else { return }
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
        guard !isFetching && !isLastPage else { return }
        isFetching = true
        currentPage = isRefreshing ? 1 : currentPage

        service.fetchRecipes(page: currentPage)
            .receive(on: DispatchQueue.main)
            .map { $0.response.results }
            .sink { [weak self] completion in
                guard let self else { return }
                self.handleCompletion(completion: completion)

            } receiveValue: { [weak self] recipes in
                guard let self else { return }
                self.handleResponse(recipes: recipes)
                completion?()
            }
            .store(in: &cancellables)
    }

    func handleCompletion(completion: Subscribers.Completion<Error>) {
        // Update states
        self.isLoading = false
        self.isFetching = false
        self.isRefreshing = false

        // If there's an error, log it in the console for now
        if case let .failure(error) = completion {
            print("Error fetching recipes: \(error.localizedDescription)")
        }
    }

    func handleResponse(recipes: [Recipe]) {
        // If refreshing, we only want to see the first page results
        if self.isRefreshing { self.recipes = [] }
        self.recipes.append(contentsOf: recipes)

        // If we don't receive any results and there is no error
        // set isLastPage to be true so we don't paginate again,
        // otherwise increment currentPage as normal
        recipes.isEmpty ? (self.isLastPage = true) : (self.currentPage += 1)
    }
}
