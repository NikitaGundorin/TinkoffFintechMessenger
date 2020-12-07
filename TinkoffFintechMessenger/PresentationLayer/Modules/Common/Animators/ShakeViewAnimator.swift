//
//  ShakeViewAnimator.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 22.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ShakeViewAnimator: IViewAnimator {
    
    // MARK: - Private properties
    
    private let view: UIView?
    private let key: String
    private var initialPosition: CGPoint = .zero
    private let duration = 0.3
    private let rotationKeyPath = "transform.rotation"
    private let positionKeyPath = "position"
    
    // MARK: - Initializer
    
    init(view: UIView?) {
        self.view = view
        self.key = "shake"
    }
    
    // MARK: - Public methods
    
    func start() {
        guard let view = view else { return }
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let rotationAnimation = CAKeyframeAnimation(keyPath: rotationKeyPath)
        rotationAnimation.values = [0, -CGFloat(Double.pi / 10), 0, CGFloat(Double.pi / 10), 0]
        rotationAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        initialPosition = view.layer.position
        let positionAnimation = CAKeyframeAnimation(keyPath: positionKeyPath)
        positionAnimation.values = [initialPosition,
                                    CGPoint(x: initialPosition.x + 5, y: initialPosition.y),
                                    CGPoint(x: initialPosition.x, y: initialPosition.y + 5),
                                    CGPoint(x: initialPosition.x - 5, y: initialPosition.y),
                                    CGPoint(x: initialPosition.x, y: initialPosition.y + 5),
                                    initialPosition]
        positionAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1.0]

        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = .infinity
        group.animations = [rotationAnimation, positionAnimation]
        view.layer.add(group, forKey: key)
    }
    
    func stop() {
        let rotationAnimation = CABasicAnimation(keyPath: rotationKeyPath)
        rotationAnimation.fromValue = view?.layer.presentation()?.value(forKeyPath: rotationKeyPath)
        rotationAnimation.toValue = 0
        
        let positionAnimation = CABasicAnimation(keyPath: positionKeyPath)
        positionAnimation.fromValue = view?.layer.presentation()?.value(forKey: positionKeyPath)
        positionAnimation.toValue = initialPosition
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.animations = [rotationAnimation, positionAnimation]
        
        view?.layer.add(group, forKey: key)
    }
}
