//
//  RequestModel.swift
//  findfood
//
//  Created by Bertay Yönel on 24.01.2023.
//
// swiftlint:disable force_cast

import Foundation

class RequestModel {
    // MARK: Properties
    var path: String {
        .empty
    }
    var headers: [String: String] {
        ["accept": "application/json"]
    }
    var endpoint: String {
        Constants.API.url
    }
}

// MARK: - Helpers
extension RequestModel {
    
    /// Generates a request for the network call
    ///
    /// - Returns: A URL request to be used to make a network call.
    func generateRequest() -> URLRequest? {
        guard let url = generateURL() else { return nil }
        var request = URLRequest(url: url)
        headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
}
private extension RequestModel {
    // MARK: Private Functions
    func generateURL() -> URL? {
        let endpoint = endpoint.appending(path)
        var urlComponents = URLComponents(string: endpoint)
//        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return nil }
        return url
    }
    /// Generates queries with the parameters
    /// found in the "parameters" array of the model.
    ///
    /// - Returns: An array created with the model's parameters
//    func generateQueryItems() -> [URLQueryItem] {
//        var queryItems: [URLQueryItem] = []
//        parameters.forEach { parameter in
//            let value = parameter.value as! String
//            queryItems.append(.init(name: parameter.key, value: value))
//        }
//        return queryItems
//    }
}
