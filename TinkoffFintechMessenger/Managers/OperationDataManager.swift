//
//  OperationDataManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 14.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class OperationDataManager: DataManager {
    
    // MARK: - Private properties
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        return queue
    }()
    
    // MARK: - DataManager methods
    
    func loadPersonData(completion: @escaping (PersonViewModel?) -> Void) {
        let operation = LoadPersonDataOperation(completion: completion)
        operationQueue.addOperation(operation)
    }
    
    func savePersonData(_ person: PersonViewModel, completion: ((Bool) -> Void)? = nil) {
        let operation = SavePersonDataOperation(personViewModel: person, completion: completion)
        operationQueue.addOperation(operation)
    }
    
    func getUserId(completion: @escaping ((String) -> Void)) {
        let operation = GetUserIdOperation(completion: completion)
        operationQueue.addOperation(operation)
    }
    
    // MARK: - Operation classes
    
    class LoadPersonDataOperation: Operation {
        private let completion: (PersonViewModel?) -> Void
        
        init(completion: @escaping (PersonViewModel?) -> Void) {
            self.completion = completion
        }
        
        override func main() {
            guard !isCancelled,
                  let data = FileManager.read(fileName: Constants.personDataFileName),
                  let person = try? JSONDecoder().decode(Person.self, from: data)
            else { return completion(nil) }
            
            guard !isCancelled else { return completion(nil) }
            
            var image: UIImage?
            if let profileImageUrl = person.imageUrl,
               let imageData = FileManager.read(url: profileImageUrl) {
                image = UIImage(data: imageData)
            }
            
            completion(.init(fullName: person.fullName, description: person.description, profileImage: image))
        }
    }
    
    class SavePersonDataOperation: Operation {
        
        private let personViewModel: PersonViewModel
        private let completion: ((Bool) -> Void)?
        
        init(personViewModel: PersonViewModel, completion: ((Bool) -> Void)? = nil) {
            self.personViewModel = personViewModel
            self.completion = completion
        }
        
        override func main() {
            var imageSavedSuccessfully = false
            var dataSavedSuccessfully = false
            
            var imageUrl: URL?
            if let imageData = personViewModel.profileImage?.pngData() {
                (imageSavedSuccessfully, imageUrl) =
                    FileManager.write(data: imageData, fileName: Constants.personImageFileName)
            } else if personViewModel.profileImage == nil {
                imageSavedSuccessfully = true
            }
            
            let person = Person(fullName: personViewModel.fullName, description: personViewModel.description, imageUrl: imageUrl)
            
            if let data = try? JSONEncoder().encode(person),
               FileManager.write(data: data, fileName: Constants.personDataFileName).isSuccessful {
                dataSavedSuccessfully = true
            }
            
            if let completion = completion {
                completion(imageSavedSuccessfully && dataSavedSuccessfully)
            }
        }
    }
    
    class GetUserIdOperation: Operation {
        private let completion: (String) -> Void
        private let userIdKey = "UserId"
        private let userDefaults = UserDefaults.standard
        
        init(completion: @escaping (String) -> Void) {
            self.completion = completion
        }
        
        override func main() {
            if let userId = userDefaults.string(forKey: userIdKey) {
                completion(userId)
            } else {
                let userId = UUID().uuidString
                userDefaults.set(userId, forKey: userIdKey)
                completion(userId)
            }
        }
    }
}
