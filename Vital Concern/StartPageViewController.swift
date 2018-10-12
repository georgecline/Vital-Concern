//
//  StartPageViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/3/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit








class StartPageViewController: UIViewController {

    @IBOutlet var congnameLabel: UILabel!
    
    @IBOutlet var ui_scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var user_emailString: String? = KeychainWrapper.standard.string(forKey: "user_email")
        
                var congnameString: String? = KeychainWrapper.standard.string(forKey: "congname")
        
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
        
        congnameLabel.text = congnameString
        
        congnameLabel.resignFirstResponder()
        
        
        
 /*
        DispatchQueue.main.async
            {
                let homePage = self.storyboard?.instantiateViewController(withIdentifier: "StartPageViewController") as! StartPageViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homePage
        }

   */
        
        
        
        
          self.hideKeyboardWhenTappedAround()
        
        
        
        
        // setup keyboard event
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


   
    
    
    
    // KEYBOARD FUNCTIONS - WERE AFTER DIDRECEIVEMEMORYWARNING
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.ui_scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        ui_scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        ui_scrollView.contentInset = contentInset
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
