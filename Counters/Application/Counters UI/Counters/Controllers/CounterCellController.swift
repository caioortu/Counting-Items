//
//  CounterCellController.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit

final class CounterCellController {
    private var cell: CounterCell?
    private let presenter: CounterCellPresenter
    
    init(presenter: CounterCellPresenter) {
        self.presenter = presenter
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell: CounterCell = tableView.dequeueReusableCell()
        setupCell(cell: cell)
        self.cell = cell
        
        return cell
    }
    
    func setIsEnabled(_ isEnabled: Bool) {
        cell?.stepper.isEnabled = isEnabled
    }
    
    private func setupCell(cell: CounterCell) {
        cell.titleLabel.text = presenter.title()
        cell.countLabel.text = presenter.countText()
        cell.countLabel.textColor = presenter.countColor()
        cell.setStepperValue(presenter.counterCount())
        cell.onIncrease = presenter.didRequestCounterIncrease
        cell.onDecrease = presenter.didRequestCounterDecrease
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

private extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }
}
