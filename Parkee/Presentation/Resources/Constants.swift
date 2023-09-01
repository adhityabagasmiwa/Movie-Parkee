//
//  Constants.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation

enum Constants {
    static let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    static let apiVersion = "3/"
    static let authToken = ProcessInfo.processInfo.environment["AUTH_TOKEN"] ?? ""
}
