//
//  CounterOperator.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import Foundation

protocol CounterOperator {
    func operate(id: String, completion: @escaping (CountersResult) -> Void)
}
