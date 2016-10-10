//
//  MMLoadingButton.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/4.
//
//

import UIKit
@IBDesignable
open class MMLoadingButton: UIButton {
   
    @IBInspectable open var errorColor:UIColor? {
        didSet {
            errorLabel.textColor = errorColor
        }
    }

    @IBInspectable open var errFontSize:CGFloat = 17.0 {
        didSet {
            errorLabel.font = UIFont.systemFont(ofSize: errFontSize)
        }
    }
    
    @IBInspectable open var errLabelMargin:CGFloat = 5.0 {
        didSet {
            if errTopConstraint != nil{
                errTopConstraint.constant = errLabelMargin
            }
        }
    }
    fileprivate var errTopConstraint:NSLayoutConstraint!
    fileprivate var originBottomConstant:CGFloat = 0.0
    fileprivate var bottomConstraint:NSLayoutConstraint?
    fileprivate var completed:(()->Void)?
    fileprivate var originalColor:UIColor!
    fileprivate var originalRadius:CGFloat = 0.0
    fileprivate var stateLayer:MMStateLayer!
    fileprivate var toVC:UIViewController!
    fileprivate var scuessTransition:MMTransition?
    fileprivate var scuessDismissTransition:MMTransition?
    
    fileprivate lazy var errorLabel:UILabel = {
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
    
    open override func awakeFromNib() {
        let screenWidth = UIScreen.main.bounds.size.width
        self.superview?.addSubview(errorLabel)
        let height = NSLayoutConstraint.init(item: errorLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        let width = NSLayoutConstraint(item: errorLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenWidth-40)
        errTopConstraint = NSLayoutConstraint.init(item: errorLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: errLabelMargin)
        let center = NSLayoutConstraint.init(item: errorLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        self.superview?.addConstraints([width,center,errTopConstraint,height])
        errorLabel.clipsToBounds = false
        errorLabel.backgroundColor = UIColor.clear
        errorLabel.textAlignment = .center
        errorLabel.text = ""
        errorLabel.alpha = 0.0
        bottomConstraint = self.getBottomConstraint()
        if let b = bottomConstraint {
            originBottomConstant = b.constant
        }
    }
    
    fileprivate func setUp() {
        stateLayer = MMStateLayer(frame: self.bounds,delegate: self)
        stateLayer.strokeColor = self.titleLabel?.textColor.cgColor
        self.layer.addSublayer(stateLayer)
        self.originalRadius = self.layer.cornerRadius
        self.originalColor = self.backgroundColor
    }
    
    open func addScuessPresentVC(_ toVC:UIViewController) {
        scuessDismissTransition = nil
        self.scuessTransition =  MMTransition(duration: 0.6)
        self.toVC = toVC
    }
    
    open func addScuessWithDismissVC() {
        if scuessTransition != nil {
            NSException(name:NSExceptionName(rawValue: "Transition Exist"), reason:"Can't add dissmiss transition because of scuessTransition Exist .", userInfo:nil).raise()
        }
        
        self.scuessDismissTransition = MMTransition(duration: 0.6)
    }
    
    open func startLoading() {
        self.setShrink(true,shrinkKey:"ShrinkStart")
    }
    
    open func stopWithError(_ msg:String,hideInternal:TimeInterval,completed:(() -> Void)?) {
        self.stateLayer.hideInternal = hideInternal
        self.stopLoading(false) {
            if let c = completed {
                c()
            }
        }
        self.showErrorLabel(true)
        self.errorLabel.text = msg
    }
    
    open func stopLoading(_ result:Bool,completed:(() -> Void)?) {
        self.completed = completed
        if let error = self.errorColor , !result {
            self.backgroundColor = error
        }
        
        self.stateLayer.currentState = (result) ? .scuess : .error
    }
    
    fileprivate func setShrink(_ isShrink:Bool,shrinkKey:String){
        self.isEnabled = false
        
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
        groupA.isRemovedOnCompletion = false
        groupA.fillMode = kCAFillModeForwards
        groupA.delegate = self
        groupA.setValue(shrinkKey, forKey: "Animation")
        self.layer.add(groupA, forKey: "Animation")
    }
    
    
    fileprivate func originalState() {
        self.titleLabel?.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = self.originalColor
        }) 
    }
    
    fileprivate func showErrorLabel(_ isShow:Bool) {
        
        if let b = bottomConstraint {
            let height =  errorLabel.frame.height + errLabelMargin
            b.constant = (isShow) ? b.constant+height : originBottomConstant
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.superview?.layoutIfNeeded()
            self.errorLabel.alpha = (isShow) ? 1.0 :0.0
        }) 
    }
    
    fileprivate func getBottomConstraint () -> NSLayoutConstraint? {
        for c in self.superview!.constraints {
            if let second = c.secondItem as? MMLoadingButton
                , (c.firstAttribute == .top &&
                       c.firstItem !== errorLabel &&
                       second === self){
            
                return c
            }
        }
        return nil
    }
}

extension MMLoadingButton:CAAnimationDelegate {
    
    public func animationDidStart(_ anim: CAAnimation) {
        self.titleLabel?.isHidden = true
    }
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let key = anim.value(forKey: "Animation") as? String {
            switch key {
            case "ShrinkStart":
                self.stateLayer.currentState = .loading
            case "ShrinkScuess":
                self.originalState()
                self.isEnabled = true
                if let c = self.completed , (scuessTransition == nil){
                    c()
                }
            case "ShrinkError":
                self.originalState()
                self.isEnabled = true
                if let c = self.completed {
                    c()
                }
            case "ShrinkDismiss":
                self.originalState()
                self.isEnabled = true
            default:
                break
            }
        }
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
            toVC.modalPresentationStyle = .custom
            
            current.present(toVC, animated: true) {
                if let c = self.completed {
                    c()
                }
            }
        } else if let _ = self.scuessDismissTransition {
            let current = UIViewController.currentViewController()
            current.transitioningDelegate = self
            current.dismiss(animated: true, completion: nil)
        } else {
            self.setShrink(false,shrinkKey:"ShrinkScuess")
        }
    }
}

extension MMLoadingButton:UIViewControllerTransitioningDelegate{
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        scuessTransition?.transitionMode = .present
        scuessTransition?.startingPoint = self.center
        scuessTransition?.bubbleColor = self.backgroundColor!
        return scuessTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = scuessTransition ?? scuessDismissTransition
        transition?.transitionMode = .dismiss
        transition?.startingPoint = self.center
        transition?.bubbleColor = self.backgroundColor!
        
        if let t = transition{
            let duration = t.duration+0.2
            
            let delayTime = DispatchTime.now() + Double(Int64(duration*Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.setShrink(false,shrinkKey:"ShrinkDismiss")
            }
        }
        
        return transition
    }
}
