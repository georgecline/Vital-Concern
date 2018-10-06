//
//  ChangePasswordViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/22/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    
    @IBOutlet var oldpasswordTextField: UITextField!
    @IBOutlet var newpasswordTextField: UITextField!
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changepasswordButtonTapped(_ sender: Any) {
        
        // Read values from text fields
        let oldpassword = oldpasswordTextField.text!
        let newpassword = newpasswordTextField.text!
        let doPost = "Update"
        
        let user_emailString: String! = KeychainWrapper.standard.string(forKey: "user_email")
        let userPasswordString: String! = KeychainWrapper.standard.string(forKey: "userPassword")
        
        
        
        // Validate required fields are not empty
        if (oldpasswordTextField.text?.isEmpty)! ||
            (newpasswordTextField.text?.isEmpty)!
        {
            // Display Alert message and return
           
            displayMessage(userMessage: "Old password and new password are required.")
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
        let myUrl = URL(string: "https://www.vitalconcern.com/ios/settings/mypassword.php")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string...
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
        
        
                let postString = "doPost=\(doPost)&usr_email=\(user_emailString!)&pwd=\(userPasswordString!)&oldpassword=\(oldpassword)&newpassword=\(newpassword)"
        
        

        
        //   do {
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            
            
            //Let's convert response sent from a server side code to an NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    
                    if parseJSON["errorMessage"] != nil
                    {
                        self.displayMessage(userMessage: parseJSON["errorMessage"] as! String)
                        return
                    }
                
                    
                    // Now we can access values by their keys
                    let changedpassword = parseJSON["chpwd"] as? String
                    let usermessage = parseJSON["Message"] as? String
        

                    
                    if (usermessage == "Sorry, your old password does not match our records. Please try again.")
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Sorry, your old password does not match our records. Please try again.")
                        return
                    }
                    
                    if (usermessage == "Request unsuccessful. Try again or reset password at VitalConcern.com.")
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Request unsuccessful. Try again or reset password at VitalConcern.com.")
                        return
                    }
                    
                    
                    if (usermessage == "Please contact your Vital Concern administrator.")
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Please contact your Vital Concern administrator.")
                        return
                    }
                    
                    
                    if (usermessage == "Please return to the Login page and login again.")
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Please return to the Login page and login again.")
                        return
                    }
                    
                    
                    if (usermessage == "Please try again.")
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Please try again.")
                        return
                    }
                    
                    
                    if (usermessage == "New password is invalid. Please try again.")
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "New password is invalid. Please try again.")
                        return
                    }
        
        
                    
                    if (usermessage == "")
                    {
                    
                        let saveuserPassword: Bool = KeychainWrapper.standard.set(changedpassword!, forKey: "userPassword")
                        
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Your password was successfully updated.")
                        return
                        
                        
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
    

                    
                    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
