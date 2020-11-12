//
//  IThemeService.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 11.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol IThemeService {
    var themes: [Theme] { get }
    var currentTheme: Theme? { get }
    func setupTheme()
    func setCurrentTheme(id: Int)
}
