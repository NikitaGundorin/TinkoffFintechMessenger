//
//  String+Content.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 18.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

extension String {
    var isEmptyOrOnlyWhitespaces: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isEmpty
    }
}
