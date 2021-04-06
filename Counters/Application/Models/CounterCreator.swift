//
//  CounterCreator.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import Foundation

protocol CounterCreator {
    func create(title: String, completion: @escaping (CountersResult) -> Void)
}
