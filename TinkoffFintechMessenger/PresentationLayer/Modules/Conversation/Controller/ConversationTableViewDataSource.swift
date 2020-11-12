//
//  ConversationTableViewDataSource.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ConversationTableViewDataSource: NSObject, UITableViewDataSource {
    
    var repository: IMessagesRepository?
    
    private var messages: [MessageModel]? {
        repository?.fetchedObjects()
    }
    private let cellId: String
    
    init(cellId: String) {
        self.cellId = cellId
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MessageCell,
            let message = repository?.object(at: indexPath) else {
                return UITableViewCell()
        }
        
        cell.configure(with: .init(content: message.content,
                                   isIncoming: message.isIncoming,
                                   senderName: message.senderName))
        
        return cell
    }
}
