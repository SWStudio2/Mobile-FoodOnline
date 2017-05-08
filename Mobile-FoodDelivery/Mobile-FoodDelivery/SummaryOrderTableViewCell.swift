//
//  SummaryOrderTableViewCell.swift
//  Sample
//
//  Created by Kewalin Sakawattananon on 3/26/2560 BE.
//  Copyright © 2560 Rondinelli Morais. All rights reserved.
//

import UIKit

class SummaryOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var sumPrice:UILabel!
    @IBOutlet weak var deliveryPrice:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
