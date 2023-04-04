//
//  URLPool.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 03/04/2023.
//

import Foundation

struct URLPool {
    private enum Endpoint: String {
        case search = "/search"
    }

    static private let scheme = "https"
    static private let host = "content.guardianapis.com"

    static func recipesURL(forPage page: Int) -> URL {
        let parameters = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "tag", value: "tone/recipes"),
            URLQueryItem(name: "show-tags", value: "series"),
            URLQueryItem(name: "show-fields", value: "thumbnail,headline"),
            URLQueryItem(name: "api-key", value: AppEnvironment.apiKey)
        ]
        return configureURL(
            scheme: scheme,
            host: host,
            path: Endpoint.search.rawValue,
            parameters: parameters
        )
    }
}

// MARK: - Private Methods

private extension URLPool {
    static func configureURL(
        scheme: String,
        host: String,
        path: String,
        parameters: [URLQueryItem]? = nil
    ) -> URL {
        let urlComponents = configureURLComponents(
            scheme: scheme,
            host: host,
            path: path,
            parameters: parameters
        )
        guard let url = urlComponents.url,
              let urlString = url.absoluteString.removingPercentEncoding,
              let fullURL = URL(string: urlString) else {
            fatalError("URL is not correctly configured")
        }
        return fullURL
    }

    static func configureURLComponents(
        scheme: String,
        host: String,
        path: String,
        parameters: [URLQueryItem]?
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = parameters
        return components
    }
}
