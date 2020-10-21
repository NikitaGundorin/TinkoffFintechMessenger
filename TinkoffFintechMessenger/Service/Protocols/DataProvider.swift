//
//  DataProvider.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol DataProvider {
    func getConversations() -> [ConversationCellModel]
    func getMessages() -> [MessageCellModel]
}
