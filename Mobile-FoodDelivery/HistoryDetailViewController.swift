//
//  HistoryDetailViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 4/10/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {
    
    @IBOutlet weak var receivedLbl:UILabel!
    @IBOutlet weak var tableView:UIExpandableTableView!
    @IBOutlet weak var totalPriceLbl:UILabel!
    @IBOutlet weak var deliverPrice:UILabel!
    @IBOutlet weak var netPriceLbl:UILabel!
    
    var order = Order()
    var merTotalPrice = 0.0
    var merDeliveryPrice = 0.0
    var deliveryRate = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initValue(){
        self.tableView.delegate = self
        self.title = "ออร์เดอร์รหัส \(order.order_id)"
        let defaults = UserDefaults.standard
        deliveryRate = Double.init(defaults.object(forKey: DELIVERYRATE_KEY) as! String)!
        self.totalPriceLbl.text = String.init(format: "%.2f", order.order_food_price)
        self.deliverPrice.text = String.init(format: "%.2f", order.order_delivery_price)
        self.netPriceLbl.text = String.init(format: "%.2f", order.order_total_price)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension  HistoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return order.seqOrders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (order.seqOrders[section].orderDetails.count > 0) {
            if (self.tableView.sectionOpen != NSNotFound && section == self.tableView.sectionOpen) {
               
                return order.seqOrders[section].orderDetails.count + 2
            }
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.row \(indexPath.row)")
        
        
        if indexPath.row == 0{
            merDeliveryPrice = 0.0
            merTotalPrice = 0.0
            var cell = tableView.dequeueReusableCell(withIdentifier: "titleOrderTableViewCell", for: indexPath) as! TitleOrderTableViewCell
            //cell.textLabel?.text = "section \(indexPath.section) row \(indexPath.row)"
            //cell.textLabel?.backgroundColor = UIColor.clear
            return cell
            
        }else if indexPath.row == (order.seqOrders[indexPath.section].orderDetails.count + 1) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "summaryOrderTableViewCell", for: indexPath) as! SummaryOrderTableViewCell

            return cell
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! BasketTableViewCell
            let orderDetail = order.seqOrders[indexPath.section].orderDetails[indexPath.row - 1]
            
            cell.nameLbl.text = orderDetail.menu.menu_name
            cell.numLbl.text =  "\((orderDetail.order_detail_amount))"
            var optionStr = ""
            var optionPrice = 0.0
            var i = 0
            for opt in orderDetail.options {
                if i > 0 {
                    optionStr = optionStr + ", "
                }
                optionStr = optionStr + opt.option_neme
                optionPrice = optionPrice + opt.option_price
                i += 1
            }
            cell.optionLbl.text = optionStr
            if orderDetail.order_detail_status == Y_FLAG {
                cell.priceLbl.text = String.init(format: "%.2f", ((orderDetail.menu.menu_price) + optionPrice))
                self.merTotalPrice = self.merTotalPrice + Double.init(cell.priceLbl.text!)!
            }else{
                cell.priceLbl.text = "0.00"
                cell.nameLbl.textColor = UIColor.lightGray
                cell.priceLbl.textColor = UIColor.lightGray
                cell.numLbl.textColor = UIColor.lightGray
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = HeaderView(tableView: self.tableView, section: section)
        headerView.section = section
        headerView.backgroundColor = UIColor.white
        let header = order.seqOrders[section].merchant.merName
        
        headerView.merNameLbl.text = header
        //  headerView.addSubview(label)
        var imageView = UIImageView.init(frame: CGRect(x: 5, y: 5, width: headerView.frame.height - 10, height: headerView.frame.height - 10))
        imageView.image = UIImage(named: "image-not-found")
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
    
        if order.seqOrders[section].seqor_cook_status_id == MERCHANT_IGNORE_STATUS {
            headerView.backgroundColor = UIColor.lightGray
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 40
            
        }else if indexPath.row == (order.seqOrders[indexPath.section].orderDetails.count + 1) {
            return 70
        }
        return 60
        
    }
    

}
