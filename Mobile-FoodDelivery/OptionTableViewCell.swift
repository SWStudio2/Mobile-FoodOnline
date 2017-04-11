//
//  OptionTableViewCell.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/20/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

protocol OptionDelegate {
    func clickedSelectItem(selectedOpt:NSDictionary,isAdded:Bool)
}

class OptionTableViewCell: UITableViewCell {
    @IBOutlet weak var optionNameLabel:UILabel!
    @IBOutlet weak var tickButton:UIButton!
    @IBOutlet weak var priceOptLabel:UILabel!
    var option = NSDictionary()
    var delegate:OptionDelegate? = nil
    var isSelect: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedSelectItem(){
        if isSelect {
            self.tickButton.setImage(UIImage(named: "unchecked_checkbox.png"), for: UIControlState.normal)
            self.delegate?.clickedSelectItem(selectedOpt: option, isAdded: false)
            
        }else{
            self.tickButton.setImage(UIImage(named: "checked_2_filled.png"), for: UIControlState.normal)
            self.delegate?.clickedSelectItem(selectedOpt: option, isAdded: true)
        }
        isSelect = !isSelect
        
    }
}
