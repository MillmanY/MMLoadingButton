//
//  UIViewControllerExtension.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/5.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

extension UIViewController{
    
    fileprivate static func findBestViewController(_ vc:UIViewController) -> UIViewController! {
        if((vc.presentedViewController) != nil){
            return UIViewController.findBestViewController(vc.presentedViewController!)
        }
            
        else if(vc.isKind(of: UISplitViewController.classForCoder())){
            let splite = vc as! UISplitViewController
            if(splite.viewControllers.count > 0){
                return UIViewController.findBestViewController(splite.viewControllers.last!)
            }
                
            else{
                return vc
            }
        }
            
        else if(vc.isKind(of: UINavigationController.classForCoder())){
            let svc = vc as! UINavigationController
            if(svc.viewControllers.count > 0){
                return UIViewController.findBestViewController(svc.topViewController!)
            }
            else{
                return vc
            }
        }
            
        else if(vc.isKind(of: UITabBarController.classForCoder())){
            let svc = vc as! UITabBarController
            if(svc.viewControllers?.count > 0){
                return UIViewController.findBestViewController(svc.selectedViewController!)
            }
            else{
                return vc
            }
        }
            
        else{
            return vc
        }
    }
    
    
    static func currentViewController() -> UIViewController {
        let vc:UIViewController! = UIApplication.shared.keyWindow?.rootViewController
        
        return UIViewController.findBestViewController(vc)
    }
}
