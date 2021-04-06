//
//  CounterCache.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import Foundation

protocol CounterCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ counters: [Counter], completion: @escaping (Result) -> Void)
}
