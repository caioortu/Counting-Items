//
//  ErrorView.swift
//  Counters
//
//  Created by Caio Ortu on 4/2/21.
//

import UIKit

final class ErrorView: UIView {
    private let stackView = UIStackView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let button = Button()
    
    private var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(title: String?, message: String?, actionTitle: String?, action: (() -> Void)?, animated: Bool) {
        let duration = animated ? 0.25 : 0.0
        
        if let message = message {
            titleLabel.text = title
            messageLabel.text = message
            button.isHidden = actionTitle == nil
            button.setTitle(actionTitle, for: .normal)
            self.action = action
            
            UIView.animate(withDuration: duration) {
                self.isHidden = false
            }
        } else {
            UIView.animate(withDuration: duration) {
                self.isHidden = true
            } completion: { completed in
                if completed {
                    self.hide()
                }
            }
        }
    }
    
    private func hide() {
        titleLabel.text = nil
        messageLabel.text = nil
        button.setTitle(nil, for: .normal)
        action = nil
        isHidden = true
    }
    
    @objc private func buttonTouchUpInside() {
        action?()
    }
}
 
private extension ErrorView {
    func setup() {
        isHidden = true
        setupStackView()
        setupTitleLabel()
        setupMessageLabel()
        setupButton()
        setupHierarchy()
        setupConstraint()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = .primaryText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    
    func setupMessageLabel() {
        messageLabel.textColor = .secondaryText
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.adjustsFontForContentSizeCategory = true
    }
    
    func setupButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
    }
    
    func setupHierarchy() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(button)
    }
    
    func setupConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // stack view
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // button
            button.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}
