//
//  HistoryCell.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 4/10/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var orderNoLbl:UILabel!
    @IBOutlet weak var orderDate:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
