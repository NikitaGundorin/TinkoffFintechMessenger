//
//  Logger.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 13.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

public class Logger {
    
    // MARK: - Private properties
    
    private static var isEnabled: Bool =
        Bundle.main.object(forInfoDictionaryKey: "LoggerEnabled") as? Bool ?? false
    
    // MARK: - Public methods
    
    public static func info(_ sourceName: String, _ message: String) {
        guard isEnabled else { return }
        
        print("\(sourceName): \(message)")
    }
    
    public static func stateInfo(_ sourceName: String, from: String, to: String, methodName: String) {
        guard isEnabled else { return }
        
        print("\(sourceName) moved from \(from) to \(to): \(methodName)")
    }
}
