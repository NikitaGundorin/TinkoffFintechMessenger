//
//  IUserDataProvider.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 08.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol IUserDataProvider {
    func loadUserData(completion: @escaping (UserViewModel?) -> Void)
    func saveUserData(_ userViewModel: UserViewModel, completion: ((Bool) -> Void)?)
    func getUserId(completion: @escaping ((String) -> Void))
}
