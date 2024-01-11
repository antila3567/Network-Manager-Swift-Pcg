//
//  File.swift
//  
//
//  Created by Иван Легенький on 11.01.2024.
//

import Foundation

public enum APIError: Error {
    case urlError
    case decodingError
    case unknownError(String)
}
