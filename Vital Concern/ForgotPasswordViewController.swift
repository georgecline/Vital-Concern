//
//  ForgotPasswordViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/16/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var emailaddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func getpasswordButtonTapped(_ sender: Any) {
        
        // Read values from text fields
        let emailAddress = emailaddressTextField.text!
        
        let doReset = "Reset"
        
        
        
        

        
        
        
        
        // Validate required fields are not empty
        if (emailaddressTextField.text?.isEmpty)!
        {
            // Display Alert message and return
            
            displayMessage(userMessage: "Please enter valid email address")
            return
        }
        
        
        
        
    
    
        // Send HTTP Request to perform login
        let myUrl = URL(string: "https://www.vitalconcern.com/ios/forgot/forgot.php")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
        

        let postString = "user_email=\(emailAddress)&doReset=\(doReset)"
        
        
         request.httpBody = postString.data(using: String.Encoding.utf8);

        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            

            
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
                    
                    
                    if parseJSON["errorMessageKey"] != nil
                    {
                        self.displayMessage(userMessage: parseJSON["errorMessage"] as! String)
                        return
                    }
                  
                    
                    // Now we can access values by their keys
                    let resultmessage = parseJSON["toastmessage"] as? String
               
                    self.displayMessage(userMessage: "\(resultmessage!)")
                   
                    

                     return
                    
                    

                    
                    
                    
                    
                } else {
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                }
                
            }
            catch
            {
                

                
                //Display an Alert dialog with a friendly error message...
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print(error)
            }
        }
        
        
        

        
        
        
        task.resume()
        
        
        DispatchQueue.main.async
            {
                let homePage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
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
                    
                    
                    


                    
                    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    

    
    }

