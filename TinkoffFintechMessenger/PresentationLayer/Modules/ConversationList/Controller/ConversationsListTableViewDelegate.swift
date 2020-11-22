//
//  ConversationsListTableViewDelegate.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ConversationsListTableViewDelegate: NSObject, UITableViewDelegate {
    
    // MARK: - Private properties
    
    private let rowHeight: CGFloat = 75
    private weak var viewController: ConversationsListViewController?
    
    // MARK: - Initializer
    
    init(viewController: ConversationsListViewController) {
        self.viewController = viewController
        super.init()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ConversationListTableViewHeader(frame: .zero)
        header.createChannelButtonAction = { [weak self] in
            guard let alertController =
                self?.viewController?.presentationAssembly?.createChannelAlertController(
                    title: "New Channel",
                    message: "Enter a channel's name")
                else { return }
            alertController.addTextField()
            alertController.addAction(.init(title: "Cancel", style: .cancel))
            
            alertController.submitAction = UIAlertAction(title: "Create", style: .default) { _ in
                guard let name = alertController.textFields?.first?.text else { return }
                
                self?.viewController?.dataProvider?.createChannel(withName: name) { channelId in
                    self?.presentConversationController(conversationName: name,
                                                        channelId: channelId)
                }
            }
            
            self?.viewController?.present(alertController, animated: true)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channel = viewController?.repository?.object(at: indexPath)
            else {
                tableView.deselectRow(at: indexPath, animated: true)
                return
        }
        presentConversationController(conversationName: channel.name,
                                      channelId: channel.identifier)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func presentConversationController(conversationName: String, channelId: String) {
        if let userId = viewController?.userId,
            let vc = viewController?.presentationAssembly?.conversationViewController(
                conversationModel: .init(name: conversationName,
                                         identifier: channelId),
                userId: userId) {
            viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
