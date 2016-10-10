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
   
        let delayTime = DispatchTime.now() + .seconds(2)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.scuess.stopLoading(true, completed: {
                print("Scuess Completed")
            })
        }
    }
    
    @IBAction func errorAction() {
        error.startLoading()
       
        let delayTime = DispatchTime.now() + .seconds(2)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.error.stopLoading(false, completed: {
                print("Fail Completed")
            })
        }
    }
    
    @IBAction func errorMsgAction() {
        errMsg.startLoading()
     
        let delayTime = DispatchTime.now() + .seconds(2)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.errMsg.stopWithError("Error !!", hideInternal: 2, completed: {
                print ("Fail Message Completed")
            })
        }
    }
    
    
    @IBAction func presentAction () {
    
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Thrid") as? ThridViewController {
            self.present(vc, animated: true, completion: nil)
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissAction () {
        self.dismiss(animated: true, completion: nil)
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
