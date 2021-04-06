//
//  RemoteCounterOperator.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import Foundation

final class RemoteCounterOperator: CounterOperator {
    private let client: HTTPClient
    private let url: URL
    
    typealias Result = CountersResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func operate(id: String, completion: @escaping (Result) -> Void) {
        client.send(url, method: .post, parameters: parameter(id: id)) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(CountersMapper.mappedResult(of: data, from: response))
            case .failure:
                completion(.failure(CountersMapper.Error.connectivity))
            }
        }
    }
    
    private func parameter(id: String) -> [String: String] {
        ["id": id]
    }
}
