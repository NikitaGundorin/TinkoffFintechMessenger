//
//  ILogger.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol ILogger {
    func info(_ message: String)
    func stateInfo(from: String, to: String, methodName: String)
    func error(_ message: String)
}
