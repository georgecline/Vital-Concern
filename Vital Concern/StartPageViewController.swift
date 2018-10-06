//
//  StartPageViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/3/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user_emailString: String? = KeychainWrapper.standard.string(forKey: "user_email")
       // print("User Email Address: \(String(describing: user_emailString))");
        if (user_emailString == nil)
            
        {
            
            
            //????????????????????????????
            DispatchQueue.main.async
                {
            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homePage
                    self.dismiss(animated: false, completion: nil)
        }
        }
        
 /*
        DispatchQueue.main.async
            {
                let homePage = self.storyboard?.instantiateViewController(withIdentifier: "StartPageViewController") as! StartPageViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homePage
        }

   */
        
        
        
        
        
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
