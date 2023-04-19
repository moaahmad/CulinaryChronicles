//
//  RecipeResponse.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 03/04/2023.
//

import Foundation

struct RecipeResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let results: [Recipe]
}
