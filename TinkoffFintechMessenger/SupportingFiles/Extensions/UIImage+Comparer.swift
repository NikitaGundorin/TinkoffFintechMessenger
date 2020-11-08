//
//  UIImage+Comparer.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 15.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

extension UIImage {
    func isEqual(to toImage: UIImage?) -> Bool {
        guard let data1 = self.pngData(),
        let data2 = toImage!.pngData()
            else { return false}
        
        return data1.elementsEqual(data2)
    }
}
