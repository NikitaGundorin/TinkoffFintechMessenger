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
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dataProvider?.unsubscriveChannel()
    }

    // MARK: - Private methods
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.title = conversationName
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
        }
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
