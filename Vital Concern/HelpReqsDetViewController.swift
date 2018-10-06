//
//  HelpReqsDetViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/14/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class HelpReqsDetViewController: UIViewController {
    
    @IBOutlet var fulldetail: UITextView!
    
    var strfulldetail = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fulldetail.text = strfulldetail

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated....
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
