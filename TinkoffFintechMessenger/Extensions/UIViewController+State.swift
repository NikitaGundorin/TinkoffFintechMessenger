//
//  UIViewController+State.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 15.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum State: String {
        case loading = "Loading"
        case loaded = "Loaded"
        case appearing = "Appearing"
        case appeared = "Appeared"
        case disappearing = "Disappearing"
        case disappeared = "Disappeared"
    }
}
