//
//  RemoteCounterDeleter.swift
//  Counters
//
//  Created by Caio Ortu on 4/5/21.
//

import Foundation

final class RemoteCounterDeleter: CounterDeleter {
    private let client: HTTPClient
    private let url: URL
    
    typealias Result = CountersResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func delete(id: String, completion: @escaping (Result) -> Void) {
        client.send(url, method: .delete, parameters: parameter(id: id)) { [weak self] result in
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
