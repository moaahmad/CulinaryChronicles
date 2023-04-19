//
//  RecipeCellViewTests.swift
//  CulinaryChroniclesTests
//
//  Created by Mo Ahmad on 05/04/2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import CulinaryChronicles

final class RecipeCellViewTests: XCTestCase {
    func test_RecipeCellView() {
        // Given
        let sut = RecipeCellView(recipe: .anyRecipe()).scaledToFit()

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image)
    }
}
