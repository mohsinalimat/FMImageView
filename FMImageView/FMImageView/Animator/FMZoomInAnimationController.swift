//
//  FMZoomInAnimationController.swift
//  FMImageView
//
//  Created by Hoang Trong Anh on 7/11/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit

extension UIView {
    func snapshot() -> UIView {
        if let contents = layer.contents {
            var snapshotedView: UIView!
            
            if let view = self as? UIImageView {
                snapshotedView = type(of: view).init(image: view.image)
                snapshotedView.bounds = view.bounds
            } else {
                snapshotedView = UIView(frame: frame)
                snapshotedView.layer.contents = contents
                snapshotedView.layer.bounds = layer.bounds
            }
            snapshotedView.layer.cornerRadius = layer.cornerRadius
            snapshotedView.layer.masksToBounds = layer.masksToBounds
            snapshotedView.contentMode = contentMode
            snapshotedView.transform = transform
            
            return snapshotedView
        } else {
            return snapshotView(afterScreenUpdates: true)!
        }
    }
}

public class FMZoomInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public var getOriginFrame: (() -> CGRect)!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.AnimationDuration.defaultDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) as? FMImageSlideViewController,
            let photoVC = toVC.pageViewController?.viewControllers?.first as? FMImagePreviewViewController
            else { return }
        
        let containerView = transitionContext.containerView
        
        let snapshot = photoVC.viewToSnapshot().snapshot()
        
        let bgView = UIView(frame: containerView.frame)
        containerView.addSubview(bgView)
        containerView.addSubview(snapshot)
        
        let originalSnapshotCornerRadius = snapshot.layer.cornerRadius
        let originalSnapshotSize = snapshot.frame.size
        
        let startFrame = self.realDestinationFrame(scaledFrame: self.getOriginFrame(), realSize: snapshot.frame.size)
        
        snapshot.layer.cornerRadius = 0
        snapshot.frame = startFrame
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        
        toVC.view.isHidden = true
        
        snapshot.alpha = 0
        bgView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        bgView.alpha = 0
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                                        snapshot.alpha = 1
                                    }
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9) {
                                        snapshot.frame = CGRect(origin: .zero, size: originalSnapshotSize)
                                        snapshot.center =  containerView.center
                                        snapshot.layer.cornerRadius = originalSnapshotCornerRadius
                                    }
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                                        bgView.alpha = 1
                                    }
        },
                                completion: { _ in
                                    toVC.view.isHidden = false
                                    snapshot.removeFromSuperview()
                                    bgView.removeFromSuperview()
                                    
                                    if transitionContext.isInteractive {
                                        if transitionContext.transitionWasCancelled {
                                            transitionContext.cancelInteractiveTransition()
                                        } else {
                                            transitionContext.finishInteractiveTransition()
                                        }
                                    }
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func realDestinationFrame(scaledFrame: CGRect, realSize: CGSize) -> CGRect {
        let scaledSize = scaledFrame.size
        let ratio = realSize.width / realSize.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var width: CGFloat = scaledSize.width
        var height: CGFloat = scaledSize.height
        
        if ratio >= 1 {
            let scaleRatio = scaledSize.height / realSize.height
            width = realSize.width * scaleRatio
            x = -(width - scaledSize.width) / 2
        } else {
            let scaleRatio = scaledSize.width / realSize.width
            height = realSize.height * scaleRatio
            y = -(height - scaledSize.height) / 2
        }
        
        let frame = CGRect(x: scaledFrame.origin.x + x,
                           y: scaledFrame.origin.y + y,
                           width: width,
                           height: height)
        return frame
    }
}

