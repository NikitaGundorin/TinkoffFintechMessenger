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
    
    private lazy var senderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Appearance.labelColor
        label.font = Appearance.boldFont13
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Appearance.labelColor
        return label
    }()
    
    private lazy var containerMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        containerMessageView.addSubview(senderNameLabel)
        containerMessageView.addSubview(messageLabel)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            containerMessageView.topAnchor.constraint(equalTo: topAnchor,
                                                      constant: padding / 2),
            containerMessageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                         constant: -padding / 2),
            containerMessageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor,
                                                        multiplier: widthMultiplier),
            senderNameLabel.leadingAnchor.constraint(equalTo: containerMessageView.leadingAnchor,
                                                     constant: padding),
            senderNameLabel.topAnchor.constraint(equalTo: containerMessageView.topAnchor,
                                                 constant: padding),
            senderNameLabel.trailingAnchor.constraint(equalTo: containerMessageView.trailingAnchor,
                                                      constant: -padding),
            messageLabel.leadingAnchor.constraint(equalTo: containerMessageView.leadingAnchor,
                                                  constant: padding),
            messageLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor,
                                              constant: padding / 2),
            messageLabel.trailingAnchor.constraint(equalTo: containerMessageView.trailingAnchor,
                                              constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: containerMessageView.bottomAnchor,
                                              constant: -padding)
        ])
        containerMessageView.layer.cornerRadius = Appearance.baseCornerRadius
        backgroundColor = nil
    }
}

// MARK: - ConfigurableView

extension MessageCell: ConfigurableView {

    func configure(with model: MessageCellModel) {
        messageLabel.text = model.content
        
        if model.isIncoming {
            containerMessageView.backgroundColor = Appearance.incomingMessageColor
            messageLabel.textAlignment = .left
            senderNameLabel.text = model.senderName
            outgoingMessageConstraint.isActive = false
            incomingMessageConstraint.isActive = true
        } else {
            containerMessageView.backgroundColor = Appearance.outgoingMessageColor
            messageLabel.textAlignment = .right
            senderNameLabel.text = nil
            incomingMessageConstraint.isActive = false
            outgoingMessageConstraint.isActive = true
        }
    }
}
