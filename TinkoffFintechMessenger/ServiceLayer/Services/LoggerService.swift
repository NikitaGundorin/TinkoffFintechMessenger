//
//  LoggerService.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class LoggerService: ILoggerService {
    
    // MARK: - Private properties
    
    private let logger: ILogger
    
    // MARK: - Initializer
    
    init(logger: ILogger) {
        self.logger = logger
    }
    
    // MARK: - ILoggerService
    
    func info(_ message: String) {
        logger.info(message)
    }
    
    func stateInfo(from: String, to: String, methodName: String) {
        logger.stateInfo(from: from, to: to, methodName: methodName)
    }
    
    func error(_ message: String) {
        logger.error(message)
    }
}
