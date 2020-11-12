//
//  UserViewModel.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 14.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

struct UserViewModel {
    var fullName: String
    var firstName: String? {
        fullName.components(separatedBy: .whitespacesAndNewlines).first
    }
    var secondName: String? {
        let words = fullName.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        return words.count > 1 ? words[1] : nil
    }
    var description: String?
    var profileImage: UIImage?
    
    var initials: String {
        let firstLetter = firstName?.prefix(1).capitalized ?? ""
        let secondLetter = secondName?.prefix(1).capitalized ?? ""
        
        return "\(firstLetter)\(secondLetter)"
    }
}
