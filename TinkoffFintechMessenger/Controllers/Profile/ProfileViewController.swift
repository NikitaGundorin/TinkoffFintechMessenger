//
//  ProfileViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 13.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileImageEditButton: UIButton!
    @IBOutlet private weak var profileImageLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    // MARK: - Private properties
    
    private let loggerSourceName = "ProfileViewController"
    private var currentState = UIViewController.State.loading
    private let buttonCornerRadius: CGFloat = 14
    
    // MARK: - Initializer
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //Logger.info(loggerSourceName, "\(profileImageEditButton.frame)")
        //This throws an exception, because UI elements have not been loaded yet
    }
    
    // MARK: - UIViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newState = UIViewController.State.loaded
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
        
        Logger.info(loggerSourceName, "\(profileImageEditButton.frame)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let newState = UIViewController.State.appearing
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let newState = UIViewController.State.appeared
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
        
        Logger.info(loggerSourceName, "\(profileImageEditButton.frame)")
        
        //When the viewDidLoad is called constraints of view controller's view subviews
        //are not properly set and its sizes are not finalised
        //After the viewDidLayoutSubviews is called all sizes have already been calculated
        //and are actual
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Logger.info(loggerSourceName, #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Logger.info(loggerSourceName, #function)
        
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let newState = UIViewController.State.disappearing
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let newState = UIViewController.State.disappeared
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
    }
    
    // MARK: - IBActions
    
    @IBAction private func profileImageEditButtonPressed(_ sender: Any) {
        //set profile image
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        saveButton.layer.cornerRadius = buttonCornerRadius
        profileImageLabel.isHidden = profileImageView.image != nil
    }
}
