//
//  OperationUserDataProvider.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 14.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class OperationUserDataProvider: IUserDataProvider {
    
    let dataManager: IDataManager
    
    // MARK: - Private properties
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        return queue
    }()
    
    // MARK: - Initializer
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    // MARK: - DataManager methods
    
    func loadUserData(completion: @escaping (UserViewModel?) -> Void) {
        let operation = LoadUserDataOperation(dataManager: dataManager, completion: completion)
        operationQueue.addOperation(operation)
    }
    
    func saveUserData(_ userViewModel: UserViewModel, completion: ((Bool) -> Void)? = nil) {
        let operation = SaveUserDataOperation(dataManager: dataManager,
                                                userViewModel: userViewModel,
                                                completion: completion)
        operationQueue.addOperation(operation)
    }
    
    func getUserId(completion: @escaping ((String) -> Void)) {
        let operation = GetUserIdOperation(dataManager: dataManager, completion: completion)
        operationQueue.addOperation(operation)
    }
    
    // MARK: - Operation classes
    
    class LoadUserDataOperation: Operation {
        private let dataManager: IDataManager
        private let completion: (UserViewModel?) -> Void
        
        init(dataManager: IDataManager, completion: @escaping (UserViewModel?) -> Void) {
            self.dataManager = dataManager
            self.completion = completion
        }
        
        override func main() {
            guard !isCancelled else { return }
            
            dataManager.loadUserData { [weak self] user in
                guard self?.isCancelled != true,
                    let user = user else {
                        self?.completion(nil)
                        return
                }
                
                self?.dataManager.loadUserImage(imageUrl: user.imageUrl) { data in
                    guard self?.isCancelled != true else { return }
                    
                    var image: UIImage?
                    if let data = data {
                        image = UIImage(data: data)
                    }
                    
                    self?.completion(.init(fullName: user.fullName,
                                           description: user.description,
                                           profileImage: image))
                }
            }
        }
    }
    
    class SaveUserDataOperation: Operation {
        private let dataManager: IDataManager
        private let userViewModel: UserViewModel
        private let completion: ((Bool) -> Void)?
        
        init(dataManager: IDataManager,
             userViewModel: UserViewModel,
             completion: ((Bool) -> Void)? = nil) {
            self.dataManager = dataManager
            self.userViewModel = userViewModel
            self.completion = completion
        }
        
        override func main() {
            guard !isCancelled else { return }
            dataManager.saveUserImage(imageData: userViewModel.profileImage?.pngData()) { url in
                guard !isCancelled else { return }
                let user = User(fullName: userViewModel.fullName,
                                  description: userViewModel.description,
                                  imageUrl: url)
                dataManager.saveUserData(user) { dataSavedSuccessfully in
                    guard !isCancelled else { return }
                    let imageSavedSuccessfully = url != nil || userViewModel.profileImage == nil
                    
                    completion?(dataSavedSuccessfully && imageSavedSuccessfully)
                }
            }
        }
    }
    
    class GetUserIdOperation: Operation {
        private let dataManager: IDataManager
        private let completion: (String) -> Void
        
        init(dataManager: IDataManager, completion: @escaping (String) -> Void) {
            self.dataManager = dataManager
            self.completion = completion
        }
        
        override func main() {
            guard !isCancelled else { return }
            dataManager.getUserId(completion: completion)
        }
    }
}
