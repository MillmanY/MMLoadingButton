//
//  MMTransition.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/4.
//
//

import UIKit

enum BubbleTransitionMode: Int {
    case present, dismiss
}

open class MMTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    var startingPoint = CGPoint.zero {
        didSet {
            bubble.center = startingPoint
        }
    }
    
    var duration = 0.3
    var transitionMode: BubbleTransitionMode = .present
    var bubbleColor = UIColor.white
    fileprivate(set) var bubble = UIView()
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
 
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
   
        let containerView = transitionContext.containerView
    
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)

        if transitionMode == .present {
            
            let originalCenter = toView!.center
            let originalSize = toView!.frame.size
            let originalColor = toView!.backgroundColor
            bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = startingPoint
            bubble.backgroundColor = bubbleColor
            bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            containerView.addSubview(bubble)
            
            toView!.center = startingPoint
            toView!.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            toView!.alpha = 0
            toView!.backgroundColor = bubbleColor
            containerView.addSubview(toView!)
            
            UIView.animate(withDuration: duration, animations: {
                self.bubble.transform = CGAffineTransform.identity
                toView!.transform = CGAffineTransform.identity
                toView!.center = originalCenter
            }, completion: { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    toView!.alpha = 1
                    toView!.backgroundColor = originalColor
                    }, completion: { (_) in
                        transitionContext.completeTransition(true)
                })
            }) 

        } else {
            let originalCenter = fromView!.center
            let originalSize = fromView!.frame.size
            let originalColor = fromView!.backgroundColor
            
            if bubble.superview == nil {
                bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
                bubble.layer.cornerRadius = bubble.frame.size.height / 2
                bubble.center = startingPoint
                bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                bubble.backgroundColor = bubbleColor
                fromView!.addSubview(bubble)
                containerView.insertSubview(toView!, belowSubview: fromView!)
                
                UIView.animate(withDuration: self.duration, animations: {
                    self.bubble.transform = CGAffineTransform.identity
                    fromView!.backgroundColor = self.bubbleColor
                    
                    }, completion: { (_) in
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            self.bubble.alpha = 0.0
                            fromView!.alpha = 0
                            toView!.alpha = 1.0
                        }, completion: { (_) in
                            fromView!.center = originalCenter
                            fromView!.removeFromSuperview()
                            self.bubble.removeFromSuperview()
                            transitionContext.completeTransition(true)
                        }) 
                })
                
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    fromView!.backgroundColor = self.bubbleColor
                    }, completion: { (_) in
                        UIView.animate(withDuration: self.duration, animations: {
                            self.bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                            fromView!.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                            fromView!.center = self.startingPoint
                            fromView!.alpha = 0
                        }, completion: { (_) in
                            fromView!.backgroundColor = originalColor
                            fromView!.center = originalCenter
                            fromView!.removeFromSuperview()
                            self.bubble.removeFromSuperview()
                            transitionContext.completeTransition(true)
                        }) 
                })
            }
        }
    }
    
    fileprivate func frameForBubble(_ originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x);
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 3;
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
    public convenience init(duration:TimeInterval) {
        self.init()
        self.duration = duration
    }
}
