//
//  CountersUIComposer.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit

enum CountersUIComposer {
    static func composedWith(
        loader: CounterLoader,
        increaseOperator: CounterOperator,
        decreaseOperator: CounterOperator,
        addAction: @escaping () -> Void = {}
    ) -> CountersViewController {
        let mainQueueLoader = MainQueueDispatchDecorator(decoratee: loader)
        let countersPresenter = CountersPresenter(loader: mainQueueLoader, addAction: addAction)
        let countersRefreshController = CountersRefreshViewController(presenter: countersPresenter)

        let searchPresenter = CountersSearchPresenter(loader: mainQueueLoader)
        let searchResultsController = CountersSearchResultsController(presenter: searchPresenter)
        let searchController = CountersSearchController(resultsController: searchResultsController)
        
        let barController = CountersBarController(addAction: addAction)
        
        let countersController = CountersViewController(
            refreshController: countersRefreshController,
            barController: barController,
            searchController: searchController,
            title: countersPresenter.title
        )
        
        let viewAdapter = CountersViewAdapter(
            controller: countersController,
            searchController: searchResultsController,
            presenter: countersPresenter,
            increaseOperator: MainQueueDispatchDecorator(decoratee: increaseOperator),
            decreaseOperator: MainQueueDispatchDecorator(decoratee: decreaseOperator)
        )
        countersPresenter.errorView = WeakRefVirtualProxy(countersController)
        countersPresenter.loadingView = WeakRefVirtualProxy(countersRefreshController)
        countersPresenter.countersView = viewAdapter
        
        searchPresenter.searchView = viewAdapter
        searchPresenter.errorView = WeakRefVirtualProxy(searchResultsController)
        
        return countersController
    }
}
