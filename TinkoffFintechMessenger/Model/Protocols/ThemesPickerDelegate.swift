//
//  ThemesPickerDelegate.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 02.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

protocol ThemesPickerDelegate: AnyObject {
    
    func themeSelected(width identifier: Int)
}
