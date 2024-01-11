// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import Foundation

public protocol NMProtocol {
    func makeRequest<T: Codable>(with builder: NMRequestBuilder, type: T.Type) -> AnyPublisher<T, APIError>
}

public class NM: NMProtocol {
    public func makeRequest<T: Codable>(with builder: NMRequestBuilder, type: T.Type) -> AnyPublisher<T, APIError> {
        do {
            let request = try builder.build()
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap { data, response -> Data in
                    guard let httpresponse = response as? HTTPURLResponse, (200...299).contains(httpresponse.statusCode) else {
                        throw APIError.unknownError("Bad response code")
                    }
                    
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error -> APIError in
                    if error is DecodingError {
                        return APIError.decodingError
                    } else if let error = error as? APIError {
                        return error
                    } else {
                        return APIError.unknownError("Unknown error")
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: APIError.urlError).eraseToAnyPublisher()
        }
    }
    
    public init() {
        
    }
}
