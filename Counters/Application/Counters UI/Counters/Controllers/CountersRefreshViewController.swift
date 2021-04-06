//
//  CountersRefreshViewController.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit

final class CountersRefreshViewController {
    private(set) lazy var view = loadView()
    
    private let presenter: CountersPresenter
    
    init(presenter: CountersPresenter) {
        self.presenter = presenter
    }
    
    @objc func refresh() {
        presenter.didRequestCountersRefresh()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

extension CountersRefreshViewController: CounterLoadingView {
    func display(_ viewModel: CounterLoadingViewModel) {
        viewModel.isLoading ? view.beginRefreshing() : view.endRefreshing()
    }
}
