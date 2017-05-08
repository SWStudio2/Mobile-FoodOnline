//
//  MenuTableViewCell.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/19/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
//    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var menuName:UILabel!
    @IBOutlet weak var menuPrice:UILabel!
//    @IBOutlet weak var menuDetail:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
