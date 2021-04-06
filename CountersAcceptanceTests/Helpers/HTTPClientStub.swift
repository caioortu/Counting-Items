//
//  CountersAcceptanceTests+HTTPClientStub.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import Foundation
@testable import Counters

class HTTPClientStub: HTTPClient {
    private let stub: (URL) -> HTTPClient.Result
    
    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    func send(_ url: URL, method: HTTPMethod, parameters: [String : String], completion: @escaping (HTTPClient.Result) -> Void) {
        completion(stub(url))
    }
}

extension HTTPClientStub {
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }
}
