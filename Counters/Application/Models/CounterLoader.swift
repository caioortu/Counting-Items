//
//  CounterLoader.swift
//  Counters
//
//  Created by Caio Ortu on 3/29/21.
//

import Foundation

protocol CounterLoader {
    func load(completion: @escaping (CountersResult) -> Void)
}
