//
//  FileManager+Operations.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 14.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

extension FileManager {
    static var documentsDirectoryUrl: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    static func write(data: Data, fileName: String) -> (isSuccessful: Bool, url: URL?) {
        guard let url = documentsDirectoryUrl?.appendingPathComponent(fileName)
            else { return (false, nil) }
        
        do {
            try data.write(to: url)
            return (true, url)
        } catch {
            return (false, nil)
        }
    }
    
    static func read(fileName: String) -> Data? {
        guard let url = documentsDirectoryUrl?.appendingPathComponent(fileName) else {
            return nil
        }
        
        return try? Data(contentsOf: url)
    }
    
    static func read(url: URL) -> Data? {
        return try? Data(contentsOf: url)
    }
}
