//
//  RecipeFeedView.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 01/04/2023.
//

import SwiftUI

struct RecipeFeedView<ViewModel: RecipeViewModeling & ObservableObject>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        if viewModel.isLoading {
            ProgressView().progressViewStyle(.circular)
        } else {
            ContentView(viewModel: viewModel)
        }
    }
}

extension RecipeFeedView {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            List(viewModel.recipes, id: \.id) { recipe in
                ZStack {
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        EmptyView()
                    }
                    .opacity(0) // Hide the default appearance, including the chevron

                    RecipeCellView(recipe: recipe)
                }
                .listRowInsets(EdgeInsets())
                .background(Color(.systemBackground))
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(AccessibilityIdentifier.recipeCellID(recipe))
                .onAppear {
                    viewModel.loadMoreContentIfNeeded(currentItem: recipe)
                }
            }
            .listStyle(PlainListStyle())
            .refreshable { viewModel.refreshFeed() }
            .navigationTitle(viewModel.title)
        }
    }
}

// MARK: - Accessibility Identifiers

private extension RecipeFeedView {
    struct AccessibilityIdentifier {
        private init() {}
        static func recipeCellID(_ recipe: Recipe) -> String {
            "\(recipe.fields.headline), \(recipe.tags.first?.webTitle ?? "")"
        }
    }
}

// MARK: - Previews

struct RecipeFeedView_Previews: PreviewProvider {
    final class PreviewViewModel: RecipeViewModeling & ObservableObject {
        var title: String = "Recipes"
        var isLoading: Bool = false
        var recipes: [Recipe] = [
            .init(
                id: "food/2023/mar/18/recipes-for-ramadan-taysir-ghazis-ful-medames-four-ways",
                webTitle: "Recipes for Ramadan: Taysir Ghazi’s ful medames, four ways",
                fields: .init(thumbnail: "https://media.guim.co.uk/c15c453c8e89db724c3c427f8c37621701350894/70_7_2614_1568/500.jpg",
                              headline: "Recipes for Ramadan: Taysir Ghazi’s ful medames, four ways"
                             ),
                tags: [.init(id: "food/series/recipes-for-ramadan", webTitle: "Recipes for Ramadan")]
            )
        ]

        func loadMoreContentIfNeeded(currentItem: Recipe?) {}
        func refreshFeed() {}
    }

    static var previews: some View {
        NavigationStack {
            RecipeFeedView(viewModel: PreviewViewModel())
        }
        .navigationTitle("Recipes")
    }
}
