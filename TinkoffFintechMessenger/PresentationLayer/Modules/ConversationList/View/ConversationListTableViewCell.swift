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
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.font15
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
        
        messageLabel.font = Appearance.font13
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        let horizontalSV = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
            verticalSV.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -padding)
        ])
        
        let selectedBGView = UIView()
        selectedBGView.backgroundColor = Appearance.selectionColor
        selectedBackgroundView = selectedBGView
    }
}

// MARK: - ConfigurableView

extension ConversationListTableViewCell: IConfigurableView {
    
    func configure(with model: ConversationCellModel) {
        backgroundColor = Appearance.backgroundColor
        nameLabel.text = model.name
        
        if let data = model.lastActivity {
            if data.isToday {
                dateLabel.text = data.formatted(with: "HH:mm")
            } else {
                dateLabel.text = data.formatted(with: "dd MMM")
            }
        }
        
        if let message = model.lastMessage {
            messageLabel.text = message
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = Appearance.italicFont13
            dateLabel.text = nil
        }
        
        dateLabel.textColor = Appearance.labelSecondary
        messageLabel.textColor = Appearance.labelSecondary
        nameLabel.textColor = Appearance.labelColor
    }
}
