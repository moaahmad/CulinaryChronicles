//
//  XCTestCase+Extensions.swift
//  CulinaryChroniclesTests
//
//  Created by Mo Ahmad on 04/04/2023.
//

import XCTest

// MARK: - Memory Leak Tracking

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
