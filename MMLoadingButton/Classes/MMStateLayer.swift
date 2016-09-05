//
//  MMStateLayer.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/4.
//
//

import UIKit

protocol MMStateLayerDelegate {
    func stateFailCompleted()
    func stateScuessCompleted()
}

enum LoadingState {
    case Loading
    case Scuess
    case Error
    case None
}

class MMStateLayer: CAShapeLayer {
    var stateDelegate:MMStateLayerDelegate?

    var layerFrame = CGRectZero
    var hideInternal:NSTimeInterval = 0.0

    lazy var rotationAnimation:CABasicAnimation = {
        let animation = CABasicAnimation(keyPath:"transform.rotation.z")
        animation.fromValue  = (0)
        animation.toValue    = (M_PI * 2);
        animation.duration   = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = HUGE;
        animation.fillMode = kCAFillModeBackwards
        animation.removedOnCompletion = false
        animation.delegate = self

        return animation
    }()
    
    lazy var pathAnimation:CABasicAnimation = {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.duration = 0.7
        animation.fillMode = kCAFillModeBackwards
        animation.delegate = self
        animation.removedOnCompletion = false
        return animation
    }()
    
    convenience init(frame:CGRect,delegate:MMStateLayerDelegate){
        self.init()
        self.stateDelegate = delegate
        layerFrame = frame
        self.setPath()
    }
    
    func setPath() {
        let startAngle = 0 - M_PI_2 ;
        let endAngle   = M_PI * 2 - M_PI_2;
        let height = min(layerFrame.size.height, layerFrame.size.width)
        let radius = height/2
        let center = CGPointMake(height/2, height/2)
        self.frame = CGRectMake(0, 0, height, height)
        
        self.path = UIBezierPath(arcCenter: center, radius: radius/2, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).CGPath;

        self.fillColor = nil
        self.lineWidth = 2.0
        self.strokeEnd = 0.4
        self.hidden = true
    }
    
    var currentState:LoadingState = .None{
        didSet {
            switch currentState {
                case .Loading:
                    hideInternal = 0.0
                    self.hidden = false
                    self.addAnimation(rotationAnimation, forKey: "RotationAnimation")
                    break
                case .Scuess,.Error:
                    self.removeAllAnimations()
                    break
                case .None:
                    self.setPath()
            }
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let animation = anim as? CABasicAnimation {
            switch animation.keyPath! {
            case "transform.rotation.z":
                self.drawCheckPath()
            case "strokeEnd":
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self.hideInternal*Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.hidden = true
                    if self.currentState == .Scuess {
                        self.stateDelegate?.stateScuessCompleted()
                    } else {
                        self.stateDelegate?.stateFailCompleted()
                    }
                    self.currentState = .None
                }
            default:
                break
            }
        }
    }
    
    func drawCheckPath(){
        let bezier = UIBezierPath()
        let frame = self.frame
        let centerX = CGRectGetWidth(frame)/2
        let centerY = CGRectGetHeight(frame)/2
        if(self.currentState == .Scuess){
            bezier.moveToPoint(CGPointMake(centerX - centerX/2,centerY))
            bezier.addLineToPoint(CGPointMake(centerX - 2,centerY + centerY/2))
            bezier.addLineToPoint(CGPointMake(centerX + centerX/2 + 3,centerY - centerY/2 + 3))
        }else if (self.currentState == .Error){
            bezier.moveToPoint(CGPointMake(centerX - centerX/2,centerY - centerY/2))
            bezier.addLineToPoint(CGPointMake(centerX + centerX/2,centerY + centerY/2))
            bezier.moveToPoint(CGPointMake(centerX + centerX/2,centerY - centerY/2))
            bezier.addLineToPoint(CGPointMake(centerX - centerX/2,centerX + centerX/2))
        }
        self.strokeEnd = 1.0
        self.path = bezier.CGPath
        self.addAnimation(pathAnimation, forKey: "ResultAnimation")
    }
}
