//
//  ConversationsListViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 24.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

final class ConversationsListViewController: UITableViewController {
    
    // MARK: - Private properties
    
    private let baseCellId = "baseCellId"
    private let dataProvider: DataProvider = DummyDataProvider()
    private lazy var items = dataProvider.getConversations()
    private lazy var sectionsModels = [
        ConversationListSectionModel(sectionName: "Online", backgroundColor: Appearance.lightYellow, items: items.filter { $0.isOnline }),
        ConversationListSectionModel(sectionName: "History", backgroundColor: nil, items: items.filter { !$0.isOnline && $0.message != "" }),
    ]
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupTableView()
    }
    
    // MARK: - UITableView methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsModels.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ConversationListTableViewHeader(frame: .zero)
        header.configure(with: sectionsModels[section])
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionsModels[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: baseCellId) as? ConversationListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: sectionsModels[indexPath.section].items[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        navigationItem.title = "Tinkoff Chat"
        
        let profileImageView = ProfileImageView()
        profileImageView.configure(with: dataProvider.getUser())
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(presentProfileViewController)))
        let rightBarButtonView = UIView()
        rightBarButtonView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: rightBarButtonView.leadingAnchor),
            profileImageView.topAnchor.constraint(equalTo: rightBarButtonView.topAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: rightBarButtonView.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: rightBarButtonView.bottomAnchor, constant: -5)
        ])
        let rightBarButton = UIBarButtonItem(customView: rightBarButtonView)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupTableView() {
        tableView.register(ConversationListTableViewCell.self, forCellReuseIdentifier: baseCellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    @objc private func presentProfileViewController() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            present(vc, animated: true, completion: nil)
        }
    }
}
