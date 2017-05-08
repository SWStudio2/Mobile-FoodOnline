//
//  MerchantTableViewCell.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/18/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class MerchantTableViewCell: UITableViewCell {
    @IBOutlet weak var merImage:UIImageView!
    @IBOutlet weak var merName:UILabel!
    @IBOutlet weak var merTime:UILabel!
    @IBOutlet weak var merDistance:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
