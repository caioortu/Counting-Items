//
//  AddCounterView.swift
//  Counters
//
//  Created by Caio Ortu on 4/5/21.
//

import UIKit

final class AddCounterView: UIView {
    // MARK: - Properties
    
    private let containerView = UIView()
    let textField = UITextField()
    let activityIndicator = UIActivityIndicatorView()
    let stackView = UIStackView()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Implementation

private extension AddCounterView {
    func setup() {
        backgroundColor = .background
        
        setupContainerView()
        setupStackView()
        setupTextField()
        setupActivityIndicator()
        setupViewHierarchy()
        setupConstraints()
    }
    
    func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
    }
    
    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
    }
    
    func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .body)
    }
    
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.hidesWhenStopped = true
    }
    
    func setupViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(activityIndicator)
    }
    
    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // container view
            containerView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 25),
            containerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -15),
            containerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 15),
            
            // stack view
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18)
        ])
    }
}
