//
//  RemoteCounterCreator.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import Foundation

final class RemoteCounterCreator: CounterCreator {
    private let client: HTTPClient
    private let url: URL
    
    typealias Result = CountersResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func create(title: String, completion: @escaping (Result) -> Void) {
        client.send(url, method: .post, parameters: parameter(title: title)) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(CountersMapper.mappedResult(of: data, from: response))
            case .failure:
                completion(.failure(CountersMapper.Error.connectivity))
            }
        }
    }
    
    private func parameter(title: String) -> [String: String] {
        ["title": title]
    }
}
