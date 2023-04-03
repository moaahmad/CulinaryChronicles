//
//  RecipeCellView.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 03/04/2023.
//

import SwiftUI

struct RecipeCellView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: .Spacer.sm) {
            VStack(alignment: .leading, spacing: .Spacer.xxxs) {
                // Tag View
                if let tag = recipe.tags.first?.webTitle {
                    Text(tag.uppercased())
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Headline View
                Text(recipe.webTitle)
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Image View
            if let imageURL = recipe.fields.thumbnailURL {
                RemoteImageView(imageURL: imageURL)
                    .aspectRatio(1.6, contentMode: .fit)
                    .cornerRadius(12)
                    .padding(.bottom, .Spacer.md)
            }
        }
        .padding([.horizontal, .top], .Spacer.sm)
    }
}

struct RecipeCellView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCellView(
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
