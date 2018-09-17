//
//  AllReqsTableViewCell.swift
//  Vital Concern
//
//  Created by user144388 on 9/10/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class AllReqsTableViewCell: UITableViewCell {

    @IBOutlet var lblrequestfor: UILabel!
    
    @IBOutlet var lblIssue: UILabel!
    
    //    @IBOutlet var lblname: UILabel!
    
//    @IBOutlet var lblcapital: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
