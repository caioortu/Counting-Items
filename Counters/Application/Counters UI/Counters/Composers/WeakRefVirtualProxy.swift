//
//  WeakRefVirtualProxy.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: CounterLoadingView where T: CounterLoadingView {
    func display(_ viewModel: CounterLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: CounterErrorView where T: CounterErrorView {
    func display(_ viewModel: CounterErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: CountersView where T: CountersView {
    func display(_ viewModel: CountersViewModel) {
        object?.display(viewModel)
    }
}
