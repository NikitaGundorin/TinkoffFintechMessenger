//
//  ConversationListTableViewCell.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 25.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ConversationListTableViewCell: UITableViewCell {

    // MARK: - UI
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.mediumFont15
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.font13
        label.textColor = Appearance.labelLight
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.font15
        label.textColor = Appearance.labelLight
        label.textAlignment = .right
        return label
    }()
    
    private let padding: CGFloat = 12
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundColor = nil
        messageLabel.font = Appearance.font13
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        let horizontalSV = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let verticalSV = UIStackView(arrangedSubviews: [horizontalSV, messageLabel])
        verticalSV.spacing = 1
        verticalSV.axis = .vertical
        verticalSV.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalSV)
        
        NSLayoutConstraint.activate([
            verticalSV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            verticalSV.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            verticalSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            verticalSV.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -padding),
        ])
    }
}

// MARK: - ConfigurableView

extension ConversationListTableViewCell: ConfigurableView {

    func configure(with model: ConversationCellModel) {
        nameLabel.text = model.name
        
        if model.date.isToday {
            dateLabel.text = model.date.formatted(with: "HH:mm")
        } else {
            dateLabel.text = model.date.formatted(with: "dd MMM")
        }
        
        if model.hasUnreadMessages {
            messageLabel.font = Appearance.boldFont13
        }
        
        if model.message.isEmpty {
            messageLabel.text = "No messages yet"
            messageLabel.font = Appearance.italicFont13
            dateLabel.text = nil
        } else {
            messageLabel.text = model.message
        }
        
        if model.isOnline {
            backgroundColor = Appearance.lightYellow
        }
    }
}
