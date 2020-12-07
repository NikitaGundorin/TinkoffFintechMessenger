//
//  DataManagerMock.swift
//  MessengerTests
//
//  Created by Nikita Gundorin on 01.12.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

@testable import Messenger
import Foundation

class DataManagerMock: IDataManager {
    
    // MARK: - Public properties
    
    var userData: User?
    var userId = ""
    var userImageData: Data?
    var userDataSaved = false
    var userImageUrl: String?
    
    // MARK: - Methods calls count
    
    private(set) var loadUserDataCount = 0
    private(set) var loadUserImageCount = 0
    private(set) var saveUserImageCount = 0
    private(set) var saveUserDataCount = 0
    private(set) var getUserIdCount = 0
    
    // MARK: - Recieved params
    
    private(set) var recievedImageFileName: String?
    private(set) var recievedUser: User?
    private(set) var recievedImageData: Data?
    
    // MARK: - IDataManager
    
    func loadUserData(completion: @escaping (User?) -> Void) {
        loadUserDataCount += 1
        completion(userData)
    }
    
    func loadUserImage(imageFileName: String?, completion: (Data?) -> Void) {
        loadUserImageCount += 1
        recievedImageFileName = imageFileName
        completion(userImageData)
    }
    
    func saveUserData(_ user: User, completion: (Bool) -> Void) {
        saveUserDataCount += 1
        recievedUser = user
        completion(userDataSaved)
    }
    
    func saveUserImage(imageData: Data?, completion: (String?) -> Void) {
        saveUserImageCount += 1
        recievedImageData = imageData
        completion(userImageUrl)
    }
    
    func getUserId(completion: (String) -> Void) {
        getUserIdCount += 1
        completion(userId)
    }
}
