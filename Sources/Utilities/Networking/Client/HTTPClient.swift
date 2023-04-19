//
//  HTTPClient.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 05/04/2023.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func performRequest(_ request: URLRequest, completion: @escaping (Result) -> Void)
}
