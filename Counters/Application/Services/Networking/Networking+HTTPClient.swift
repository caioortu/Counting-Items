//
//  Networking+HTTPClient.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import Foundation

extension Networking: HTTPClient {
    func send(_ url: URL, method: HTTPMethod, parameters: [String : String], completion: @escaping (HTTPClient.Result) -> Void) {
        dataRequest(url, httpMethod: method.rawValue, parameters: parameters) { (data, response, error) in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw self.error(CountersErrorCode.noData)
                }
            })
        }.resume()
    }
}
