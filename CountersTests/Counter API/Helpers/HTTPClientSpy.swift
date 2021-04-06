//
//  HTTPClientSpy.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/1/21.
//

@testable import Counters

class HTTPClientSpy: HTTPClient {
    var messages = [(url: URL, method: HTTPMethod, parameters: [String: String], completion: (HTTPClient.Result) -> Void)]()
    
    var requestedURLs: [URL] {
        messages.map { $0.url }
    }
    
    var requestedMethods: [HTTPMethod] {
        messages.map { $0.method }
    }
    
    var requestedParameters: [[String: String]] {
        messages.map { $0.parameters }
    }
    
    func send(_ url: URL, method: HTTPMethod, parameters: [String: String], completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((url, method, parameters, completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int,
                  data: Data,
                  at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        
        messages[index].completion(.success((data, response)))
    }
}
