//
//  APIError.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation

enum APIError: String, Error {
    case invalidData = "The data received from server is invalid, please try again "
    case invalidResponse = "Invalid response from server"
}

enum DBError: String, Error {
    case invalidSaveContext = "Invalid save to context db"
    case invalidData = "Invalid data from db"
}
