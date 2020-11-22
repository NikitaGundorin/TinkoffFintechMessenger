//
//  ICoreAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    func dataManager() -> IDataManager
    func networkManager() -> INetworkManager
    func coreDataManager() -> ICoreDataManager
    func logger(sourceName: String) -> ILogger
}
