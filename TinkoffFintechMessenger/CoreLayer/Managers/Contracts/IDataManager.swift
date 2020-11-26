//
//  DataManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 14.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol IDataManager {
    func loadUserData(completion: @escaping (User?) -> Void)
    func loadUserImage(imageFileName: String?, completion: (Data?) -> Void)
    func saveUserData(_ user: User, completion: (Bool) -> Void)
    func saveUserImage(imageData: Data?, completion: (String?) -> Void)
    func getUserId(completion: (String) -> Void)
}
