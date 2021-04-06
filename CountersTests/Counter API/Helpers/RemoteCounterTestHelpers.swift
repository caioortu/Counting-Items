//
//  RemoteCounterTestHelpers.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/1/21.
//

import Foundation
@testable import Counters

func failure(_ error: CountersMapper.Error) -> CountersResult {
    return .failure(error)
}

func makeCounter(id: String, title: String = "some title", count: Int = 0) -> (model: Counter, json: [String: Any]) {
    let counter = Counter(id: id, title: title, count: count)
    
    let json = [
        "id": id,
        "title": title,
        "count": count
    ].compactMapValues { $0 }
    
    return (counter, json)
}

func makeCountersJSON(_ counters: [[String: Any]]) -> Data {
    let json = counters
    return try! JSONSerialization.data(withJSONObject: json)
}

func anyTitle() -> String {
    return "some title"
}

func uniqueId() -> String {
    UUID().uuidString
}
