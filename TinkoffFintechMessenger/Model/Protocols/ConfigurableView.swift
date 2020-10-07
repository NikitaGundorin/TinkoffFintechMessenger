//
//  ConfigurableView.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 25.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
