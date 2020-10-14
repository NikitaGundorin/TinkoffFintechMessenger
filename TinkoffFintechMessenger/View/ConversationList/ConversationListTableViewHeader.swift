//
//  ConversationListTableViewHeader.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 25.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ConversationListTableViewHeader: UIView {
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.boldFont24
        label.textColor = Appearance.labelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let horizontalPadding: CGFloat = 20
    private let vertivalPadding: CGFloat = 10
    
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
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                            constant: vertivalPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,
                                                 constant: -horizontalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -vertivalPadding)
        ])
        backgroundColor = Appearance.backgroundColor
    }
}

// MARK: - ConfigurableView

extension ConversationListTableViewHeader: ConfigurableView {

    func configure(with model: ConversationListSectionModel) {
        titleLabel.text = model.sectionName
        if let bgColor = model.backgroundColor {
            backgroundColor = bgColor
        } else {
            backgroundColor = Appearance.backgroundColor
        }
    }
}
