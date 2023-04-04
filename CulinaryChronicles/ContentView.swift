//
//  ContentView.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 31/03/2023.
//

import SwiftUI

struct ContentView: View {
    /// ContentSizeCategory represents the preferred content
    /// size category set by the user in their device settings.
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        RecipeFeedView(viewModel: RecipeViewModel())
            .environment(\.sizeCategory, sizeCategory)
    }
}
