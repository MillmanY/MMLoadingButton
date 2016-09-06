//
//  SecondViewController.swift
//  MMLoadingButton
//
//  Created by MILLMAN on 2016/9/5.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import MMLoadingButton
class SecondViewController: UIViewController {
    @IBOutlet weak var scuess:MMLoadingButton!
    @IBOutlet weak var error:MMLoadingButton!
    @IBOutlet weak var errMsg:MMLoadingButton!

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    
    @IBAction func scuessAction() {
        scuess.startLoading()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.scuess.stopLoading(true, completed: {
                print("Scuess Completed")
            })
        }
    }
    
    @IBAction func errorAction() {
        error.startLoading()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.error.stopLoading(false, completed: {
                print("Fail Completed")
            })
        }
    }
    
    @IBAction func errorMsgAction() {
        errMsg.startLoading()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.errMsg.stopWithError("Error !!", hideInternal: 2, completed: {
                print ("Fail Message Completed")
            })
        }
    }
    
    
    @IBAction func presentAction () {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Thrid") as? ThridViewController {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissAction () {
        self.dismissViewControllerAnimated(true, completion: nil)        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
