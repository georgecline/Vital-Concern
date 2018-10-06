//
//  SetUpNewChurchViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/20/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class SetUpNewChurchViewController: UIViewController {

    @IBOutlet var setupcopyTextView: UITextView!

    @IBOutlet var AgreeCheckbox: CheckBox!
    
    @IBOutlet var ui_scrollView: UIScrollView!
    
    @IBOutlet var firstnameTextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    @IBOutlet var emailaddressTextField: UITextField!
    @IBOutlet var phonenumberTextField: UITextField!
    @IBOutlet var churchnameTextField: UITextField!
    @IBOutlet var numbermembersTextField: UITextField!
    @IBOutlet var interestedTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view....
        
        
                setupcopyTextView.text = "This app is free to church members. Churches pay $25 per month to set up their private network at www.VitalConcern.com.  Members access their church network through the free app.  \n\nIf you want to become the administrator for your church's network, fill out the form below."
    

            

            self.hideKeyboardWhenTappedAround()
        
        
        
        
        
        // setup keyboard event
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

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
    
    

    @IBAction func signupButtonTapped(_ sender: Any) {

        
        
        // Read values from text fields
        let first_name = firstnameTextField.text!
        let last_name = lastnameTextField.text!
        let usr_email = emailaddressTextField.text!
        let yourphone = phonenumberTextField.text!
        let churchname = churchnameTextField.text!
        let churchsize = numbermembersTextField.text!
        let reason = interestedTextField.text!
        let doLogin = "Signup"
        
        
        // Validate required fields are not empty
        if (emailaddressTextField.text?.isEmpty)! ||
            (phonenumberTextField.text?.isEmpty)! ||
            (churchnameTextField.text?.isEmpty)! ||
            (numbermembersTextField.text?.isEmpty)! ||
            (interestedTextField.text?.isEmpty)! ||
            (firstnameTextField.text?.isEmpty)! || (lastnameTextField.text?.isEmpty)!
        {
            // Display Alert message and return

            displayMessage(userMessage: "First Name, Last Name, Email Address, Phone Number, Church Name, Number Members, and Reason for Interest are required.")
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
        let myUrl = URL(string: "https://www.vitalconcern.com/ios/admins/index.php")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
        
        
        let postString = "first_name=\(first_name)&last_name=\(last_name)&usr_email=\(usr_email)&yourphone=\(yourphone)&churchname=\(churchname)&churchsize=\(churchsize)&reason=\(reason)&doLogin=\(doLogin)"
        print("Post String: \(String(describing: postString))")
        
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
                    
                    
                    if parseJSON["errorMessageKey"] != nil
                    {
                        self.displayMessage(userMessage: parseJSON["errorMessage"] as! String)
                        return
                    }
                    //let loginresult = parseJSON["request"] as? String
                    
                    // Now we can access values by their keys
                    let message = parseJSON["message"] as? String
                    let success = parseJSON["success"] as? String
                    
                    print("The message from VC server: \(String(describing: message))")
                    
                    
                    
                    if (success! == "success")
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Signup successful. You will be contacted by email within 24-48 hours from support@vitalconcern.com.")
                        return
                    }
                    
                    DispatchQueue.main.async
                        {
                            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! StartPageViewController
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
        
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
