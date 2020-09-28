//
//  MessageCell.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    // MARK: - UI
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerMessageView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var incomingMessageConstraint =
        containerMessageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
    private lazy var outgoingMessageConstraint =
        containerMessageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
    private let widthMultiplier: CGFloat = 0.75
    private let padding: CGFloat = 10
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        addSubview(containerMessageView)
        containerMessageView.addSubview(messageLabel)
        containerMessageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerMessageView.topAnchor.constraint(equalTo: topAnchor,
                                                      constant: padding / 2),
            containerMessageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                         constant: -padding / 2),
            containerMessageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor,
                                                        multiplier: widthMultiplier),
            messageLabel.leadingAnchor.constraint(equalTo: containerMessageView.leadingAnchor,
                                                  constant: padding),
            messageLabel.topAnchor.constraint(equalTo: containerMessageView.topAnchor,
                                              constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerMessageView.trailingAnchor,
                                              constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: containerMessageView.bottomAnchor,
                                              constant: -padding)
        ])
        containerMessageView.layer.cornerRadius = Appearance.baseCornerRadius
    }
}

// MARK: - ConfigurableView

extension MessageCell: ConfigurableView {

    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        
        if (model.isIncoming) {
            containerMessageView.backgroundColor = Appearance.incomingMessageColor
            messageLabel.textAlignment = .left
            outgoingMessageConstraint.isActive = false
            incomingMessageConstraint.isActive = true
        } else {
            containerMessageView.backgroundColor = Appearance.outgoingMessageColor
            messageLabel.textAlignment = .right
            incomingMessageConstraint.isActive = false
            outgoingMessageConstraint.isActive = true
        }
    }
}
