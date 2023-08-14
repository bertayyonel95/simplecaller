//
//  ObjectSaveableError.swift
//  findfood
//
//  Created by Bertay Yönel on 31.01.2023.
//

import Foundation

/// Enum that covers `UserDefaultsManager` operation error cases
enum ObjectSaveableError: String, LocalizedError {

    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }

}
