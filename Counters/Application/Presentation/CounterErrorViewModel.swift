//
//  CounterErrorViewModel.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import Foundation

struct CounterErrorViewModel {
    let title: String?
    let message: String?
    let actionTitles: [String]
    let actions: [() -> Void]
    
    static var noError: CounterErrorViewModel {
        return CounterErrorViewModel(title: nil, message: nil, actionTitles: [], actions: [])
    }
    
    static func error(
        title: String? = nil,
        message: String,
        actionTitles: [String] = [],
        actions: [() -> Void] = []
    ) -> CounterErrorViewModel {
        return CounterErrorViewModel(title: title, message: message, actionTitles: actionTitles, actions: actions)
    }
}
