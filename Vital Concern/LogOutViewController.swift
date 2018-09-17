//
//  LogOutViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/8/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        do {
            let removeuser_level: Bool =  KeychainWrapper.standard.removeObject(forKey: "user_level")
            KeychainWrapper.standard.removeObject(forKey: "first_name")
            KeychainWrapper.standard.removeObject(forKey: "last_name")
            KeychainWrapper.standard.removeObject(forKey: "congname")
            KeychainWrapper.standard.removeObject(forKey: "user_email")
            KeychainWrapper.standard.removeObject(forKey: "EmailDailyReport")
            KeychainWrapper.standard.removeObject(forKey: "EmailAlerts")
            
            print("removeuser_level: \(removeuser_level)")
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
