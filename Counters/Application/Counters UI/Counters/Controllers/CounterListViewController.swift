//
//  CounterListViewController.swift
//  Counters
//
//  Created by Caio Ortu on 4/5/21.
//

import UIKit

class CounterListViewController: UITableViewController {
    let errorView = ErrorView()
    var tableModel = [CounterCellController]() {
        didSet { tableView.reloadData() }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        setupTableView()
        setupErrorView()
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        tableView.register(CounterCell.self, forCellReuseIdentifier: CounterCell.identifier)
    }
    
    private func setupErrorView() {
        view.addSubview(errorView)
        
        let guide = view.safeAreaLayoutGuide
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 35),
            errorView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -35),
            errorView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
        ])
    }
}

extension CounterListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    func cellController(forRowAt indexPath: IndexPath) -> CounterCellController {
        return tableModel[indexPath.row]
    }
}

extension CounterListViewController: CounterErrorView {
    func display(_ viewModel: CounterErrorViewModel) {
        errorView.show(
            title: viewModel.title,
            message: viewModel.message,
            actionTitle: viewModel.actionTitles.first,
            action: viewModel.actions.first,
            animated: true)
    }
}
