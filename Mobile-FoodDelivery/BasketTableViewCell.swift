//
//  BasketTableViewCell.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 3/26/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var numLbl:UILabel!
    @IBOutlet weak var priceLbl:UILabel!
    @IBOutlet weak var optionLbl:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
