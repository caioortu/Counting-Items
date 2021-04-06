//
//  HTTPClient.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func send(_ url: URL, method: HTTPMethod, parameters: [String: String], completion: @escaping (Result) -> Void)
}
