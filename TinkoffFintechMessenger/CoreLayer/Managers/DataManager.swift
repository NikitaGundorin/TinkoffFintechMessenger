//
//  DataManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 08.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class DataManager: IDataManager {
    
    // MARK: - IDataManager
    
    func loadUserData(completion: @escaping (User?) -> Void) {
        guard let data = FileManager.read(fileName: Constants.userDataFileName),
            let user = try? JSONDecoder().decode(User.self, from: data)
            else {
                authorizeUser(completion: completion)
                return
        }
        completion(user)
    }
    
    func loadUserImage(imageFileName: String?, completion: (Data?) -> Void) {
        if let imageFileName = imageFileName,
            let imageData = FileManager.read(fileName: imageFileName) {
            completion(imageData)
        } else {
            completion(nil)
        }
    }
    
    func saveUserData(_ user: User, completion: (Bool) -> Void) {
        if let data = try? JSONEncoder().encode(user),
            FileManager.write(data: data, fileName: Constants.userDataFileName) {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func saveUserImage(imageData: Data?, completion: (String?) -> Void) {
        guard let imageData = imageData,
            FileManager.write(data: imageData,
                              fileName: Constants.userImageFileName) else { return completion(nil) }
        completion(Constants.userImageFileName)
    }
    
    func getUserId(completion: (String) -> Void) {
        let userIdKey = "UserId"
        let userDefaults = UserDefaults.standard
        
        if let userId = userDefaults.string(forKey: userIdKey) {
            completion(userId)
        } else {
            let userId = UUID().uuidString
            userDefaults.set(userId, forKey: userIdKey)
            completion(userId)
        }
    }
    
    // MARK: - Private function
    
    private func authorizeUser(completion: @escaping (User?) -> Void) {
        // authorization should be here
        let user = getDefaultUserData()
        saveUserData(user) { isSuccess in
            if isSuccess {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    private func getDefaultUserData() -> User {
        return .init(fullName: "Nikita Gundorin",
                     description: "iOS developer\nSaint-Petersburg",
                     imageFileName: nil)
    }
}
