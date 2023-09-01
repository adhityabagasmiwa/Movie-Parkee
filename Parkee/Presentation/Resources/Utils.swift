//
//  Utils.swift
//  Parkee
//
//  Created by Adhitya Bagas on 01/09/23.
//

import Foundation

struct SwiftUtility {
    
    static func loadJSON(filename fileName: String) -> Data {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let dataObj = try Data(contentsOf: url)
                return dataObj
            } catch let error {
                debugPrint("[LOG - ERROR LOAD JSON]: ", error)
            }
        }
        return Data()
    }
    
}
