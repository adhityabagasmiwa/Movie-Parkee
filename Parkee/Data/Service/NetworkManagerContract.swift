//
//  NetworkManagerContract.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation
import Alamofire

protocol NetworkManagerContract {
    var apiKey: String { get }
    
    func fetchAPI<T:Decodable>(fromUrl: String, forType type: T.Type, method: HTTPMethod, parameters: Parameters?, completion : @escaping ((Result<T, APIError>)->Void))
}
