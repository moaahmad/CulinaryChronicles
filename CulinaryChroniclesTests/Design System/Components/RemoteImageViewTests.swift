//
//  RemoteImageViewTests.swift
//  CulinaryChroniclesTests
//
//  Created by Mo Ahmad on 05/04/2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import CulinaryChronicles

final class RemoteImageViewTests: XCTestCase {
    func test_RemoteImageView() {
        // Given
        let sut = RemoteImageView(
            imageURL: URL(string: "https://media.guim.co.uk/c15c453c8e89db724c3c427f8c37621701350894/70_7_2614_1568/500.jpg")!
        ).scaledToFit()

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image)
    }
}
