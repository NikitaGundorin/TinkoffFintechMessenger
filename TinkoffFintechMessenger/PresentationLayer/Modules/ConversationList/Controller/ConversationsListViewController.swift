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
    
    // MARK: - Private properties

    private let baseCellId = "baseCellId"
    private var channels: [Channel_db]? {
        fetchedResultsController.fetchedObjects
    }
    private var user: UserViewModel? {
        didSet {
            if let user = self.user {
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.configure(with: user)
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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Channel_db> = {
        let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        fetchRequest.sortDescriptors = [.init(key: "lastActivity", ascending: false),
                                        .init(key: "name", ascending: true)]
        fetchRequest.resultType = .managedObjectResultType
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataManager.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
    private let loggerSourceName = "ConversationsListViewController"
    
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
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Logger.error(loggerSourceName, error.localizedDescription)
        }
        
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
    
    private func presentConversationController(conversationName: String, channelId: String) {
        if let userId = userId,
            let vc = presentationAssembly?.conversationViewController(conversationName: conversationName,
                                                                  channelId: channelId,
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
            let channel = Channel(channel: fetchedResultsController.object(at: indexPath)) else {
            return UITableViewCell()
        }
        
        cell.configure(with: channel)
        
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
        guard let channel = Channel(channel: fetchedResultsController.object(at: indexPath)) else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        presentConversationController(conversationName: channel.name,
                                      channelId: channel.identifier)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Logger.info(loggerSourceName, #function)
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Logger.info(loggerSourceName, #function)
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            Logger.info(loggerSourceName, "\(#function) - type: insert")
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            Logger.info(loggerSourceName, "\(#function) - type: move")
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .top)
                tableView.insertRows(at: [newIndexPath], with: .top)
            }
        case .update:
            Logger.info(loggerSourceName, "\(#function) - type: update")
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            Logger.info(loggerSourceName, "\(#function) - type: delete")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        @unknown default:
            Logger.info(loggerSourceName, "Unknown case statement")
        }
    }
}
