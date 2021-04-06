//
//  AddCounterViewController.swift
//  Counters
//
//  Created by Caio Ortu on 4/5/21.
//

import UIKit

final class AddCounterViewController: UIViewController {
    private(set) lazy var innerView = AddCounterView()
    private(set) var saveBarButton: UIBarButtonItem?
    
    private let presenter: AddCounterPresenter
    
    init(presenter: AddCounterPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = innerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true)
    }
    
    @objc private func savePressed() {
        presenter.didRequestCounterCreation(title: innerView.textField.text)
    }
}

extension AddCounterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        
        saveBarButton?.isEnabled = !text.isEmpty
        return true
    }
}

extension AddCounterViewController: CounterLoadingView {
    func display(_ viewModel: CounterLoadingViewModel) {
        saveBarButton?.isEnabled = !viewModel.isLoading
        viewModel.isLoading ? innerView.activityIndicator.startAnimating() : innerView.activityIndicator.stopAnimating()
    }
}

extension AddCounterViewController: CountersView {
    func display(_ viewModel: CountersViewModel) {
        dismissAction()
    }
}

extension AddCounterViewController: CounterErrorView {
    func display(_ viewModel: CounterErrorViewModel) {
        let alertController = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        let actionDismiss = UIAlertAction(title: viewModel.actionTitles.first, style: .default, handler: nil)
        alertController.addAction(actionDismiss)
        
        present(alertController, animated: true)
    }
}

private extension AddCounterViewController {
    func setup() {
        title = presenter.title
        setupNavigationBar()
        setupTextField()
    }
    
    func setupTextField() {
        innerView.textField.delegate = self
        innerView.textField.placeholder = presenter.placeholder
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissAction)
        )
        saveBarButton = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(savePressed)
        )
        saveBarButton?.isEnabled = false
        
        navigationItem.rightBarButtonItem = saveBarButton
    }
}
