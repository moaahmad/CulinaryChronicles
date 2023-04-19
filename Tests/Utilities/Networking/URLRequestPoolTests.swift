//
//  URLRequestPoolTests.swift
//  CulinaryChroniclesTests
//
//  Created by Mo Ahmad on 04/04/2023.
//

import XCTest
@testable import CulinaryChronicles

final class URLRequestPoolTests: XCTestCase {
    func test_recipesRequest_configuredCorrectly() {
        // Given
        let urlRequestPool = URLRequestPool()

        // When
        let sut = urlRequestPool.fetchRecipesRequest(forPage: 1)

        // Then
        XCTAssertEqual(sut.url?.scheme, "https")
        XCTAssertEqual(sut.url?.host, "content.guardianapis.com")
        XCTAssertEqual(sut.url?.pathComponents, ["/", "search"])
        XCTAssertEqual(sut.url?.getQueryItemValueForKey(key: "page"), "1")
        XCTAssertEqual(sut.url?.getQueryItemValueForKey(key: "tag"), "tone/recipes")
        XCTAssertEqual(sut.url?.getQueryItemValueForKey(key: "show-tags"), "series")
        XCTAssertEqual(sut.url?.getQueryItemValueForKey(key: "show-fields"), "thumbnail,headline")
        XCTAssertNotNil(sut.url?.getQueryItemValueForKey(key: "api-key"))
        XCTAssertEqual(sut.httpMethod, "GET")
        XCTAssertEqual(sut.timeoutInterval, 60.0)
    }
}
