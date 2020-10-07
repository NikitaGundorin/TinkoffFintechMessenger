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
    
    // MARK: - Private properties
    
    private let dataProvider: DataProvider = DummyDataProvider()
    private let messageCellId = "messageCellId"
    private lazy var messages = dataProvider.getMessages()
    
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
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.tintColor = .label
        } else {
            navigationController?.navigationBar.tintColor = .black
        }
        navigationItem.title = conversationName
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
