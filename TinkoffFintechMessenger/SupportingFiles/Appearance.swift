//
//  Appearance.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 27.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class Appearance {
    
    // MARK: - Singleton
    
    static let shared = Appearance()
    private init() {}
    
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
    static let yellowLight = UIColor(named: "YellowLight")
    static let yellowDark = UIColor(named: "YellowDark")
    static let labelSecondary = UIColor(named: "LabelSecondary")
    static let darkGray = UIColor(named: "DarkGray")
    static let lightGray = UIColor(named: "LightGray")
    static let incomingMessageLightColor = UIColor(named: "IncomingMessageLight")
    static let incomingMessageDarkColor = UIColor(named: "IncomingMessageDark")
    static let outgoingMessageLightColor = UIColor(named: "OutgoingMessageLight")
    static let outgoingMessageDarkColor = UIColor(named: "OutgoingMessageDark")
    static let outgoingMessageDay = UIColor(named: "OutgoingMessageDay")
    static let selectionColor = UIColor(named: "Selection")
    static let navyColor = UIColor(named: "Navy")
    
    // MARK: - Icons
    
    static let settingsIcon = UIImage(named: "Settings")
    
    // MARK: - Theme
    
    var themes: [ThemeModel] = [
        .init(id: 0,
              name: "Classic",
              incomingMessageColor: incomingMessageLightColor,
              outgoingMessageColor: outgoingMessageLightColor,
              labelColor: .black,
              backgroundColor: .white,
              statusBarStyle: .default,
              grayColor: lightGray,
              yellowColor: yellowLight,
              uiUserInterfaceStyle: .light),
        .init(id: 1,
              name: "Day",
              incomingMessageColor: incomingMessageLightColor,
              outgoingMessageColor: outgoingMessageDay,
              labelColor: .black,
              backgroundColor: .white,
              statusBarStyle: .default,
              grayColor: lightGray,
              yellowColor: yellowLight,
              uiUserInterfaceStyle: .light),
        .init(id: 2,
              name: "Night",
              incomingMessageColor: incomingMessageDarkColor,
              outgoingMessageColor: outgoingMessageDarkColor,
              labelColor: .white,
              backgroundColor: .black,
              statusBarStyle: .lightContent,
              grayColor: darkGray,
              yellowColor: yellowDark,
              uiUserInterfaceStyle: .dark),
    ]
    
    private var currentThemeId: Int {
        get {
            UserDefaults.standard.integer(forKey: "CurrentTheme")
        }
        set {
            currentTheme = themes.first(where: { $0.id == newValue })
            DispatchQueue.global(qos: .utility).async {
                UserDefaults.standard.setValue(newValue, forKey: "CurrentTheme")
            }
        }
    }
    
    func setupTheme() {
        let theme = themes.first(where: { $0.isSelected }) ?? themes[0]
        UINavigationBar.appearance().tintColor = theme.labelColor
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: theme.labelColor ?? .black]
        UILabel.appearance().textColor = theme.labelColor
        UITableView.appearance().backgroundColor = theme.backgroundColor
        UIButton.appearance().tintColor = theme.labelColor
        if #available(iOS 13.0, *) {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            window.overrideUserInterfaceStyle = theme.uiUserInterfaceStyle
            window.subviews.forEach { view in
                view.removeFromSuperview()
                window.addSubview(view)
            }
        } else {
            let window = UIApplication.shared.keyWindow
            window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            window?.subviews.forEach { view in
                view.removeFromSuperview()
                window?.addSubview(view)
            }
        }
    }
    
    // weak здесь не обязателен, так как класс Appearance - singleton с приватным инициализатором,
    // во время жизни приложения будет существовать в единственном экземпляре
    // и данный блок не создаст утечек памяти
    lazy var themeSelectedCallback = { [weak self] (identifier: Int) in
        guard self?.themes.first(where: { $0.id == identifier && !$0.isSelected }) != nil else { return }
        
        self?.currentThemeId = identifier
        
        UIView.animate(withDuration: 0.3) {
            self?.setupTheme()
        }
    }
    
    // MARK: - Current theme
    
    private(set) lazy var currentTheme = themes.first(where: { $0.id == currentThemeId })
    
    static var yellowSecondaryColor: UIColor? {
        shared.currentTheme?.yellowColor
    }
    static var incomingMessageColor: UIColor? {
        shared.currentTheme?.incomingMessageColor
    }
    static var outgoingMessageColor: UIColor? {
        shared.currentTheme?.outgoingMessageColor
    }
    static var backgroundColor: UIColor? {
        shared.currentTheme?.backgroundColor
    }
    static var labelColor: UIColor? {
        shared.currentTheme?.labelColor
    }
    static var grayColor: UIColor? {
        shared.currentTheme?.grayColor
    }
}

// MARK: - ThemesPickerDelegate

extension Appearance: ThemesPickerDelegate {
    
    func themeSelected(width identifier: Int) {
        guard themes.first(where: { $0.id == identifier && !$0.isSelected }) != nil else { return }
        
        currentThemeId = identifier
        
        UIView.animate(withDuration: 0.3) {
            self.setupTheme()
        }
    }
}
