//
//  File.swift
//  
//
//  Created by Иван Легенький on 11.01.2024.
//

import Foundation

public enum NMRequestParams {
    case body(_: [String: Any]?)
    case url(_: [String: String]?)
}
