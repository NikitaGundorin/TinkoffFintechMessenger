//
//  Person.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 24.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

struct Person {
    var firstName: String
    var secondName: String?
    var profileImage: UIImage?
    
    var initials: String {
        let firstLetter = firstName.prefix(1).capitalized
        let secondLetter = secondName?.prefix(1).capitalized ?? ""
    
        return "\(firstLetter)\(secondLetter)"
    }
    
    var fullName: String {
        if let secondName = self.secondName {
            return "\(firstName) \(secondName)"
        }
        return "\(firstName)"
    }
}
