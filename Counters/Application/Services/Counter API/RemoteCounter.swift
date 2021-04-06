//
//  RemoteCounter.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import Foundation

struct RemoteCounter: Decodable {
    let id: String
    let title: String?
    let count: Int
}
