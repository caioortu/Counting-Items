//
//  CountersViewController+TestHelpers.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit
@testable import Counters

extension CountersViewController {
    var titleText: String? {
        return title
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    var isShowingErrorView: Bool {
        return errorView.isHidden == false
    }
    
    var isShowingSearchErrorView: Bool {
        return searchController.resultsController.errorView.isHidden == false
    }
    
    var errorViewMessage: String? {
        return errorView.messageLabel.text
    }
    
    var searchErrorViewMessage: String? {
        return searchController.resultsController.errorView.messageLabel.text
    }
    
    var isShowingCountedMessage: Bool {
        return barController.bottomBarTitleLabel.text != ""
    }
    
    var countedMessage: String? {
        return barController.bottomBarTitleLabel.text
    }
    
    @discardableResult
    func simulateCounterViewVisible(at index: Int) -> CounterCell? {
        return counterView(at: index) as? CounterCell
    }
    
    func simulateUserInitiatedCountersReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateAddAction() {
        barController.addButton.simulateTap()
    }
    
    func simulateErrorViewAction() {
        errorView.button.simulateTap()
    }
    
    func simulateSearch(with term: String) {
        searchController.searchBar.text = term
    }
    
    func numberOfRenderedCounterViews() -> Int {
        return tableView.numberOfRows(inSection: countersSection)
    }
    
    func counterView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: countersSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    func numberOfSearchedCounterViews() -> Int {
        return searchController.resultsController.tableView.numberOfRows(inSection: countersSection)
    }
    
    func searchedCounterView(at row: Int) -> UITableViewCell? {
        let tableView = searchController.resultsController.tableView!
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: countersSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var countersSection: Int {
        return 0
    }
}
