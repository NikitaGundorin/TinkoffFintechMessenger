//
//  ThemeModel.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

struct ThemeModel {
    let name: String?
    let isSelected: Bool
    let id: Int
    let incomingMessageColor: UIColor?
    let outgoingMessageColor: UIColor?
    let backgroundColor: UIColor?
    
    init(theme: Theme, selectedThemeId: Int?) {
        self.name = theme.name
        self.isSelected = theme.id == selectedThemeId
        self.id = theme.id
        self.incomingMessageColor = theme.incomingMessageColor
        self.outgoingMessageColor = theme.outgoingMessageColor
        self.backgroundColor = theme.backgroundColor
    }
}
