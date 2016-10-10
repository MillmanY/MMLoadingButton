//
//  ThridViewController.swift
//  MMLoadingButton
//
//  Created by MILLMAN on 2016/9/6.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import MMLoadingButton
class ThridViewController: UIViewController {

    @IBOutlet weak var scuess:MMLoadingButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        scuess.addScuessWithDismissVC()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissAction () {
        scuess.startLoading()
        let delayTime = DispatchTime.now() + .seconds(2)

        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.scuess.stopLoading(true, completed: {
                print("Scuess Completed")
            })
        }
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
