//
//  Recipe.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 03/04/2023.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: String
    let webTitle: String
    let fields: Fields
    let tags: [Tag]
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
}

struct Fields: Codable {
    let thumbnail: String
    let headline: String

    var thumbnailURL: URL? {
        guard let url = URL(string: thumbnail) else {
            return nil
        }
        return url
    }
}

struct Tag: Codable {
    let id: String
    let webTitle: String
}
