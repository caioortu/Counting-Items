//
//  CountersViewController.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit

final class CountersViewController: CounterListViewController {
    private let refreshController: CountersRefreshViewController
    let searchController: CountersSearchController
    let barController: CountersBarController
    
    init(
        refreshController: CountersRefreshViewController,
        barController: CountersBarController,
        searchController: CountersSearchController,
        title: String) {
        self.refreshController = refreshController
        self.barController = barController
        self.searchController = searchController
        super.init()
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshController.refresh()
    }
    
    func setBarTitle(_ title: String?) {
        barController.setBarTitle(title)
    }
    
    override func setupLayout() {
        super.setupLayout()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchController()
        setupRefreshControl()
        setupBarControler()
        setupBars()
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
    }
}

extension CountersViewController {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        cellController(forRowAt: indexPath).setIsEnabled(!tableView.isEditing)
        return true
    }
}

private extension CountersViewController {
    func setupRefreshControl() {
        refreshControl = refreshController.view
    }
    
    func setupBarControler() {
        navigationController?.isToolbarHidden = false
        
        barController.editAction = { [weak self] editing in
            self?.setEditing(editing, animated: true)
            self?.navigationItem.searchController?.searchBar.isUserInteractionEnabled = !editing
            self?.setupBars()
        }
        setupBars()
    }
    
    func setupBars() {
        barController.setupBars(tableView.isEditing)
        toolbarItems = barController.toolbarItems
        navigationItem.leftBarButtonItem = barController.leftBarButtonItem
        navigationItem.rightBarButtonItem = barController.rightBarButtonItem
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
    }
}
