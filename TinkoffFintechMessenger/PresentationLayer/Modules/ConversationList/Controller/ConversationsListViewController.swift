//
//  ConversationsListViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 24.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import CoreData

final class ConversationsListViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presentationAssembly: IPresentationAssembly?
    var dataProvider: IConversationsDataProvider?
    var userDataProvider: IUserDataProvider?
    var repository: IChannelsRepository? {
        didSet {
            configureRepository()
        }
    }
    var logger: ILoggerService?
    
    // MARK: - Private properties
    
    private let baseCellId = "baseCellId"
    private var channels: [ChannelViewModel]? {
        repository?.fetchedObjects()
    }
    private var user: UserViewModel? {
        didSet {
            if let user = self.user {
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.configure(with: .init(initials: user.initials,
                                                                 image: user.profileImage))
                }
            }
        }
    }
    private var userId: String?
    private lazy var createChannel = { [weak self] in
        guard let alertController = self?.presentationAssembly?.createChannelAlertController(title: "New Channel",
                                                                                             message: "Enter a channel's name")
            else { return }
        alertController.addTextField()
        alertController.addAction(.init(title: "Cancel", style: .cancel))
        
        alertController.submitAction = UIAlertAction(title: "Create", style: .default) { _ in
            guard let name = alertController.textFields?.first?.text else { return }
            
            self?.dataProvider?.createChannel(withName: name, completion: { channelId in
                self?.presentConversationController(conversationName: name, channelId: channelId)
            })
        }
        
        self?.present(alertController, animated: true)
    }
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ConversationListTableViewCell.self, forCellReuseIdentifier: baseCellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    private lazy var profileImageView = ProfileImageView()
    private let rowHeight: CGFloat = 75
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserData()
        loadData()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.title = "Channels"
        
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
    
    private func loadData() {
        loadUserData()
        repository?.performFetch(completion: { [weak self] (error) in
            if let error = error {
                self?.logger?.error(error.localizedDescription)
                DispatchQueue.main.async {
                    AlertHelper().presentErrorAlert(vc: self,
                                                    message: "Failed to load channels")
                }
            }
        })
        
        dataProvider?.subscribeChannels { [weak self] error in
            if let error = error {
                return AlertHelper().presentErrorAlert(vc: self, message: error.localizedDescription)
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func loadUserData() {
        userDataProvider?.getUserId(completion: { [weak self] userId in
            self?.userId = userId
        })
        userDataProvider?.loadUserData { [weak self] userViewModel in
            guard let user = userViewModel else {
                DispatchQueue.main.async {
                    AlertHelper().presentErrorAlert(vc: self, message: "Failed to load user data")
                }
                return
            }
            self?.user = user
        }
    }
    
    private func configureRepository() {
        repository?.configure(
            willChangeContentCallback: { [weak self] in
                self?.tableView.beginUpdates()
            },
            didChangeContentCallback: { [weak self] in
                self?.tableView.endUpdates()
            },
            dataInsertedCallback: { [weak self] newIndexPath in
                if let newIndexPath = newIndexPath {
                    self?.tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            },
            dataMovedCallback: { [weak self] indexPath, newIndexPath in
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    self?.tableView.deleteRows(at: [indexPath], with: .top)
                    self?.tableView.insertRows(at: [newIndexPath], with: .top)
                }
            },
            dataUpdatedCallback: { [weak self] indexPath in
                if let indexPath = indexPath {
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            },
            dataDeletedCallback: { [weak self] indexPath in
                if let indexPath = indexPath {
                    self?.tableView.deleteRows(at: [indexPath], with: .left)
                }
        })
    }
    
    private func presentConversationController(conversationName: String, channelId: String) {
        if let userId = userId,
            let vc = presentationAssembly?.conversationViewController(conversationModel: .init(name: conversationName,
                                                                                               identifier: channelId),
                                                                      userId: userId) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func presentProfileViewController() {
        if let profileVC = presentationAssembly?.profileViewController(profileDataUpdatedHandler: { [weak self] in
            self?.loadUserData()
        }), let navigationController = presentationAssembly?.baseNavigationViewController(rootViewController: profileVC) {
            present(navigationController, animated: true)
        }
    }
    
    @objc private func presentThemesViewController() {
        if let vc = presentationAssembly?.themesViewController() {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: baseCellId) as? ConversationListTableViewCell,
            let channel = repository?.object(at: indexPath) else {
                return UITableViewCell()
        }
        
        cell.configure(with: .init(name: channel.name,
                                   lastActivity: channel.lastActivity,
                                   lastMessage: channel.lastMessage))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let identifier = channels?[indexPath.row].identifier {
            dataProvider?.deleteChannel(withId: identifier)
        }
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ConversationListTableViewHeader(frame: .zero)
        header.createChannelButtonAction = self.createChannel
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channel = repository?.object(at: indexPath) else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        presentConversationController(conversationName: channel.name,
                                      channelId: channel.identifier)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
