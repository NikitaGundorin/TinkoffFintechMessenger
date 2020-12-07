//
//  UserDataProviderMock.swift
//  MessengerTests
//
//  Created by Nikita Gundorin on 02.12.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

@testable import Messenger
import Foundation

class UserDataProviderMock: IUserDataProvider {
    
    // MARK: - Public properties
    
    var userModel: UserModel?
    var userDataSaved = false
    var userId = ""
    
    // MARK: - Methods calls count
    
    private(set) var loadUserDataCount = 0
    private(set) var saveUserDataCount = 0
    private(set) var getUserIdCount = 0
    
    // MARK: - Recieved props
    
    private(set) var recievedUserViewModel: UserModel?
    
    // MARK: - IUserDataProvider
    
    func loadUserData(completion: @escaping (UserModel?) -> Void) {
        loadUserDataCount += 1
        completion(userModel)
    }
    
    func saveUserData(_ userViewModel: UserModel, completion: ((Bool) -> Void)?) {
        saveUserDataCount += 1
        recievedUserViewModel = userViewModel
        completion?(userDataSaved)
    }
    
    func getUserId(completion: @escaping ((String) -> Void)) {
        getUserIdCount += 1
        completion(userId)
    }
}
