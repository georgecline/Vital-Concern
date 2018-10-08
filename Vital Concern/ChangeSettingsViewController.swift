//
//  ChangeSettingsViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/23/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class ChangeSettingsViewController: UIViewController {

    @IBOutlet var firstnameTextField: UITextField!
    
    @IBOutlet var lastnameTextField: UITextField!
    
    @IBOutlet var emailaddressTextField: UITextField!
    
    @IBOutlet var dailyreportSwitch: UISwitch!
    
    @IBOutlet var emailalertSwitch: UISwitch!
    
    var dailyreportState: String!
    var emailalertState: String!
    
  
    
    // Read values from keychain fields...
    
    
    
    let user_emailString: String! = KeychainWrapper.standard.string(forKey: "user_email")
    let userPasswordString: String! = KeychainWrapper.standard.string(forKey: "userPassword")
    let firstnameString: String! = KeychainWrapper.standard.string(forKey: "first_name")
    let lastnameString: String! = KeychainWrapper.standard.string(forKey: "last_name")
    let emaildailyreportString: String! = KeychainWrapper.standard.string(forKey: "EmailDailyReport")
    let emailalertString: String! = KeychainWrapper.standard.string(forKey: "EmailAlerts")
    
    
/*
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    if emaildailyreportString == "1" {
    dailyreportSwitch.setOn(true, animated: false)
    } else {
    dailyreportSwitch.setOn(false, animated: false)
    }
    
    if emailalertString == "1" {
    emailalertSwitch.setOn(true, animated: false)
    } else {
    emailalertSwitch.setOn(false, animated: false)
    }
    }

    */
    
    
    
    

    
    
    
    
    
    
    
  @IBAction  func dailyreportSwitchTapped(_ sender: UISwitch) {
        
        if (sender.isOn == true)
        {
            dailyreportState = "1"
        } else {
            dailyreportState = "0"
        }
        
        print("Daily Report State: \(dailyreportState!)")
    }
    
    
    
   @IBAction  func emailalertSwitchTapped(_ sender: UISwitch) {
        
        if (sender.isOn == true)
        {
            emailalertState = "1"
        } else {
            emailalertState = "0"
        }
        print("Email Alert State: \(emailalertState!)")
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        
        //    override func viewWillAppear(_ animated: Bool) {
        //    super.viewWillAppear(animated)
        
        
        if emaildailyreportString == "1" {
            dailyreportSwitch.setOn(true, animated: false)
        } else {
            dailyreportSwitch.setOn(false, animated: false)
        }
        
        if emailalertString == "1" {
            emailalertSwitch.setOn(true, animated: false)
        } else {
            emailalertSwitch.setOn(false, animated: false)
        }
        //    }
        
        
        
        

        
        firstnameTextField.text = firstnameString
        lastnameTextField.text = lastnameString
        emailaddressTextField.text = user_emailString
        
        
        print("emaildailyreportString: \(emaildailyreportString!)")
        print("emailalertstring: \(emailalertString!)")
        

    
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
          let doPost = "Save"

    
    @IBAction func changesettingsButtonTapped(_ sender: Any) {

        if (dailyreportSwitch.isOn) {
            dailyreportState = "1"
        } else {
            dailyreportState = "0"
        }
        
        if (emailalertSwitch.isOn) {
            emailalertState = "1"
        } else {
            emailalertState = "0"
        }
        
        
        
        
        // Validate required fields are not empty
        if (firstnameTextField.text?.isEmpty)! ||
            (lastnameTextField.text?.isEmpty)! ||
            (emailaddressTextField.text?.isEmpty)!
        {
            // Display Alert message and return
            
            displayMessage(userMessage: "First Name, Last Name, and Email Address are required.")
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
        
        
        let firstname = firstnameTextField.text!
        let lastname = lastnameTextField.text!
        let emailAddress = emailaddressTextField.text!
        
        //userpasswordString available
        

        
        
        
        
        
        // Send HTTP Request to perform login
        let myUrl = URL(string: "https://www.vitalconcern.com/ios/settings/mysettings.php")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
        
        
        let postString = "doPost=\(doPost)&usr_email=\(user_emailString!)&pwd=\(userPasswordString!)&first_name=\(firstname)&last_name=\(lastname)&emaildailyreport=\(dailyreportState!)&emailalerts=\(emailalertState!)&newemail=\(emailAddress)"
        
        print ("postString: \(postString)")
        
        
        
        
    
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
                    let changedfirstname = parseJSON["first_name"] as? String
                    let changedlastname = parseJSON["last_name"] as? String
                    let changedemailaddress = parseJSON["user_email"] as? String
                    let changeddailyreport = parseJSON["EmailDailyReport"] as? String
                    let changedemailalert = parseJSON["EmailAlerts"] as? String
                    let usermessage = parseJSON["Message"] as? String
                    
                
                    
                    if (usermessage != "")
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "\(usermessage!)")
                        return
                    }
                    
                   
                    
                    
                    if (usermessage == "")
                    {
                        let savechangedpassword: Bool = KeychainWrapper.standard.set(changedpassword!, forKey: "userPassword")
                        let savechangedfirstname: Bool = KeychainWrapper.standard.set(changedfirstname!, forKey: "first_name")
                        let savechangedlastname: Bool = KeychainWrapper.standard.set(changedlastname!, forKey: "last_name")
                        let savechangedemailaddress: Bool = KeychainWrapper.standard.set(changedemailaddress!, forKey: "user_email")
                        let savechangeddailyreport: Bool = KeychainWrapper.standard.set(changeddailyreport!, forKey: "EmailDailyReport")
                        let savechangedemailalert: Bool = KeychainWrapper.standard.set(changedemailalert!, forKey: "EmailAlerts")

                       
                        
                    
                        
    
                        print("savechangedpassword: \(savechangedpassword)")
                        print("savechangedfirstname: \(savechangedfirstname)")
                        print("savechangedlastname: \(savechangedlastname)")
                        print("savechangedemailaddress: \(savechangedemailaddress)")
                        print("savechangeddailyreport: \(savechangeddailyreport)")
                        print("savechangedemailalert: \(savechangedemailalert)")

                        
                        
                        print("Password: \(String(describing: changedpassword!))")
                        print("First Name: \(String(describing: changedfirstname!))")
                        print("Last Name: \(String(describing: changedlastname!))")
                        print("User Email Address: \(String(describing: changedemailaddress!))")
                        print("Daily Report: \(String(describing: changeddailyreport!))")
                        print("Email Alerts: \(String(describing: changedemailalert!))")

                        
                        
                        
                        
                        
                        
                        
                        
                        
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Your settings were successfully updated.")
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
/*
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "ChangeSettingsViewController")
        self.present(secondViewController, animated: true, completion: nil)
*/
        
        
        DispatchQueue.main.async
            {
                let homePage = self.storyboard?.instantiateViewController(withIdentifier: "StartPageViewController") as! StartPageViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homePage
        }
        
        
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
    func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (emaildailyreportString == "1") {
            
            
            dailyreportSwitch.setOn(true, animated: false)
        } else {
            if (emaildailyreportString == "0") {
                
                dailyreportSwitch.setOn(false, animated: false)
            }
        }
        if (emailalertString == "1") {
            
            
            dailyreportSwitch.setOn(true, animated: false)
        } else {
            if (emailalertString == "0") {
                
                dailyreportSwitch.setOn(false, animated: false)
            }
            
        }
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

}

