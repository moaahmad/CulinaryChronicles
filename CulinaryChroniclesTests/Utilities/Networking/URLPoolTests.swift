//
//  URLPoolTests.swift
//  CulinaryChroniclesTests
//
//  Created by Mo Ahmad on 04/04/2023.
//

import XCTest
@testable import CulinaryChronicles

final class URLPoolTests: XCTestCase {
    func test_recipesURL_configuredCorrectly() {
        // Given
        let sut = URLPool.recipesURL(forPage: 1)

        // Then
        XCTAssertEqual(sut.scheme, "https")
        XCTAssertEqual(sut.host, "content.guardianapis.com")
        XCTAssertEqual(sut.pathComponents, ["/", "search"])
        XCTAssertEqual(sut.getQueryItemValueForKey(key: "page"), "1")
        XCTAssertEqual(sut.getQueryItemValueForKey(key: "tag"), "tone/recipes")
        XCTAssertEqual(sut.getQueryItemValueForKey(key: "show-tags"), "series")
        XCTAssertEqual(sut.getQueryItemValueForKey(key: "show-fields"), "thumbnail,headline")
        XCTAssertNotNil(sut.getQueryItemValueForKey(key: "api-key"))
    }
}
