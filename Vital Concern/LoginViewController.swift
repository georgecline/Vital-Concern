//
//  LoginViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/3/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit
//import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    
    @IBOutlet var AgreeCheckbox: CheckBox!

    
    
    @IBOutlet weak var emailaddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
/*
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
*/
 
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var agreecheckboxButtonTapped: CheckBox!

    @IBAction func loginButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
        
        // Read values from text fields
        let emailAddress = emailaddressTextField.text!
        let userPassword = userPasswordTextField.text!
        let doLogin = "Login"
        
        
        // Validate required fields are not empty
        if (emailaddressTextField.text?.isEmpty)! ||
            (userPasswordTextField.text?.isEmpty)!
        {
            // Display Alert message and return
            print("Email Address \(String(describing: emailAddress)) or password \(String(describing: userPassword)) is empty")
            displayMessage(userMessage: "Email address and password are required.")
            return
        }
        
        if AgreeCheckbox.isChecked {
        } else {
            displayMessage(userMessage: "Please agree to the privacy policy and terms of use.")
            return
        }
        
        
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        
        // Send HTTP Request to perform login
        let myUrl = URL(string: "https://www.vitalconcern.com/mobilelogin.php")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
    //    request.addValue("application/json", forHTTPHeaderField: "content-type")
     //   request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
        
     //   let postString = ["usr_email": emailAddress!, "pwd": userPassword!]  as [String: String]
      //  let postString = "firstName=James&lastName=Bond";
        let postString = "usr_email=\(emailAddress)&pwd=\(userPassword)&doLogin=\(doLogin)"
        
        
     //   do {
            request.httpBody = postString.data(using: String.Encoding.utf8);
           // request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
    //    } catch let error {
     //       print(error.localizedDescription)
     //       displayMessage(userMessage: "Something went wrong. Try again.")
     //       return
      //  }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                self.displayMessage(userMessage: "post task Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            
            
            //Let's convert response sent from a server side code to an NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    
                    if parseJSON["errorMessageKey"] != nil
                    {
                        self.displayMessage(userMessage: parseJSON["errorMessage"] as! String)
                        return
                    }
//let loginresult = parseJSON["request"] as? String

                    // Now we can access values by their keys
                    let user_level = parseJSON["user_level"] as? String
                    let first_name = parseJSON["first_name"] as? String
                    let last_name = parseJSON["last_name"] as? String
                    let congname = parseJSON["congname"] as? String
                    let user_email = parseJSON["user_email"] as? String
                    let EmailDailyReport = parseJSON["EmailDailyReport"] as? String
                    let EmailAlerts = parseJSON["EmailAlerts"] as? String
  
                    
                    //print("Access token: \(String(describing: accessToken!))")
                    
                    let saveuser_level: Bool = KeychainWrapper.standard.set(user_level!, forKey: "user_level")
                    let savefirst_name: Bool = KeychainWrapper.standard.set(first_name!, forKey: "first_name")
                    let savelast_name: Bool = KeychainWrapper.standard.set(last_name!, forKey: "last_name")
                    let savecongname: Bool = KeychainWrapper.standard.set(congname!, forKey: "congname")
                    let saveuser_email: Bool = KeychainWrapper.standard.set(user_email!, forKey: "user_email")
                    let saveuserPassword: Bool = KeychainWrapper.standard.set(userPassword, forKey: "userPassword")
                    let saveEmailDailyReport: Bool = KeychainWrapper.standard.set(EmailDailyReport!, forKey: "EmailDailyReport")
                    let saveEmailAlerts: Bool = KeychainWrapper.standard.set(EmailAlerts!, forKey: "EmailAlerts")
                    
                    print("saveuser_level: \(saveuser_level)")
                    print("savefirst_name: \(savefirst_name)")
                     print("savelast_name: \(savelast_name)")
                     print("savecongname: \(savecongname)")
                     print("saveuser_email: \(saveuser_email)")
                    print("saveuserPassword: \(saveuserPassword)")
                     print("saveEmailDailyReport: \(saveEmailDailyReport)")
                     print("saveEmailAlerts: \(saveEmailAlerts)")
                    
                    
                    print("User Level: \(String(describing: user_level!))")
                    print("First Name: \(String(describing: first_name!))")
                    print("Last Name: \(String(describing: last_name!))")
                    print("Cong Name: \(String(describing: congname!))")
                    print("User Email Address: \(String(describing: user_email!))")
                    print("User Password: \(String(describing: userPassword))")
                    print("Email Daily Report: \(String(describing: EmailDailyReport!))")
                    print("Email Alerts: \(String(describing: EmailAlerts!))")
        

        
                    if (user_email?.isEmpty)!
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Sorry, Could not successfully perform this request. Please try again later")
                        return
                    }

                    DispatchQueue.main.async
                        {
                            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "StartPageViewController") as! StartPageViewController
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = homePage
                    }


                    } else {
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                    }
                    
                }
                catch
                {
                    
                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                    
                    //Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                    print(error)
                }
            }
            
                
task.resume()
        }
        
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                    DispatchQueue.main.async
                        {
                           // self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async
            {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }
    
    
        
    
    
    @IBAction func forgotpasswordButtonTapped(_ sender: Any) {
    }
    
    @IBAction func trydemoButtonTapped(_ sender: Any) {
        
        //this is what will happen
    }
    
    @IBAction func newnetworkButtonTapped(_ sender: Any) {
    }
    
    @IBAction func privacypolicyButtonTapped(_ sender: Any) {
    }
    
    @IBAction func termsofuseButtonTapped(_ sender: Any) {
    }
    

    
/*
    
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
    
  */
    
    
}
    
    
    
    /*
    SNIPPET CODE TO DISMISS A VIEW CONTROLLER WITH CANCEL BUTTON
    
     @IBAction func cancelButtonTapped(_ sender: Any) {
     print("Cancel button tapped")
     
     self.dismiss(animated: true, completion: nil)
     }
    
    
    
   */
    
    
    
    
    /*
    // MARK: - Navigation


     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


