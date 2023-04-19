//
//  URLRequest+Extensions.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 03/04/2023.
//

import Foundation

extension URLRequest {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}

extension URLRequest {
    init(method: HTTPMethod, url: URL) {
        self.init(url: url)
        httpMethod = method.rawValue
    }
}
