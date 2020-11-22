//
//  CoreAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class CoreAssembly: ICoreAssembly {
    
    // MARK: - ICoreAssembly
    
    func networkManager() -> INetworkManager {
        return FirestoreNetworkManager()
    }
    
    func dataManager() -> IDataManager {
        return DataManager()
    }
    
    func coreDataManager() -> ICoreDataManager {
        CoreDataManager.shared.logger = logger(sourceName: "CoreDataManager")
        return CoreDataManager.shared
    }
    
    func logger(sourceName: String) -> ILogger {
        Logger(sourceName: sourceName)
    }
}
