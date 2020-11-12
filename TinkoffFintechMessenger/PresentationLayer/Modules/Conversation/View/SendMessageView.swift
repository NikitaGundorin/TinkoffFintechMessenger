//
//  SendMessageView.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 18.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class SendMessageView: UIView {
    
    // MARK: - UI
    
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = Appearance.font18
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tv.delegate = self
        tv.backgroundColor = Appearance.backgroundColor
        tv.textColor = Appearance.labelColor
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "SendMessage"), for: .normal)
        button.tintColor = Appearance.sendButtonColor
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let padding: CGFloat = 6
    private let defaultHeight: CGFloat = 33
    private let maxHeight: CGFloat = 200
    private lazy var textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: defaultHeight)
    
    private var sendMessageAction: ((String) -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    // MARK: - Lifecycle methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.layer.cornerRadius = Appearance.baseCornerRadius
        textView.layer.borderColor = Appearance.grayColor?.cgColor
        textView.layer.borderWidth = 1
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        backgroundColor = Appearance.backgroundColor
        addSubview(textView)
        addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            textViewHeightConstraint,
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            textView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            sendButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: padding),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),  
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor, multiplier: 1),
            sendButton.heightAnchor.constraint(equalToConstant: defaultHeight)
        ])
    }
    
    @objc private func sendMessage() {
        if let sendMessageAction = sendMessageAction,
            let text = textView.text {
            sendMessageAction(text)
            textView.text = nil
            textViewHeightConstraint.constant = defaultHeight
            sendButton.isEnabled = false
        }
    }
}

// MARK: - IConfigurableView

extension SendMessageView: IConfigurableView {
    func configure(with model: SendMessageModel) {
        sendMessageAction = model.sendMessageAction
    }
}

// MARK: - UITextViewDelegate

extension SendMessageView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = !(textView.text.isEmptyOrOnlyWhitespaces)
        let size = textView.sizeThatFits(.init(width: textView.bounds.width, height: maxHeight))
        if size.height > maxHeight {
            textViewHeightConstraint.constant = maxHeight
            textView.isScrollEnabled = true
        } else {
            textViewHeightConstraint.constant = size.height > defaultHeight ? size.height : defaultHeight
            textView.isScrollEnabled = false
        }
        textView.layoutIfNeeded()
    }
}
