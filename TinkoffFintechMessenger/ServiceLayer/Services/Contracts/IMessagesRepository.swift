//
//  IMessagesRepository.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol IMessagesRepository {
    func configure(willChangeContentCallback: (() -> Void)?,
                   didChangeContentCallback: (() -> Void)?,
                   dataInsertedCallback: ((IndexPath?) -> Void)?,
                   dataMovedCallback: ((IndexPath?, IndexPath?) -> Void)?,
                   dataUpdatedCallback: ((IndexPath?) -> Void)?,
                   dataDeletedCallback: ((IndexPath?) -> Void)?)
    
    func performFetch(completion: (Error?) -> Void)
    
    func object(at indexPath: IndexPath) -> MessageViewModel?
    func fetchedObjects() -> [MessageViewModel]?
}
