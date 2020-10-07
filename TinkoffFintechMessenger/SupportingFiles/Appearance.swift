//
//  Appearance.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 27.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class Appearance {
    
    // MARK: - Regular fonts
    
    static let font13 = UIFont.systemFont(ofSize: 13)
    static let font15 = UIFont.systemFont(ofSize: 15)
    
    // MARK: - Medium fonts
    
    static let mediumFont115 = UIFont.systemFont(ofSize: 115, weight: .medium)
    static let mediumFont15 = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let mediumFont13 = UIFont.systemFont(ofSize: 13, weight: .medium)
    
    // MARK: - Bold fonts
    
    static let boldFont13 = UIFont.systemFont(ofSize: 13, weight: .bold)
    static let boldFont24 = UIFont.systemFont(ofSize: 24, weight: .bold)
    
    // MARK: - Italic fonts
    
    static let italicFont13 = UIFont.italicSystemFont(ofSize: 13)
    
    // MARK: - Sizes
    
    static let baseCornerRadius: CGFloat = 14
    
    // MARK: - Colors
    
    static let yellow = UIColor(named: "Yellow")
    static let lightYellow = UIColor(named: "LightYellow")
    static let labelLight = UIColor(named: "LabelLight")
    static let darkGray = UIColor(named: "DarkGray")
    static let incomingMessageColor = UIColor(named: "IncomingMessage")
    static let outgoingMessageColor = UIColor(named: "OutgoingMessage")
    static let selectionColor = UIColor(named: "SelectionColor")
}
