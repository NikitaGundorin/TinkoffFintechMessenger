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
    var dataProvider: IConversationsDataProvider? {
        didSet {
            tableViewDataSource.dataProvider = dataProvider
        }
    }
    var userDataProvider: IUserDataProvider?
    var repository: IChannelsRepository? {
        didSet {
            configureRepository()
            tableViewDataSource.repository = repository
        }
    }
    var logger: ILoggerService?
    
    // MARK: - Private properties
    
    private let cellId = "cellId"

    private var user: UserModel? {
        didSet {
            if let user = self.user {
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.configure(with: .init(initials: user.initials,
                                                                 image: user.profileImage))
                }
            }
        }
    }
    var userId: String?
    private lazy var tableViewDelegate = ConversationsListTableViewDelegate(viewController: self)
    private lazy var tableViewDataSource = ConversationsListTableViewDataSource(cellId: cellId)
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ConversationListTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDataSource
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    private lazy var profileImageView = ProfileImageView()
    
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
            profileImageView.bottomAnchor.constraint(equalTo: rightBarButtonView.bottomAnchor,
                                                     constant: -5)
        ])
        
        let rightBarButton = UIBarButtonItem(customView: rightBarButtonView)
        navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButtonItem = UIBarButtonItem(image: Appearance.settingsIcon,
                                                style: .plain,
                                                target: self,
                                                action: #selector(presentThemesViewController))
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
    
    @objc private func presentProfileViewController() {
        if let profileVC =
            presentationAssembly?.profileViewController(profileDataUpdatedHandler: { [weak self] in
                self?.loadUserData()
            }),
            let navigationController = presentationAssembly?.baseNavigationViewController(rootViewController: profileVC) {
            present(navigationController, animated: true)
        }
    }
    
    @objc private func presentThemesViewController() {
        if let vc = presentationAssembly?.themesViewController() {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
