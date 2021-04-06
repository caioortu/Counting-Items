//
//  CountersSearchResultsController.swift
//  Counters
//
//  Created by Caio Ortu on 4/5/21.
//

import UIKit

class CountersSearchResultsController: CounterListViewController {
    private let presenter: CountersSearchPresenter
    
    init(presenter: CountersSearchPresenter) {
        self.presenter = presenter
        super.init()
    }
    
    func search(term: String) {
        presenter.didRequestCountersSearch(term: term)
    }
}
