//
//  ConversationsListTableViewDataSource.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ConversationsListTableViewDataSource: NSObject, UITableViewDataSource {
    
    var dataProvider: IConversationsDataProvider?
    var repository: IChannelsRepository?
    let cellId: String
    
    private var channels: [ChannelModel]? {
        repository?.fetchedObjects()
    }
    
    init(cellId: String) {
        self.cellId = cellId
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ConversationListTableViewCell,
            let channel = repository?.object(at: indexPath) else {
                return UITableViewCell()
        }
        
        cell.configure(with: .init(name: channel.name,
                                   lastActivity: channel.lastActivity,
                                   lastMessage: channel.lastMessage))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
            let identifier = channels?[indexPath.row].identifier {
            dataProvider?.deleteChannel(withId: identifier)
        }
    }
}
