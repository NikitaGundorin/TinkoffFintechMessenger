//
//  ConversationViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

final class ConversationViewController: UIViewController {
    
    // MARK: - Public properties
    
    var conversationName: String?
    var channelId: String?
    var dataProvider: DataProvider?
    
    // MARK: - Private properties
    
    private let messageCellId = "messageCellId"
    private var messages: [MessageCellModel] = []
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MessageCell.self, forCellReuseIdentifier: messageCellId)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        
        return tableView
    }()
    
    private lazy var sendMessageView: SendMessageView = {
        let view = SendMessageView()
        view.sendMessageAction = { [weak self] content in
            self?.dataProvider?.sendMessage(widthContent: content) {
                self?.scrollToBottom()
            }
        }
        return view
    }()
    private lazy var sendMessageViewBottomConstraint = sendMessageView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dataProvider?.unsubscribeChannel()
    }

    // MARK: - Private methods
    
    private func setupLayout() {
        view.backgroundColor = Appearance.backgroundColor
        view.addSubview(tableView)
        view.addSubview(sendMessageView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        sendMessageView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tableView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendMessageView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            sendMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendMessageViewBottomConstraint
        ])
        
        navigationItem.title = conversationName
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func loadData() {
        guard let channelId = channelId else { return }
        dataProvider?.subscribeMessages(forChannelWithId: channelId) { [weak self] messages, error in
            guard let messages = messages else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            self?.messages = messages
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }
    }
    
    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let row = messages.count - 1
        let indexPath = IndexPath(row: row, section: 0)
        tableView.scrollToRow(at: indexPath,
                                    at: .bottom,
                                    animated: true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            keyboardSize.height > 0 {
            
            sendMessageViewBottomConstraint.constant = -keyboardSize.height + view.safeAreaInsets.bottom
            
            UIView.animate(withDuration: Appearance.defaultAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {

        sendMessageViewBottomConstraint.constant = 0
        
        UIView.animate(withDuration: Appearance.defaultAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(false)
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: messageCellId) as? MessageCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: messages[indexPath.row])
        
        return cell
    }
}
