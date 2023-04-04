//
//  HTTPURLResponse+Extensions.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 03/04/2023.
//

import Foundation

extension HTTPURLResponse {
    var isSuccessful: Bool {
        (200...299).contains(statusCode)
    }

    var errorString: String {
        HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }
}
