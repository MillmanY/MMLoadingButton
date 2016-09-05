//
//  MMTransition.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/4.
//
//

import UIKit

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

    @objc enum BubbleTransitionMode: Int {
        case Present, Dismiss, Pop
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
 
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        if transitionMode == .Present {
            let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            let originalCenter = presentedControllerView.center
            let originalSize = presentedControllerView.frame.size
            let originalColor = presentedControllerView.backgroundColor
            bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = startingPoint
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001)
            bubble.backgroundColor = bubbleColor
            containerView.addSubview(bubble)
            
            presentedControllerView.center = startingPoint
            presentedControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
            presentedControllerView.alpha = 0
            presentedControllerView.backgroundColor = bubbleColor
            containerView.addSubview(presentedControllerView)
            
            UIView.animateWithDuration(duration, animations: {
                self.bubble.transform = CGAffineTransformIdentity
                presentedControllerView.transform = CGAffineTransformIdentity
                presentedControllerView.center = originalCenter
            }) { (_) in
                UIView.animateWithDuration(0.3, animations: {
                    presentedControllerView.alpha = 1
                    presentedControllerView.backgroundColor = originalColor
                }, completion: { (_) in
                    transitionContext.completeTransition(true)

                })
            }
        } else {
            let key = (transitionMode == .Pop) ? UITransitionContextToViewKey : UITransitionContextFromViewKey
            let returningControllerView = transitionContext.viewForKey(key)!
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size
            let originalColor = returningControllerView.backgroundColor

            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = startingPoint

            UIView.animateWithDuration(0.3, animations: {
                returningControllerView.backgroundColor = self.bubbleColor
                }, completion: { (_) in
                    UIView.animateWithDuration(self.duration, animations: {
                        self.bubble.transform = CGAffineTransformMakeScale(0.001, 0.001)
                        returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                        returningControllerView.center = self.startingPoint
                        returningControllerView.alpha = 0
                        
                        if self.transitionMode == .Pop {
                            containerView.insertSubview(returningControllerView, belowSubview: returningControllerView)
                            containerView.insertSubview(self.bubble, belowSubview: returningControllerView)
                        }
                    }) { (_) in
                        returningControllerView.backgroundColor = originalColor
                        returningControllerView.center = originalCenter
                        returningControllerView.removeFromSuperview()
                        self.bubble.removeFromSuperview()
                        transitionContext.completeTransition(true)
                    }
            })
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
