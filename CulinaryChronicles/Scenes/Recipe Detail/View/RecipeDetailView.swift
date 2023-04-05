//
//  RecipeDetailView.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 31/03/2023.
//

import SwiftUI

struct RecipeDetailView: View {
    // TODO: Use a ViewModel instead - this will do for now though.
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .Spacer.xs) {
                // Image View
                if let imageURL = recipe.fields.thumbnailURL {
                    RemoteImageView(imageURL: imageURL)
                        .aspectRatio(Constant.imageAspectRatio, contentMode: .fill)
                        .cornerRadius(Constant.cornerRadius)
                        .accessibilityLabel(AccessibilityIdentifier.imageID)
                }

                // Tag View
                if let tag = recipe.tags.first?.webTitle {
                    Text(tag.uppercased())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .accessibilityLabel(AccessibilityIdentifier.tagLabel)
                        .accessibilityIdentifier(AccessibilityIdentifier.tagID)
                }

                // Headline View
                Text(recipe.webTitle)
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(AccessibilityIdentifier.headlineLabel)
                    .accessibilityIdentifier(AccessibilityIdentifier.headlineID)
            }
            .padding(.all, .Spacer.sm)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Constants

private extension RecipeDetailView {
    struct Constant {
        private init() {}
        static var imageAspectRatio: CGFloat { 1.6 }
        static var cornerRadius: CGFloat { 12 }
    }
}

// MARK: - Accessibility Identifiers

private extension RecipeDetailView {
    // TODO: - Make the custom labels more descriptive for VoiceOver
    struct AccessibilityIdentifier {
        private init() {}
        static var imageID: String { "Recipe image" }
        static var tagLabel: String { "Recipe tag" }
        static var tagID: String { "recipeTag" }
        static var headlineLabel: String { "Recipe headline" }
        static var headlineID: String { "recipeHeadline" }
    }
}

// MARK: - Previews

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(
            recipe: .init(
                id: "food/2023/mar/18/recipes-for-ramadan-taysir-ghazis-ful-medames-four-ways",
                webTitle: "Recipes for Ramadan: Taysir Ghazi’s ful medames, four ways",
                fields: .init(thumbnail: "https://media.guim.co.uk/c15c453c8e89db724c3c427f8c37621701350894/70_7_2614_1568/500.jpg",
                              headline: "Recipes for Ramadan: Taysir Ghazi’s ful medames, four ways"
                             ),
                tags: [.init(id: "food/series/recipes-for-ramadan", webTitle: "Recipes for Ramadan")]
            )
        )
    }
}
