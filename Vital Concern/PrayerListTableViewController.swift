//
//  PrayerListTableViewController.swift
//  Vital Concern
//
//  Created by user144388 on 9/14/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class PrayerListTableViewController: UITableViewController {

    struct jsonstruct:Decodable {
        let requestfor:String
        let Issue:String
        let Relationship:String
        let Action:String
        let Status:String
        let DateModified:String
        let Details:String
        let concern:String
        let name:String
    }
    
    
    @IBOutlet var prayerlistTableView: UITableView!
     var arrdata = [jsonstruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
self.navigationItem.title = "Prayer List"
        
        
        func getdata(){
            let myUrl = URL(string: "https://www.vitalconcern.com/ios/congrequests/index.php")
            var request = URLRequest(url:myUrl!)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
            
            let user_emailString: String! = KeychainWrapper.standard.string(forKey: "user_email")
            let userPasswordString: String! = KeychainWrapper.standard.string(forKey: "userPassword")
            
            print("User Email: \(String(describing: user_emailString!))")
            print("Password: \(String(describing: userPasswordString!))")
            
            let postString = "usr_email=\(user_emailString!)&pwd=\(userPasswordString!)"
            
            
            // URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            request.httpBody = postString.data(using: String.Encoding.utf8);
            
            print("Request: \(request.httpBody!)")
            
            
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                print("Post String: \(postString)")
                
                if error != nil
                {
                    
                    print("error=\(String(describing: error))")
                    return
                }
                
                
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response!)")
                }
                
                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(responseString!)")
                
                
                
                //   URLSession.shared.dataTask(with: myUrl!) { (data, response, error) in
                
                
                do{
                    
                    
                    
                    if error == nil{
                        self.arrdata = try JSONDecoder().decode([jsonstruct].self, from: data!)
                        
                        
                        
                        for mainarr in self.arrdata{
                            print(mainarr.requestfor,":",mainarr.Issue,":",mainarr.name)
                            DispatchQueue.main.async {
                                self.prayerlistTableView.reloadData()
                            }
                            
                        }
                    }
                    
                }
                catch
                {
                    print("Error in get json data")
                }
            }
            
            task.resume()
        }
        
        
        
        
  getdata()
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }



    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
*/
    
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if !arrdata.isEmpty
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No current prayer requests"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return self.arrdata.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let cell:PrayerListTableViewCell = prayerlistTableView.dequeueReusableCell(withIdentifier: "cell") as! PrayerListTableViewCell
        cell.lblrequestfor.text = "\(arrdata[indexPath.row].requestfor)"
        cell.lblIssue.text = "\(arrdata[indexPath.row].Issue)"
       

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pldetail:PrayerListDetViewController = self.storyboard?.instantiateViewController(withIdentifier: "pldetail") as! PrayerListDetViewController
        pldetail.strfulldetail = "\n\nDATE:\n\(arrdata[indexPath.row].DateModified)\n\nSUBJECT:\n\(arrdata[indexPath.row].requestfor)\n\nISSUE:\n\(arrdata[indexPath.row].Issue)\n\nSTATUS:\n\(arrdata[indexPath.row].Status)\n\nACTION:\n\(arrdata[indexPath.row].Action)\n\nRELATIONSHIP:\n\(arrdata[indexPath.row].Relationship)\n\nTYPE:\n\(arrdata[indexPath.row].concern)\n\nURGENCY:\n\(arrdata[indexPath.row].name)\n\nDETAILS:\n\(arrdata[indexPath.row].Details)\n"
        
        
        self.navigationController?.pushViewController(pldetail, animated: true)
        
    }
    
}
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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


