//
//  CounterDeleter.swift
//  Counters
//
//  Created by Caio Ortu on 4/5/21.
//

import Foundation

protocol CounterDeleter {
    func delete(id: String, completion: @escaping (CountersResult) -> Void)
}
