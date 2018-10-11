//
//  ContactUsViewController.swift
//  Vital Concern
//
//  Created by user144388 on 10/11/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    
    @IBOutlet var emailaddressTextField: UITextField!
    
    @IBOutlet var yourmessageTextView: UITextView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        
        

        // Do any additional setup after loading the view.
    }
    
    
    

    
    
    
    
    @IBAction func submitmessageButtonTapped(_ sender: UIButton) {
    
    
    
    
    
    let usr_email = emailaddressTextField.text!
    let yourmessage = yourmessageTextView.text!
    let doPost = "ContactUs"
        
        
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
    let myUrl = URL(string: "https://www.vitalconcern.com/ios/contactus/index.php")
    var request = URLRequest(url:myUrl!)
    
    request.httpMethod = "POST"// Compose a query string
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
    
    
    let postString = "usr_email=\(usr_email)&yourmessage=\(yourmessage)&doPost=\(doPost)"
    print("Post String: \(String(describing: postString))")
    
    //   do {
    request.httpBody = postString.data(using: String.Encoding.utf8);
    
    
    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        
        self.removeActivityIndicator(activityIndicator: myActivityIndicator)
        
        if error != nil
        {
            self.displayMessage(userMessage: "ould not successfully perform this request. Please try again later")
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
                let message = parseJSON["message"] as? String

                

             
                
                if (message?.isEmpty)!
                {
                    // Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Sorry, Could not successfully perform this request. Please try again later")
                    return
                }
                
                
                
                
                if (message! == "success")
                {
                    // Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Thank you for your message. You will normally be contacted by email within 24-48 hours from support@vitalconcern.com.")
                    return
                
                
                
                
                
                DispatchQueue.main.async
                    {
                        let newPage = self.storyboard?.instantiateViewController(withIdentifier: "StartPageViewController") as! StartPageViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = newPage
                }
                
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
