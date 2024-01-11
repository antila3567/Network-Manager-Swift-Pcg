//
//  File.swift
//  
//
//  Created by Иван Легенький on 11.01.2024.
//

import Foundation

public final class NMRequestBuilder: NMRequest {
    private var baseURL: URL
    private var path: String
    private var method: HTTPMethods = .get
    private var headers: [String: String]?
    private var parameters: NMRequestParams?
    

    public init(baseURL: URL, path: String) {
        self.baseURL = baseURL
        self.path = path
    }
    
    @discardableResult
    public func set(method: HTTPMethods) -> Self {
        self.method = method
        return self
    }
    
    @discardableResult
    public func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    @discardableResult
    public func set(headers: [String : String]?) -> Self {
        self.headers = headers
        return self
    }
    
    @discardableResult
    public func set(parameters: NMRequestParams) -> Self {
        self.parameters = parameters
        return self
    }
    
    public func build() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url, cachePolicy:  .reloadRevalidatingCacheData, timeoutInterval: 50)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        setupBody(urlRequest: &urlRequest)
        
        return urlRequest
    }
    
    private func setupBody(urlRequest: inout URLRequest) {
        if let parameters = parameters {
            switch parameters {
            case .body(let bodyParam):
                setupRequestBody(bodyParam, for: &urlRequest)
            case .url(let urlParam):
                setupRequestURLBody(urlParam, for: &urlRequest)
            }
        }
        
    }
    
    private func setupRequestBody(_ parameters: [String: Any]?, for request: inout URLRequest) {
        if let parameters = parameters {
            let data = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            request.httpBody = data
        }
    }
    
    private func setupRequestURLBody(_ parameters: [String: String]?, for request: inout URLRequest)  {
        if let parameters = parameters,  
           let url = request.url,
           var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            
            request.url = urlComponents.url
        }
    }
}
