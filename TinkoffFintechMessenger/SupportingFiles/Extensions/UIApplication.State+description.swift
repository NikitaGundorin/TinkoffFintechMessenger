//
//  UIApplication.State+description.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 14.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

extension UIApplication.State {
    
    var description: String {
        switch self {
        case .active:
            return "Active"
        case .background:
            return "Background"
        case .inactive:
            return "Inactive"
        @unknown default:
            return "Unknown state"
        }
    }
}
