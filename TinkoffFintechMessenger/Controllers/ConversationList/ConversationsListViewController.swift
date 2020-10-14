//
//  ConversationsListViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 24.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

final class ConversationsListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let dataProvider: DataProvider = DummyDataProvider()
    private let rowHeight: CGFloat = 75
    private let baseCellId = "baseCellId"
    private lazy var items = dataProvider.getConversations()
    private lazy var sectionsModels: [ConversationListSectionModel] = []
    private var person: PersonViewModel? {
        didSet {
            if let person = self.person {
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.configure(with: person)
                }
            }
        }
    }
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ConversationListTableViewCell.self, forCellReuseIdentifier: baseCellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    private lazy var profileImageView = ProfileImageView()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
        tableView.reloadData()
    }
    
    func loadData() {
        let dataManager = GCDDataManager()
        //let dataManager = OperationDataManager()
        
        dataManager.loadPersonData { [weak self] person in
            self?.person = person
        }
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.title = "Tinkoff Chat"
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(presentProfileViewController)))
        let rightBarButtonView = UIView()
        rightBarButtonView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: rightBarButtonView.leadingAnchor),
            profileImageView.topAnchor.constraint(equalTo: rightBarButtonView.topAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: rightBarButtonView.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: rightBarButtonView.bottomAnchor, constant: -5)
        ])
        
        let rightBarButton = UIBarButtonItem(customView: rightBarButtonView)
        navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButtonItem = UIBarButtonItem(image: Appearance.settingsIcon, style: .plain, target: self, action: #selector(presentThemesViewController))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc private func presentProfileViewController() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() as? ProfileViewController {
            let nc = BaseNavigationController(rootViewController: vc)
            vc.profileDataUpdatedHandler = { [weak self] in
                self?.loadData()
            }

            present(nc, animated: true, completion: nil)
        }
    }
    
    @objc private func presentThemesViewController() {
        let vc = ThemesViewController()
        vc.themesPickerDelegate = Appearance.shared
        //vc.themeSelectedCallback = Appearance.shared.themeSelectedCallback
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updateData() {
        sectionsModels = [
            ConversationListSectionModel(sectionName: "Online",
                                         backgroundColor: Appearance.yellowSecondaryColor,
                                         items: items.filter { $0.isOnline }),
            ConversationListSectionModel(sectionName: "History",
                                         backgroundColor: nil,
                                         items: items.filter { !$0.isOnline && $0.message != "" }),
        ]
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsModels[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: baseCellId) as? ConversationListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: sectionsModels[indexPath.section].items[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ConversationListTableViewHeader(frame: .zero)
        header.configure(with: sectionsModels[section])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConversationViewController()
        vc.conversationName = items[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
