//
//  ConversationViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import CoreData

final class ConversationViewController: UIViewController {
    
    // MARK: - Public properties
    
    var model: ConversationModel?
    var dataProvider: IConversationsDataProvider?
    var repository: IMessagesRepository? {
        didSet {
            configureRepository()
            tableViewDataSource.repository = repository
        }
    }
    var logger: ILoggerService?
    
    // MARK: - Private properties
    
    private let messageCellId = "messageCellId"
    private var messages: [MessageModel]? {
        repository?.fetchedObjects()
    }
    
    private lazy var tableViewDataSource = ConversationTableViewDataSource(cellId: messageCellId)
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MessageCell.self, forCellReuseIdentifier: messageCellId)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = tableViewDataSource
        
        return tableView
    }()
    
    private lazy var sendMessageView: SendMessageView = {
        let view = SendMessageView()
        view.configure(with: .init(sendMessageAction: { [weak self] content in
            self?.dataProvider?.sendMessage(widthContent: content) {
                self?.scrollToBottom()
            }
        }))
        return view
    }()
    
    private lazy var sendMessageViewBottomConstraint =
        sendMessageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
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
        
        navigationItem.title = model?.name
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func loadData() {
        guard let channelId = model?.identifier
            else { return }
        repository?.performFetch(completion: { [weak self] error in
            if let error = error {
                self?.logger?.error(error.localizedDescription)
                DispatchQueue.main.async {
                    AlertHelper().presentErrorAlert(vc: self,
                                                    message: "Failed to load messages")
                }
            }
        })
        dataProvider?.subscribeMessages(forChannelWithId: channelId) { [weak self] error in
            if let error = error {
                return AlertHelper().presentErrorAlert(vc: self, message: error.localizedDescription)
            }
            
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }
    }
    
    private func scrollToBottom() {
        guard let messages = messages,
            messages.count > 0 else { return }
        let row = messages.count - 1
        let indexPath = IndexPath(row: row, section: 0)
        tableView.scrollToRow(at: indexPath,
                              at: .bottom,
                              animated: true)
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
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
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
