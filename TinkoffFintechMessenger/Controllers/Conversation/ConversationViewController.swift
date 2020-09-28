//
//  ConversationViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

final class ConversationViewController: UITableViewController {
    
    // MARK: - Public properties
    
    var conversationName: String?
    
    // MARK: - Private properties
    
    private let dataProvider: DataProvider = DummyDataProvider()
    private let messageCellId = "messageCellId"
    private lazy var messages = dataProvider.getMessages()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
    }
    
    // MARK: - UITableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: messageCellId) as? MessageCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: messages[indexPath.row])
        
        return cell
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.register(MessageCell.self, forCellReuseIdentifier: messageCellId)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    private func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.tintColor = .label
        } else {
            navigationController?.navigationBar.tintColor = .black
        }
        navigationItem.title = conversationName
    }
}
