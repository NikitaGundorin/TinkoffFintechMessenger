//
//  ThemesViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 02.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var themePickerDelegate: IThemePickerDelegate?
    var themeSelectedCallback: ((Int) -> Void)?
    
    // MARK: - UI
    
    private lazy var themePickers: [ThemePickerView] = {
        var pickers: [ThemePickerView] = []
        themes.forEach {
            let picker = ThemePickerView()
            picker.configure(with: $0)
            picker.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(themePickerPressed(sender:))))
            pickers.append(picker)
        }
        return pickers
    }()
    
    private let horizontalPadding: CGFloat = 35
    private let heightMultiplier: CGFloat = 0.6
    
    // MARK: - Private properties
    
    private var themes = Appearance.shared.themes
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        view.backgroundColor = Appearance.navyColor
        navigationItem.title = "Settings"
        
        let stackView = UIStackView(arrangedSubviews: themePickers)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: navigationController?.navigationBar.frame.height ?? 0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier)
        ])
    }
    
    @objc private func themePickerPressed(sender: UITapGestureRecognizer) {
        guard let themePicker = sender.view as? ThemePickerView,
              let id = themePicker.themeId else { return }
        
        if let delegate = themePickerDelegate {
            delegate.themeSelected(width: id)
        } else if let themeSelectedCallback = themeSelectedCallback {
            themeSelectedCallback(id)
        }
        
        themes.forEach {
            themePickers[$0.id].configure(with: $0)
        }
    }
}
