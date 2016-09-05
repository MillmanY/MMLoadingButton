//
//  MMStateLayer.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/4.
//
//

import UIKit


enum LoadingState {
    case Loading
    case Scuess
    case Error
    case None
}


class MMStateLayer: CAShapeLayer {
    
    var layerFrame = CGRectZero
    
    convenience init(frame:CGRect){
        self.init()
        self.setPath()
        layerFrame = frame
    }
    
    
    func setPath() {
        let height = min(self.frame.size.height, self.frame.size.width)
        let radius = height/2

        self.frame = CGRectMake(0, 0, height, height)
   
        self.path = UIBezierPath(roundedRect: layerFrame, cornerRadius: radius).CGPath

        self.fillColor = nil
        self.strokeColor = UIColor.whiteColor().CGColor
        self.lineWidth = 2.0
        self.strokeEnd = 0.4
//        self.hidden = true
    }

    
    var currentState:LoadingState = .None{
        didSet {
            switch currentState {
                case .Loading:
                    break
                case .Scuess:
                    break
                case .Error:
                    break
                default:
                    break
            }
        }
    }
    
    
    
    
}
