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
    
    private var errorHandler: () -> Void
    private var imagePickedHandler: (UIImage) -> Void
    
    // MARK: - Initializer
    
    init(errorHandler: @escaping () -> Void, imagePickedHandler: @escaping (UIImage) -> Void) {
        self.errorHandler = errorHandler
        self.imagePickedHandler = imagePickedHandler
    }
    
    // MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            errorHandler()
            return
        }
        
        imagePickedHandler(image)
    }
}
