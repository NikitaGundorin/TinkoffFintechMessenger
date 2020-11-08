//
//  CoreAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class CoreAssembly: ICoreAssembly {
    func networkManager() -> INetworkManager {
        return FirestoreNetworkManager()
    }
    
    func dataManager() -> IDataManager {
        return DataManager()
    }
}
