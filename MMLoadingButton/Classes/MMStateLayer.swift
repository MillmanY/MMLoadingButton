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
    case loading
    case scuess
    case error
    case none
}

class MMStateLayer: CAShapeLayer {
    var stateDelegate:MMStateLayerDelegate?

    var layerFrame = CGRect.zero
    var hideInternal:TimeInterval = 0.0

    lazy var rotationAnimation:CABasicAnimation = {
        let animation = CABasicAnimation(keyPath:"transform.rotation.z")
        animation.fromValue  = (0)
        animation.toValue    = (M_PI * 2);
        animation.duration   = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = HUGE;
        animation.fillMode = kCAFillModeBackwards
        animation.isRemovedOnCompletion = false
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
        animation.isRemovedOnCompletion = false
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
        let center = CGPoint(x: height/2, y: height/2)
        self.frame = CGRect(x: 0, y: 0, width: height, height: height)
        
        self.path = UIBezierPath(arcCenter: center, radius: radius/2, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).cgPath;

        self.fillColor = nil
        self.lineWidth = 2.0
        self.strokeEnd = 0.4
        self.isHidden = true
    }
    
    var currentState:LoadingState = .none{
        didSet {
            switch currentState {
                case .loading:
                    hideInternal = 0.0
                    self.isHidden = false
                    self.add(rotationAnimation, forKey: "RotationAnimation")
                    break
                case .scuess,.error:
                    self.removeAllAnimations()
                    break
                case .none:
                    self.setPath()
            }
        }
    }
    
   
    
    func drawCheckPath(){
        let bezier = UIBezierPath()
        let frame = self.frame
        let centerX = frame.width/2
        let centerY = frame.height/2
        if(self.currentState == .scuess){
            bezier.move(to: CGPoint(x: centerX - centerX/2,y: centerY))
            bezier.addLine(to: CGPoint(x: centerX - 2,y: centerY + centerY/2))
            bezier.addLine(to: CGPoint(x: centerX + centerX/2 + 3,y: centerY - centerY/2 + 3))
        }else if (self.currentState == .error){
            bezier.move(to: CGPoint(x: centerX - centerX/2,y: centerY - centerY/2))
            bezier.addLine(to: CGPoint(x: centerX + centerX/2,y: centerY + centerY/2))
            bezier.move(to: CGPoint(x: centerX + centerX/2,y: centerY - centerY/2))
            bezier.addLine(to: CGPoint(x: centerX - centerX/2,y: centerX + centerX/2))
        }
        self.strokeEnd = 1.0
        self.path = bezier.cgPath
        self.add(pathAnimation, forKey: "ResultAnimation")
    }
}

extension MMStateLayer:CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animation = anim as? CABasicAnimation {
            switch animation.keyPath! {
            case "transform.rotation.z":
                self.drawCheckPath()
            case "strokeEnd":
                let delayTime = DispatchTime.now() + Double(Int64(self.hideInternal*Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.isHidden = true
                    if self.currentState == .scuess {
                        self.stateDelegate?.stateScuessCompleted()
                    } else {
                        self.stateDelegate?.stateFailCompleted()
                    }
                    self.currentState = .none
                }
            default:
                break
            }
        }
    }
}
