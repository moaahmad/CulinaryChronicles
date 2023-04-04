//
//  URLRequestPool.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 03/04/2023.
//

import Foundation

protocol URLRequestPooling {
    func fetchRecipesRequest(forPage page: Int) -> URLRequest
}

struct URLRequestPool: URLRequestPooling {
    func fetchRecipesRequest(forPage page: Int) -> URLRequest {
        .init(method: .get, url: URLPool.recipesURL(forPage: page))
    }
}
