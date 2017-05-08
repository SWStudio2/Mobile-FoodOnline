//
//  MenuDetailTableViewCell.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/19/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
/*
class MenuDetailTableViewCell: UITableViewCell {
 //   @IBOutlet weak var numTxtField:UITextField!
    @IBOutlet weak var remarkTxtField:UITextField!
    @IBOutlet weak var optionTbv:UITableView!
    @IBOutlet weak var increaseItemBtn:UIButton!
    @IBOutlet weak var decreaseItemBtn:UIButton!
    let optionList = ["เฉาก๊วย", "เยลลี่", "ไข่มุก"]
    var num = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var frameRect = remarkTxtField.frame;
        frameRect.size.height = 53;
        self.numTxtField.text = "\(num)"
        self.remarkTxtField.frame = frameRect;
        self.remarkTxtField.placeholder = "หมายเหตุ\r\n\r\n"
        self.optionTbv.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedIncreaseItem(){
        if num < MAXORDER {
            num = num + 1
            self.numTxtField.text = "\(num)"
        }
        
    }
    
    @IBAction func clickedDecreaseItem(){
        if num > MINORDER {
            num = num - 1
            self.numTxtField.text = "\(num)"
        }
    }

}
extension MenuDetailTableViewCell:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionViewCell") as! OptionTableViewCell
        cell.optionNameLabel.text = optionList[indexPath.row]
//        cell.tickButton.tag = indexPath.row
//        cell.tickButton.addTarget(self, action:#selector(MenuListViewController.tickClicked(_:)), for: .touchUpInside)
//
//        cell.tickButton.tag=1
        
//        cell.tickButton.setBackgroundImage(UIImage(named:"unchecked_checkbox.png"), for: UIControlState())
        
        return cell
    }
    /*
    func tickClicked(_ sender: UIButton!)
    {
        var value = sender.tag;
        
        if value == 1 {
            sender.setBackgroundImage(UIImage(named:"checked_2_filled.png"), for: UIControlState())
            sender.tag = 0
        }else{
            sender.setBackgroundImage(UIImage(named:"unchecked_checkbox.png"), for: UIControlState())
            sender.tag = 1
            
        }
        
    }*/
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
*/
