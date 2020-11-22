//
//  CreateChannelAlertController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 18.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class CreateChannelAlertController: UIAlertController {
    
    var submitAction: UIAlertAction? {
        didSet {
            if let submitAction = submitAction {
                submitAction.isEnabled = false
                addAction(submitAction)
            }
        }
    }
    
    override func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        super.addTextField { [weak self] textField in
            textField.addTarget(self,
                                action: #selector(self?.createChannelTextFieldDidChange(_:)),
                                for: .editingChanged)
        }
    }
    
    @objc func createChannelTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text,
            !text.isEmptyOrOnlyWhitespaces {
            submitAction?.isEnabled = true
        } else {
            submitAction?.isEnabled = false
        }
    }
}
