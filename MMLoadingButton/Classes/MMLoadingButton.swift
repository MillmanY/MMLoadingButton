//
//  MMLoadingButton.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/4.
//
//

import UIKit
@IBDesignable
public class MMLoadingButton: UIButton {
   
    @IBInspectable public var errorColor:UIColor? {
        didSet {
            errorLabel.textColor = errorColor
        }
    }

    @IBInspectable public var errFontSize:CGFloat = 17.0 {
        didSet {
            errorLabel.font = UIFont.systemFontOfSize(errFontSize)
        }
    }
    
    @IBInspectable public var errLabelMargin:CGFloat = 5.0 {
        didSet {
            if errTopConstraint != nil{
                errTopConstraint.constant = errLabelMargin
            }
        }
    }
    private var errTopConstraint:NSLayoutConstraint!
    private var originBottomConstant:CGFloat = 0.0
    private var bottomConstraint:NSLayoutConstraint?
    private var completed:(()->Void)?
    private var originalColor:UIColor!
    private var originalRadius:CGFloat = 0.0
    private var stateLayer:MMStateLayer!
    private var toVC:UIViewController!
    private var scuessTransition:MMTransition?
    private lazy var errorLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    public override func awakeFromNib() {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        self.superview?.addSubview(errorLabel)
        let height = NSLayoutConstraint.init(item: errorLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30)
        let width = NSLayoutConstraint(item: errorLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: screenWidth-40)
        errTopConstraint = NSLayoutConstraint.init(item: errorLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: errLabelMargin)
        let center = NSLayoutConstraint.init(item: errorLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        self.superview?.addConstraints([width,center,errTopConstraint,height])
        errorLabel.clipsToBounds = false
        errorLabel.backgroundColor = UIColor.clearColor()
        errorLabel.textAlignment = .Center
        errorLabel.text = ""
        errorLabel.alpha = 0.0
        bottomConstraint = self.getBottomConstraint()
        if let b = bottomConstraint {
            originBottomConstant = b.constant
        }
    }
    
    private func setUp() {
        stateLayer = MMStateLayer(frame: self.bounds,delegate: self)
        stateLayer.strokeColor = self.titleLabel?.textColor.CGColor
        self.layer.addSublayer(stateLayer)
        self.originalRadius = self.layer.cornerRadius
        self.originalColor = self.backgroundColor
    }
    
    public func addScuessPresentVC(toVC:UIViewController) {
        self.scuessTransition =  MMTransition(duration: 0.6)
        self.toVC = toVC
    }
    
    public func startLoading() {
        self.setShrink(true,shrinkKey:"ShrinkStart")
    }
    
    public func stopWithError(msg:String,hideInternal:NSTimeInterval,completed:(() -> Void)?) {
        self.stateLayer.hideInternal = hideInternal
        self.stopLoading(false) {
            if let c = completed {
                c()
            }
        }
        self.showErrorLabel(true)
        self.errorLabel.text = msg
    }
    
    public func stopLoading(result:Bool,completed:(() -> Void)?) {
        self.completed = completed
        if let error = self.errorColor where !result {
            self.backgroundColor = error
        }
        
        self.stateLayer.currentState = (result) ? .Scuess : .Error
    }
    
    private func setShrink(isShrink:Bool,shrinkKey:String){
        self.enabled = false
        
        let shrink = CABasicAnimation(keyPath:"bounds.size.width")
        shrink.fromValue = (isShrink) ? (self.frame.size.width) : (self.frame.size.height)
        shrink.toValue  = (isShrink) ? (self.frame.size.height) : (self.frame.size.width)
        shrink.duration = 0.3
        
        let corner = CABasicAnimation(keyPath:"cornerRadius")
        corner.fromValue = (isShrink) ? self.originalRadius : self.frame.size.height/2
        corner.toValue =  (isShrink) ? self.frame.size.height/2 : self.originalRadius
        corner.duration = 0.3
        
        let groupA = CAAnimationGroup()
        groupA.animations = [shrink,corner]
        groupA.duration = 0.3
        groupA.removedOnCompletion = false
        groupA.fillMode = kCAFillModeForwards
        groupA.delegate = self
        groupA.setValue(shrinkKey, forKey: "Animation")
        self.layer.addAnimation(groupA, forKey: "Animation")
    }
    
    override public func animationDidStart(anim: CAAnimation) {
        self.titleLabel?.hidden = true
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        if let key = anim.valueForKey("Animation") as? String {
            switch key {
            case "ShrinkStart":
                self.stateLayer.currentState = .Loading
            case "ShrinkScuess":
                self.originalState()
                self.enabled = true
                if let c = self.completed where (scuessTransition == nil){
                    c()
                }
            case "ShrinkError":
                self.originalState()
                self.enabled = true
                if let c = self.completed {
                    c()
                }
            case "ShrinkDismiss":
                self.originalState()
                self.enabled = true
            default:
                break
            }
        }
    }
    
    private func originalState() {
        self.titleLabel?.hidden = false
        UIView.animateWithDuration(0.3) {
            self.backgroundColor = self.originalColor
        }
    }
    
    private func showErrorLabel(isShow:Bool) {
        
        if let b = bottomConstraint {
            let height =  CGRectGetHeight(errorLabel.frame) + errLabelMargin
            b.constant = (isShow) ? b.constant+height : originBottomConstant
        }
        
        UIView.animateWithDuration(0.3) {
            self.superview?.layoutIfNeeded()
            self.errorLabel.alpha = (isShow) ? 1.0 :0.0
        }
    }
    
    private func getBottomConstraint () -> NSLayoutConstraint? {
        for c in self.superview!.constraints {
            if let second = c.secondItem as? MMLoadingButton
                where (c.firstAttribute == .Top &&
                       c.firstItem !== errorLabel &&
                       second === self){
            
                return c
            }
        }
        return nil
    }
}

extension MMLoadingButton:MMStateLayerDelegate {
    func stateFailCompleted() {
        self.showErrorLabel(false)
        self.setShrink(false,shrinkKey:"ShrinkError")
    }
    
    func stateScuessCompleted() {
        if let _ = self.scuessTransition {
       
            let current = UIViewController.currentViewController()
            toVC.transitioningDelegate = self
            toVC.modalPresentationStyle = .Custom
            
            current.presentViewController(toVC, animated: true) {
                if let c = self.completed {
                    c()
                }
            }
        } else {
            self.setShrink(false,shrinkKey:"ShrinkScuess")
        }
    }
}

extension MMLoadingButton:UIViewControllerTransitioningDelegate{
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        scuessTransition?.transitionMode = .Present
        scuessTransition?.startingPoint = self.center
        scuessTransition?.bubbleColor = self.backgroundColor!
        return scuessTransition
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        scuessTransition?.transitionMode = .Dismiss
        scuessTransition?.startingPoint = self.center
        scuessTransition?.bubbleColor = self.backgroundColor!
        
        if let t = self.scuessTransition{
            let duration = t.duration+0.2
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(duration*Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.setShrink(false,shrinkKey:"ShrinkDismiss")
            }
        }
        
        return scuessTransition
    }
}
