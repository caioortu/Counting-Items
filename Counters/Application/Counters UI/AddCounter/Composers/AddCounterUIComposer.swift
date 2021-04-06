//
//  AddCounterUIComposer.swift
//  Counters
//
//  Created by Caio Ortu on 4/5/21.
//

import UIKit

enum AddCounterUIComposer {
    static func composedWith(creator: CounterCreator) -> AddCounterViewController {
        let addCounterPresenter = AddCounterPresenter(creator: MainQueueDispatchDecorator(decoratee: creator))
        let addCounterViewController = AddCounterViewController(presenter: addCounterPresenter)
        
        addCounterPresenter.countersView = WeakRefVirtualProxy(addCounterViewController)
        addCounterPresenter.loadingView = WeakRefVirtualProxy(addCounterViewController)
        addCounterPresenter.errorView = WeakRefVirtualProxy(addCounterViewController)
        
        return addCounterViewController
    }
}
