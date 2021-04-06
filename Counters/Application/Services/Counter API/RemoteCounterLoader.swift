//
//  RemoteCounterLoader.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import Foundation

final class RemoteCounterLoader: CounterLoader {
    private let client: HTTPClient
    private let url: URL
    
    typealias Result = CountersResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.send(url, method: .get, parameters: [:]) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(CountersMapper.mappedResult(of: data, from: response))
            case .failure:
                completion(.failure(CountersMapper.Error.connectivity))
            }
        }
    }
}
