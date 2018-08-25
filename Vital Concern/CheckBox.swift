//
//  CheckBox.swift
//  Vital Concern
//
//  Created by George Cline on 8/16/18.
//  Copyright © 2018 Vital Concern. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    //images
    let checkedImage = UIImage(named: "checked_checkbox")
    let unCheckedImage = UIImage(named: "unchecked_checkbox")
    
    //bool propety
    @IBInspectable var isChecked:Bool = false{
        didSet{
            self.updateImage()
        }
    }
    
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked), for: UIControlEvents.touchUpInside)
        self.updateImage()
    }
    
    
    func updateImage() {
        if isChecked == true{
            self.setImage(checkedImage, for: [])
        }else{
            self.setImage(unCheckedImage, for: [])
        }
        
    }
    
    @objc func buttonClicked(sender:UIButton) {
        if(sender == self){
            isChecked = !isChecked
        }
    }
    
}
