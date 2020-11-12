//
//  Logger.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 13.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

public class Logger: ILogger {
    
    // MARK: - Private properties
    
    private let isEnabled = Bundle.main.object(forInfoDictionaryKey: "LoggerEnabled") as? Bool ?? false
    
    private var sourceName: String
    
    // MARK: - Initializer
    
    init(sourceName: String) {
        self.sourceName = sourceName
    }
    
    // MARK: - Public methods
    
    func info(_ message: String) {
        guard isEnabled else { return }
        
        print("[\(sourceName)]: \(message)")
    }
    
    func stateInfo(from: String, to: String, methodName: String) {
        guard isEnabled else { return }
        
        print("\(sourceName) moved from \(from) to \(to): \(methodName)")
    }
    
    func error(_ message: String) {
        guard isEnabled else { return }
        
        print("[ERROR] [\(sourceName)]: \(message)")
    }
}
