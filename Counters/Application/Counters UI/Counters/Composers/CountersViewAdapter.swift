//
//  CountersViewAdapter.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit

final class CountersViewAdapter {
    private weak var controller: CountersViewController?
    private weak var searchController: CountersSearchResultsController?
    private weak var presenter: CountersPresenter?
    private let increaseOperator: CounterOperator
    private let decreaseOperator: CounterOperator
    
    init(
        controller: CountersViewController,
        searchController: CountersSearchResultsController,
        presenter: CountersPresenter,
        increaseOperator: CounterOperator,
        decreaseOperator: CounterOperator
    ) {
        self.controller = controller
        self.searchController = searchController
        self.presenter = presenter
        self.increaseOperator = increaseOperator
        self.decreaseOperator = decreaseOperator
    }
    
    private func mapToController(models: [Counter]) -> [CounterCellController] {
        return models.map { model in
            let presenter = CounterCellPresenter(
                counter: model,
                increaseOperator: increaseOperator,
                decreaseOperator: decreaseOperator
            )
            
            presenter.countersView = WeakRefVirtualProxy(self)
            presenter.errorView = WeakRefVirtualProxy(self)
            
            return CounterCellController(presenter: presenter)
        }
    }
}

extension CountersViewAdapter: CountersView {
    func display(_ viewModel: CountersViewModel) {
        controller?.tableModel = mapToController(models: viewModel.counters)
        controller?.setBarTitle(presenter?.countedCounter(viewModel.counters))
        controller?.searchController.searchTerm()
    }
}

extension CountersViewAdapter: CountersSearchView {
    func displaySearch(_ viewModel: CountersViewModel) {
        searchController?.tableModel = mapToController(models: viewModel.counters)
    }
}

extension CountersViewAdapter: CounterErrorView {
    func display(_ viewModel: CounterErrorViewModel) {
        let alertController = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        let actionRetry = UIAlertAction(title: viewModel.actionTitles[0], style: .cancel) { _ in
            viewModel.actions[0]()
        }
        let actionDismiss = UIAlertAction(title: viewModel.actionTitles[1], style: .default, handler: nil)
        alertController.addAction(actionRetry)
        alertController.addAction(actionDismiss)
        
        controller?.present(alertController, animated: true)
    }
}
