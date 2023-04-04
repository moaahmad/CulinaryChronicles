//
//  Error.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 03/04/2023.
//

import Foundation

enum URLRequestError: Error {
    case invalidURL
    case requestFailed
    case unknownError
    case noDataReturned
}

enum HTTPError: Error, Equatable {
    case requestFailed(with: String)
    case noInternet
    case timedOut

    var text: String {
        switch self {
        case .noInternet:
            return "iPhone is offline. Please reconnect and try again."
        case .timedOut:
            return "Request timed out."
        case .requestFailed(let error):
            return "Request Failed - \(error)"
        }
    }
}
