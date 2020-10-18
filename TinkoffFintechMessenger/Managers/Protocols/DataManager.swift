//
//  DataManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 14.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol DataManager {
    
    func loadPersonData(completion: @escaping (PersonViewModel?) -> Void)
    func savePersonData(_ person: PersonViewModel, completion: ((Bool) -> Void)?)
    func getUserId(completion: @escaping ((String) -> Void))
}
