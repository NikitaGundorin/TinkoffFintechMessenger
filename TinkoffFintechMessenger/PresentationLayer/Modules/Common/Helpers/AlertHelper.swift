//
//  AlertHelper.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 04.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class AlertHelper {
    func presentAlert(vc: UIViewController?,
                      title: String,
                      message: String,
                      additionalActions: [UIAlertAction] = [],
                      primaryHandler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: "OK", style: .cancel, handler: primaryHandler))
            additionalActions.forEach { alertController.addAction($0) }
            vc?.present(alertController, animated: true)
        }
    }
    
    func presentErrorAlert(vc: UIViewController?,
                           message: String = "This action is not allowed",
                           handler: ((UIAlertAction) -> Void)? = nil) {
        presentAlert(vc: vc, title: "Error", message: message, primaryHandler: handler)
    }
}
