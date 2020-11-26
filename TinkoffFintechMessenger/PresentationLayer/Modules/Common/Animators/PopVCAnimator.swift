//
//  PopVCAnimator.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 24.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class PopVCAnimator: NSObject, IViewControllerAnimator {
    
    // MARK: - Private properties
    
    private let duration = 0.2
    
    // MARK: - IViewControllerAnimator
    
    var originFrame: CGRect = .zero
    var presenting = true
    
    // MARK: - Private properties
    
    private var mask: CAShapeLayer = CAShapeLayer()
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PopVCAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let navigationController = (presenting ?
            transitionContext.viewController(forKey: .to) :
            transitionContext.viewController(forKey: .from)) as? UINavigationController,
            let presentingVC = navigationController.topViewController as? IPopAnimatableViewController,
            let presentingView = presenting ?
                transitionContext.view(forKey: .to) :
                transitionContext.view(forKey: .from)
            else {
                transitionContext.completeTransition(true)
                return
        }
        
        let originContainerFrame = presentingVC.containerView.frame
        let presentingViewFrame = presentingView.frame
        
        let xScaleFactor = originFrame.width / originContainerFrame.width
        let yScaleFactor = originFrame.height / originContainerFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                               y: yScaleFactor)
        let centerY = originFrame.midY - (originContainerFrame.midY - presentingViewFrame.midY) * yScaleFactor
        if presenting {
            presentingView.transform = scaleTransform
            presentingView.center = CGPoint(
                x: originFrame.midX,
                y: centerY)
            presentingView.clipsToBounds = true
        }
        
        if let toView = transitionContext.view(forKey: .to) {
            containerView.addSubview(toView)
        }
        containerView.bringSubviewToFront(presentingView)
        
        configureMask(frame: originContainerFrame, view: presentingView)
        animateMask(frame: originContainerFrame)
    
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            presentingView.transform = self.presenting ?
                CGAffineTransform.identity : scaleTransform
            presentingView.clipsToBounds = true
            
            presentingView.center = self.presenting ? .init(x: presentingViewFrame.midX, y: presentingViewFrame.midY) : .init(
                x: self.originFrame.midX,
                y: centerY)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    private func configureMask(frame: CGRect, view: UIView) {
        mask.path = UIBezierPath(ovalIn: frame).cgPath
        if presenting {
            mask.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)
        }
        view.layer.mask = mask
    }
    
    private func animateMask(frame: CGRect) {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = duration
        let translation = CATransform3DMakeTranslation(-(frame.minX + 100),
                                                       -(frame.minY + 100),
                                                       0)
        let scaledValue = CATransform3DScale(translation, 6, 6, 1)
        animation.fromValue = presenting ? CATransform3DIdentity : scaledValue
        animation.toValue = presenting ? scaledValue : CATransform3DIdentity
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = .init(name: .easeInEaseOut)
        mask.add(animation, forKey: nil)
    }
}
