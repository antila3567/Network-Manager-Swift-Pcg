//
//  File.swift
//  
//
//  Created by Иван Легенький on 11.01.2024.
//

import Foundation

public protocol NMRequest {
    init(baseURL: URL, path: String)
    
    @discardableResult
    func set(method: HTTPMethods) -> Self
    
    @discardableResult
    func set(path: String) -> Self
    
    @discardableResult
    func set(headers: [String: String]?) -> Self
    
    @discardableResult
    func set(parameters: NMRequestParams) -> Self
    
    func build() throws -> URLRequest
}
