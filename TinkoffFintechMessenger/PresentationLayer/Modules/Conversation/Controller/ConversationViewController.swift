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
    
    var conversationName: String?
    var channelId: String?
    var dataProvider: IConversationsDataProvider?
    var userId: String?
    
    // MARK: - Private properties
    private let messageCellId = "messageCellId"
    private var messages: [Message_db]? {
        fetchedResultsController.fetchedObjects
    }
    private lazy var fetchedResultsController: NSFetchedResultsController<Message_db> = {
        let fetchRequest: NSFetchRequest<Message_db> = Message_db.fetchRequest()
        fetchRequest.sortDescriptors = [.init(key: "created", ascending: true)]
        fetchRequest.predicate = .init(format: "channel.identifier == %@", channelId ?? "")
        fetchRequest.resultType = .managedObjectResultType
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataManager.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    private let loggerSourceName = "ConversationViewController"
    
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
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Logger.error(loggerSourceName, error.localizedDescription)
        }
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
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: messageCellId) as? MessageCell,
            let userId = userId,
            let message = MessageCellModel(message: fetchedResultsController.object(at: indexPath), userId: userId) else {
            return UITableViewCell()
        }
        
        cell.configure(with: message)
        
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
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
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            Logger.info(loggerSourceName, "\(#function) - type: update")
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        case .delete:
            Logger.info(loggerSourceName, "\(#function) - type: delete")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            Logger.info(loggerSourceName, "Unknown case statement")
        }
    }
}
