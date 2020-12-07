//
//  AnimatedWindow.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 26.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class AnimatedWindow: UIWindow {
    
    // MARK: - Private properties
    
    private lazy var animator = ParticlesAnimator(window: self)
    
    // MARK: - Overrided methods
    
    override func sendEvent(_ event: UIEvent) {
        event.touches(for: self)?.forEach { touch in
            animator.animate(in: touch.location(in: self))
        }
        
        super.sendEvent(event)
    }
}
