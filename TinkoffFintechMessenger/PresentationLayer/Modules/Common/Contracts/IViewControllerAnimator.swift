//
//  IViewControllerAnimator.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 24.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

protocol IViewControllerAnimator: UIViewControllerAnimatedTransitioning {
    var presenting: Bool { get set }
    var originFrame: CGRect { get set }
}
