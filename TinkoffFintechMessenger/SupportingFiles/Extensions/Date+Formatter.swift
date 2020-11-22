//
//  Date+Formatter.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 25.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

extension Date {
    
    func formatted(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
