//
//  ServicesAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class ServicesAssembly: IServicesAssembly {
    
    var coreAssembly: ICoreAssembly
    
    // MARK: - Initializer
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    func conversationsDataProvider() -> IConversationsDataProvider {
        let dataProvider = FirestoreDataProvider()
        dataProvider.networkManager = coreAssembly.networkManager()
        dataProvider.userDataProvider = gcdUserDataProvider()
        return dataProvider
    }
    
    func gcdUserDataProvider() -> IUserDataProvider {
        return GCDUserDataProvider(dataManager: coreAssembly.dataManager())
    }
    
    func operationUserDataProvider() -> IUserDataProvider {
        return OperationUserDataProvider(dataManager: coreAssembly.dataManager())
    }
}
