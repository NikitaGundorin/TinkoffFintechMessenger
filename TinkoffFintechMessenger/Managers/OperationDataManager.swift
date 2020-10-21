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
    
    func loadPersonData(completion: @escaping (PersonViewModel?) -> ()) {
        let operation = LoadPersonDataOperation(completion: completion)
        operationQueue.addOperation(operation)
    }
    
    func savePersonData(_ person: PersonViewModel, completion: ((Bool) -> ())? = nil) {
        let operation = SavePersonDataOperation(personViewModel: person, completion: completion)
        operationQueue.addOperation(operation)
    }
    
    // MARK: - Operation classes
    
    class LoadPersonDataOperation: Operation {
        var completion: (PersonViewModel?) -> ()
        
        init(completion: @escaping (PersonViewModel?) -> ()) {
            self.completion = completion
        }
        
        override func main() {
            guard !isCancelled,
                  let data = FileManager.read(fileName: Constants.personDataFileName),
                  let person = try? JSONDecoder().decode(Person.self, from: data)
            else { return completion(nil) }
            
            guard !isCancelled else { return completion(nil) }
            
            var image: UIImage? = nil
            if let profileImageUrl = person.imageUrl,
               let imageData = FileManager.read(url: profileImageUrl) {
                image = UIImage(data: imageData)
            }
            
            completion(.init(fullName: person.fullName, description: person.description, profileImage: image))
        }
    }
    
    class SavePersonDataOperation: Operation {
        
        private var personViewModel: PersonViewModel
        private var completion: ((Bool) -> ())?
        
        init(personViewModel: PersonViewModel, completion: ((Bool) -> ())? = nil) {
            self.personViewModel = personViewModel
            self.completion = completion
        }
        
        override func main() {
            var imageSavedSuccessfully = false
            var dataSavedSuccessfully = false
            
            var imageUrl: URL? = nil
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
}
