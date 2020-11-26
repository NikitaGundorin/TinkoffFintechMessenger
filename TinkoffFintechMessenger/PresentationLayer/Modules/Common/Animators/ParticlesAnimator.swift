//
//  ParticlesAnimator.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 26.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ParticlesAnimator: IWindowAnimator {
    
    // MARK: - Private properties
    
    private weak var window: AnimatedWindow?
    
    private let emitterCell: CAEmitterCell = {
        var emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "logo")?.cgImage
        emitterCell.scale = 0.05
        emitterCell.scaleRange = 0.05
        emitterCell.emissionRange = .pi
        emitterCell.lifetime = 2
        emitterCell.lifetimeRange = 2
        emitterCell.birthRate = 2
        emitterCell.velocity = -30
        emitterCell.velocityRange = 20
        emitterCell.spin = -0.5
        emitterCell.spinRange = 1.0
        return emitterCell
    }()
    
    private var emitterLayer: CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.timeOffset = CFTimeInterval(arc4random_uniform(6) + 5)
        emitterLayer.emitterCells = [emitterCell]
        return emitterLayer
    }
    
    // MARK: - Initializer
    
    init(window: AnimatedWindow) {
        self.window = window
    }
    
    // MARK: - IWindowAnimator
    
    func animate(in location: CGPoint) {
        let layer = emitterLayer
        layer.position = location
        window?.layer.addSublayer(layer)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            layer.birthRate = 0
        }
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            layer.removeFromSuperlayer()
        }
    }
}
