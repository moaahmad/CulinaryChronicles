//
//  CulinaryChroniclesApp.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 31/03/2023.
//

import SwiftUI

@main
struct CulinaryChroniclesApp: App {
    /// ContentSizeCategory represents the preferred content
    /// size category set by the user in their device settings.
    @Environment(\.sizeCategory) var sizeCategory
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RecipeFeedView(viewModel: viewModel)
                    .environment(\.sizeCategory, sizeCategory)
            }
        }
    }
}
