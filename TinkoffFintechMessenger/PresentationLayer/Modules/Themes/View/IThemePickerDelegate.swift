//
//  IThemePickerDelegate.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 02.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol IThemePickerDelegate: AnyObject {
    func themeSelected(width identifier: Int)
}
