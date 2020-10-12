//
//  ImagePickerDelegate.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ImagePickerDelegate: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Private properties
    
    private var errorHandler: () -> ()
    private var imagePickedHandler: (UIImage) -> ()
    
    // MARK: - Initializer
    
    init(errorHandler: @escaping () -> (), imagePickedHandler: @escaping (UIImage) -> ()) {
        self.errorHandler = errorHandler
        self.imagePickedHandler = imagePickedHandler
    }
    
    // MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            errorHandler()
            return
        }
        
        imagePickedHandler(image)
    }
}
