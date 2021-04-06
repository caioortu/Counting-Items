//
//  WelcomeViewController.swift
//  Counters
//
//

import UIKit

protocol WelcomeViewControllerPresenter {
    var viewModel: WelcomeView.ViewModel { get }
}

class WelcomeViewController: UIViewController {
    private(set) lazy var innerView = WelcomeView()
    
    private let presenter: WelcomeViewControllerPresenter
    private let primaryAction: () -> Void
    
    init(presenter: WelcomeViewControllerPresenter, primaryAction: @escaping () -> Void) {
        self.presenter = presenter
        self.primaryAction = primaryAction
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
        additionalSafeAreaInsets = Constants.additionalInsets
        innerView.configure(with: presenter.viewModel)
        innerView.configureAction(target: self, selector: #selector(didPressContinue))
    }
    
    @objc private func didPressContinue() {
        primaryAction()
    }
}

private extension WelcomeViewController {
    enum Constants {
        static let additionalInsets = UIEdgeInsets(top: 26, left: 39, bottom: 20, right: 39)
    }
}
