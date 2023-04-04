//
//  DataProvider.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 03/04/2023.
//

import Combine
import Foundation

protocol DataProviding {
    func fetch<T: Decodable>(type: T.Type, urlRequest: URLRequest, completionHandler: @escaping (Result<T, Error>) -> Void)
}

struct DataProvider: DataProviding {
    // MARK: - Properties

    private let session: URLSession
    private let decoder: JSONDecoder

    // MARK: - Initializer

    init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    // MARK: - DataProviding Functions

    func fetch<T: Decodable>(
        type: T.Type,
        urlRequest: URLRequest,
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) {
        session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completionHandler(.failure(error))
            }

            if let response = response as? HTTPURLResponse,
               !response.isSuccessful {
                completionHandler(.failure(HTTPError.requestFailed(with: response.errorString)))
            }

            if let data {
                do {
                    let response = try decoder.decode(type.self, from: data)
                    completionHandler(.success(response))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }
}
