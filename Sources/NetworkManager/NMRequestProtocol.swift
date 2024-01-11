//
//  File.swift
//  
//
//  Created by Иван Легенький on 11.01.2024.
//

import Foundation

public protocol NMRequestProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethods { get }
    var headers: [String: String]? { get }
    var parameters: NMRequestParams? { get }
}
