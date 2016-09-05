//
//  MMLoadingButton.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/4.
//
//

import UIKit
public class MMLoadingButton: UIButton {
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var stateLayer:MMStateLayer!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        stateLayer = MMStateLayer(frame: self.bounds)
        self.layer.addSublayer(stateLayer)
    }
    
    private var originalTitle = ""
    
    
    public func startLoading() {
        
    }

}
