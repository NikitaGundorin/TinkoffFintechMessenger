//
//  ViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 13.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let loggerSourceName = "ViewController"
    private var currentState = UIViewController.State.loading

    // MARK: - UIViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newState = UIViewController.State.loaded
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Logger.info(loggerSourceName, #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Logger.info(loggerSourceName, #function)
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
}

