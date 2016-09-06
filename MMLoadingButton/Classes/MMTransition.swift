//
//  MMTransition.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/4.
//
//

import UIKit

enum BubbleTransitionMode: Int {
    case Present, Dismiss
}

public class MMTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    var startingPoint = CGPointZero {
        didSet {
            bubble.center = startingPoint
        }
    }
    
    var duration = 0.3
    var transitionMode: BubbleTransitionMode = .Present
    var bubbleColor: UIColor = .whiteColor()
    private(set) var bubble = UIView()
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
 
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else {
            return
        }
    
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)

        if transitionMode == .Present {
            
            let originalCenter = toView!.center
            let originalSize = toView!.frame.size
            let originalColor = toView!.backgroundColor
            bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = startingPoint
            bubble.backgroundColor = bubbleColor
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001)
            containerView.addSubview(bubble)
            
            toView!.center = startingPoint
            toView!.transform = CGAffineTransformMakeScale(0.001, 0.001)
            toView!.alpha = 0
            toView!.backgroundColor = bubbleColor
            containerView.addSubview(toView!)
            
            UIView.animateWithDuration(duration, animations: {
                self.bubble.transform = CGAffineTransformIdentity
                toView!.transform = CGAffineTransformIdentity
                toView!.center = originalCenter
            }) { (_) in
                UIView.animateWithDuration(0.3, animations: {
                    toView!.alpha = 1
                    toView!.backgroundColor = originalColor
                    }, completion: { (_) in
                        transitionContext.completeTransition(true)
                })
            }

        } else {
            let originalCenter = fromView!.center
            let originalSize = fromView!.frame.size
            let originalColor = fromView!.backgroundColor
            
            if bubble.superview == nil {
                bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
                bubble.layer.cornerRadius = bubble.frame.size.height / 2
                bubble.center = startingPoint
                bubble.transform = CGAffineTransformMakeScale(0.001, 0.001)
                bubble.backgroundColor = bubbleColor
                fromView!.addSubview(bubble)
                containerView.insertSubview(toView!, belowSubview: fromView!)
                
                UIView.animateWithDuration(self.duration, animations: {
                    self.bubble.transform = CGAffineTransformIdentity
                    fromView!.backgroundColor = self.bubbleColor
                    
                    }, completion: { (_) in
                        
                        UIView.animateWithDuration(0.3, animations: {
                            self.bubble.alpha = 0.0
                            fromView!.alpha = 0
                            toView!.alpha = 1.0
                        }) { (_) in
                            fromView!.center = originalCenter
                            fromView!.removeFromSuperview()
                            self.bubble.removeFromSuperview()
                            transitionContext.completeTransition(true)
                        }
                })
                
            } else {
                UIView.animateWithDuration(0.3, animations: {
                    fromView!.backgroundColor = self.bubbleColor
                    }, completion: { (_) in
                        UIView.animateWithDuration(self.duration, animations: {
                            self.bubble.transform = CGAffineTransformMakeScale(0.001, 0.001)
                            fromView!.transform = CGAffineTransformMakeScale(0.001, 0.001)
                            fromView!.center = self.startingPoint
                            fromView!.alpha = 0
                        }) { (_) in
                            fromView!.backgroundColor = originalColor
                            fromView!.center = originalCenter
                            fromView!.removeFromSuperview()
                            self.bubble.removeFromSuperview()
                            transitionContext.completeTransition(true)
                        }
                })
            }
        }
    }
    
    private func frameForBubble(originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x);
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 3;
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPointZero, size: size)
    }
    
    public convenience init(duration:NSTimeInterval) {
        self.init()
        self.duration = duration
    }
}
