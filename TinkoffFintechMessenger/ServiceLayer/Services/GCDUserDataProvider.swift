//
//  GCDUserDataProvider.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 14.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class GCDUserDataProvider: IUserDataProvider {
    
    // MARK: - Public properties
    
    var dataManager: IDataManager
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    // MARK: - IUserDataProvider
    
    func loadUserData(completion: @escaping (UserViewModel?) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.dataManager.loadUserData { user in
                guard let user = user else {
                    return completion(nil)
                }
                
                self?.dataManager.loadUserImage(imageUrl: user.imageUrl) { data in
                    var image: UIImage?
                    if let data = data {
                        image = UIImage(data: data)
                    }
                    
                    completion(.init(fullName: user.fullName,
                                     description: user.description,
                                     profileImage: image))
                }
            }
        }
    }
    
    func saveUserData(_ userViewModel: UserViewModel, completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.dataManager.saveUserImage(imageData: userViewModel.profileImage?.pngData()) { url in
                let user = User(fullName: userViewModel.fullName,
                                description: userViewModel.description,
                                imageUrl: url)
                self?.dataManager.saveUserData(user) { dataSavedSuccessfully in
                    let imageSavedSuccessfully = url != nil || userViewModel.profileImage == nil
                    
                    completion?(dataSavedSuccessfully && imageSavedSuccessfully)
                }
            }
        }
    }
    
    func getUserId(completion: @escaping ((String) -> Void)) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.dataManager.getUserId(completion: completion)
        }
    }
}
