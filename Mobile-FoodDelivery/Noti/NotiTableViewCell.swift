//
//  NotiTableViewCell.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/5/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class NotiTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    @IBOutlet weak var dateLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
