//
//  ConversationListTableViewHeader.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 25.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ConversationListTableViewHeader: UIView {
    
    // MARK: - Public properties
    
    var createChannelButtonAction: (() -> Void)?
    
    // MARK: - UI
    
    private lazy var createChannelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Channel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createChannelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let padding: CGFloat = 5
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        addSubview(createChannelButton)
        NSLayoutConstraint.activate([
            createChannelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createChannelButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: padding),
            createChannelButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            createChannelButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -padding),
            createChannelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    @objc private func createChannelButtonTapped() {
        if let createChannelButtonAction = createChannelButtonAction {
            createChannelButtonAction()
        }
    }
}
