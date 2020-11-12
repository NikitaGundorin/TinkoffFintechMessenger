//
//  BaseNavigationController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 04.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    // MARK: - UI
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        Appearance.statusBarStyle
    }
}
