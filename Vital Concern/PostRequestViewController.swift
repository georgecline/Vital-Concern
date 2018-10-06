//
//  PostRequestViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/28/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit




class PostRequestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var concerntypeTextField: UITextField!
    
    
    let ConcernTypes = ["", "Praise", "Thanks", "Repentance", "Spiritual", "Illness", "Injury", "Persecution", "Family", "Ministry", "Missions", "Shut-in/Assisted Living", "Prison", "Employment", "Financial", "Traveling", "Help", "Encouragement", "Announcement", "Unclassified", "Cancer", "Surgery", "Medical Tests", "Bereavement", "Personal Evangelism", "Our Congregation"]

    
    @IBOutlet var subjectTextField: UITextField!
    @IBOutlet var issueTextField: UITextField!

    @IBOutlet var expirationTextField: UITextField!
    
    @IBOutlet var actionTextField: UITextField!
    @IBOutlet var statusTextField: UITextField!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var relationshipTextField: UITextField!
    @IBOutlet var emailSwitch: UISwitch!
    @IBOutlet var urgencySwitch: UISwitch!
    
    
    @IBOutlet var ui_scrollView: UIScrollView!
    

    var emailimmediatelyState: String!
    var urgencyState: String!
    
    private var datePicker: UIDatePicker?
    

    @IBAction func emailSwitchTapped(_ sender: UISwitch) {

        
        if (sender.isOn == true)
        {
            emailimmediatelyState = "sendemail"
        } else {
            emailimmediatelyState = "noemail"
        }
        

    }
    
    @IBAction func urgencySwitchTapped(_ sender: UISwitch) {

        
        if (sender.isOn == true)
        {
            urgencyState = "isurgent"
        } else {
            urgencyState = "normal"
        }

    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        // Do any additional setup after loading the view....
    
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(PostRequestViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostRequestViewController.viewTapped(gestureRecognizer:)))
        
        expirationTextField.inputView = datePicker
        
        
        
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        concerntypeTextField.inputView = pickerView
    
/*
    
    self.hideKeyboardWhenTappedAround()
        
   */
        
        
    // setup keyboard event
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
         
    }


    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
    

    
    
        if (emailSwitch.isOn) {
            emailimmediatelyState = "sendemail"
        } else {
            emailimmediatelyState = "noemail"
        }
        
        if (urgencySwitch.isOn) {
            urgencyState = "isurgent"
        } else {
            urgencyState = "normal"
        }
        
        
        
        // Read values from text fields
        let inputSubject = subjectTextField.text!
        let inputIssue = issueTextField.text!
        let inputAction = actionTextField.text!
        let inputStatus = statusTextField.text!
        let inputDetails = detailsTextView.text!
        let inputRelationship = relationshipTextField.text!
        let inputConcerntype = concerntypeTextField.text!
        let inputExpiration = expirationTextField.text!
        

        
        
        let doPost = "Post"
        
        let user_emailString: String! = KeychainWrapper.standard.string(forKey: "user_email")
        let userPasswordString: String! = KeychainWrapper.standard.string(forKey: "userPassword")
        
        

        
        // Validate required fields are not empty
        if (subjectTextField.text?.isEmpty)! ||
            (issueTextField.text?.isEmpty)! ||
            (concerntypeTextField.text?.isEmpty)! ||
            (expirationTextField.text?.isEmpty)!

        {
            // Display Alert message and return
            
            displayMessage(userMessage: "Subject, Issue, Concern Type, and Expiration Date are required.")
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
        let myUrl = URL(string: "https://www.vitalconcern.com/ios/prayerrequest/postrequest.php")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
        
        
        let postString = "doPost=\(doPost)&subject=\(inputSubject)&issue=\(inputIssue)&action=\(inputAction)&status=\(inputStatus)&details=\(inputDetails)&relationship=\(inputRelationship)&usr_email=\(user_emailString!)&pwd=\(userPasswordString!)&concerntype=\(inputConcerntype)&expiration=\(inputExpiration)&email=\(emailimmediatelyState!)&urgency=\(urgencyState!)"
        
    //    print("Post String: \(postString)")
        
    
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            

            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                
                  print("line 290")
                
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
                    let message = parseJSON["Message"] as! String

                    
                    print("The message from VC server: \(String(describing: message))")
                    
                    
                    
                    if (message == "success")
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Your request was successfully submitted.")
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
    
    
    // DATEPICKER FUNCTION -WAS AFTER VIEWDIDLOAD
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        expirationTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    
    
    
    // PICKER VIEW FUNCTIONS - WAS 2ND AFTER VIEWDIDLOAD
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConcernTypes.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ConcernTypes[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        concerntypeTextField.text = ConcernTypes[row]
        self.view.endEditing(false)
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
 
 
    
    

}
