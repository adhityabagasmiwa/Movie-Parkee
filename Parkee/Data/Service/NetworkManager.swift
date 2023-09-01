//
//  NetworkManager.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation
import Alamofire

class NetworkManager: NetworkManagerContract {

    let headers: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer \(Constants.authToken)"
    ]

    var apiKey: String {
        return Constants.apiKey
    }
    
    func fetchAPI<T>(fromUrl: String, forType type: T.Type, method: HTTPMethod, parameters: Parameters?, completion: @escaping ((Result<T, APIError>) -> Void)) where T : Decodable {
        AF.request(fromUrl, method: method, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: type, completionHandler: { response in
                switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(_):
                        if let data = response.data {
                            do {
                                let decoder = JSONDecoder()
                                let _ = try decoder.decode(T.self, from: data)
                                completion(.failure(.invalidResponse))
                            } catch {
                                completion(.failure(.invalidData))
                            }
                        } else {
                            completion(.failure(.invalidResponse))
                        }
                }
            }
        )
    }
}
