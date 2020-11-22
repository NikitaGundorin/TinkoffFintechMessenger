//
//  AppDelegate.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 13.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - Private properties
    
    private let rootAssembly = RootAssembly()
    private lazy var logger: ILogger = rootAssembly.coreAssembly.logger(sourceName: "AppDelegate")
    
    // MARK: - App lifecycle methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        logger.stateInfo(from: "Not running",
                         to: application.applicationState.description,
                         methodName: #function)
        
        FirebaseApp.configure()
        
        let conversationListVC = rootAssembly.presentationAssembly.conversationsListViewController()
        let navigationController =
            rootAssembly.presentationAssembly.baseNavigationViewController(rootViewController: conversationListVC)
        
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        rootAssembly.serviceAssembly.themeService().setupTheme()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        logger.stateInfo(from: UIApplication.State.inactive.description,
                         to: application.applicationState.description,
                         methodName: #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        logger.stateInfo(from: application.applicationState.description,
                         to: UIApplication.State.inactive.description,
                         methodName: #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        logger.stateInfo(from: UIApplication.State.inactive.description,
                         to: application.applicationState.description,
                         methodName: #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        logger.stateInfo(from: application.applicationState.description,
                         to: UIApplication.State.inactive.description,
                         methodName: #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        logger.stateInfo(from: application.applicationState.description,
                         to: "Not running",
                         methodName: #function)
    }
}
