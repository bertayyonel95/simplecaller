//
//  NetworkManager.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import Foundation

protocol Networking {
    func networkRequest<T: Decodable>(request: RequestModel, completion: @escaping (Result<T, APIError>) -> Void)
    func networkPost<T: Codable>(post: PostModel, completion: @escaping (Result<T, APIError>) -> Void)
}

// MARK: - NetworkManager
class NetworkManager: Networking {
    // MARK: Properties
    private let session: URLSession
    // MARK: Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    // MARK: Helpers
    /// Request data with the provided request mode from the database.
    ///
    /// - Parameters:
    ///    - request: request model to be used to make a network request.
    func networkRequest<T: Decodable>(request: RequestModel, completion: @escaping (Result<T, APIError>) -> Void) {
        var generatedRequest: URLRequest?
        generatedRequest = request.generateRequest()
        generatedRequest?.httpMethod = "GET"
        let task = session.dataTask(with: generatedRequest!) { data, response, error in
            if let error {
                completion(.failure(.unknownError))
                return
            }
            guard let data else {
                completion(.failure(.unknownError))
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
            do {
                let convertedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(convertedData))
            } catch {
                completion(.failure(.unknownError))
            }
        }
        task.resume()
    }
    
    func networkPost<T: Codable>(post: PostModel, completion: @escaping (Result<T, APIError>) -> Void) {
        var generatedRequest: NSMutableURLRequest?
//        generatedRequest = post.generatePost()
        generatedRequest?.httpMethod = "POST"
        let task = session.dataTask(with: generatedRequest! as URLRequest) { data, response, error in
            if let error {
                completion(.failure(.unknownError))
                return
            }
            guard let data else {
                completion(.failure(.unknownError))
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
            do {
                let convertedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(convertedData))
            } catch {
                completion(.failure(.unknownError))
            }
        }
        task.resume()
    }
}
