//
//  AppDelegate.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 13.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - App lifecycle methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Logger.stateInfo(from: "Not running", to: application.applicationState.description, methodName: #function)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

        Logger.stateInfo(from: UIApplication.State.inactive.description, to: application.applicationState.description, methodName: #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        Logger.stateInfo(from: application.applicationState.description, to: UIApplication.State.inactive.description, methodName: #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        Logger.stateInfo(from: UIApplication.State.inactive.description, to: application.applicationState.description, methodName: #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        Logger.stateInfo(from: application.applicationState.description, to: UIApplication.State.inactive.description, methodName: #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        Logger.stateInfo(from: application.applicationState.description, to: "Not running", methodName: #function)
    }
}
