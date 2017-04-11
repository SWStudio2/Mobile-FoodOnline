//
//  OrderStatusViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 3/19/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Foundation

class OrderStatusViewController: BaseViewController , NVActivityIndicatorViewable {
    @IBOutlet weak var confirmCodeLbl : UILabel!
    @IBOutlet weak var estimateTimeLbl:UILabel!
    @IBOutlet weak var load1 :UIView!
    @IBOutlet weak var load2 :UIView!
    @IBOutlet weak var load3 :UIView!
    @IBOutlet weak var tableView:UIExpandableTableView!
    @IBOutlet weak var totalPriceLbl:UILabel!
    @IBOutlet weak var deliverPrice:UILabel!
    @IBOutlet weak var netPriceLbl:UILabel!
    
    var confirmOrder = ""
    var estimateTime = ""
    var orderNo = ""
    var  basArr = NSArray()
    var totalDistance = 0.0
    var totalPrice = 0.0
    var totalDeliverPrice = 0.0
    var merTotalPrice = 0.0
    var merDeliveryPrice = 0.0
    var deliveryRate = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        self.tableView.delegate = self
        self.title = "ออร์เดอร์รหัส \(orderNo)"
        self.confirmCodeLbl.text = "รหัสรับสินค้า \(confirmOrder)"
        self.estimateTimeLbl.text = "จะถึงเวลาโดยประมาณ : \(estimateTime) น."
        // Do any additional setup after loading the view.
        
        
        self.addLoading()
        if  GlobalVariables.sharedManager.basket.object(forKey: "merchant") != nil {
            basArr = GlobalVariables.sharedManager.basket.object(forKey: "merchant")! as! NSArray
            tableView.reloadData()
            GlobalVariables.sharedManager.basket = NSDictionary()
            GlobalVariables.sharedManager.numOfBasket = 0
        }
        let defaults = UserDefaults.standard
        deliveryRate = Double.init(defaults.object(forKey: DELIVERYRATE_KEY) as! String)!
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.calculatePrice()
        print("basArr \(basArr.count)")
    }
    
    func calculatePrice (){
        totalPrice = 0.0
        totalDeliverPrice = 0.0
        totalDistance = 0.0
        for mer in basArr {
            let distance = (mer as! NSDictionary).object(forKey: "merDistance") as! String
            totalDistance = totalDistance + Double.init(distance)!
            totalDeliverPrice = totalDeliverPrice + (Double.init(distance)! * deliveryRate)
            let orders = (mer as! NSDictionary).object(forKey: "order") as! NSArray
            for or in orders {
                totalPrice = totalPrice + ((or as! NSDictionary).object(forKey: "menuPrice") as! Double)
                
            }
            
        }
        self.deliverPrice.text = NSString(format: "%.2f", totalDeliverPrice) as String
        self.totalPriceLbl.text = NSString(format: "%.2f", totalPrice) as String
        self.netPriceLbl.text = NSString(format: "%.2f", totalPrice + totalDeliverPrice) as String
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addLoading(){
        let frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: 1)!)
        activityIndicatorView.padding = 20
        activityIndicatorView.color = UIColor.orange
        self.load1.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
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

extension OrderStatusViewController:UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return basArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (basArr.count > 0) {
            if (self.tableView.sectionOpen != NSNotFound && section == self.tableView.sectionOpen) {
                basArr.object(at: section)
                return  ((basArr.object(at: section) as! NSDictionary).object(forKey: "order") as! NSArray).count + 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderList = ((basArr.object(at: indexPath.section) as! NSDictionary).object(forKey: "order") as! NSArray)
        
        if indexPath.row == 0{
            merDeliveryPrice = 0.0
            merTotalPrice = 0.0
            var cell = tableView.dequeueReusableCell(withIdentifier: "titleOrderTableViewCell", for: indexPath) as! TitleOrderTableViewCell
            //cell.textLabel?.text = "section \(indexPath.section) row \(indexPath.row)"
            //cell.textLabel?.backgroundColor = UIColor.clear
            return cell
            
        }else if indexPath.row == (orderList.count + 1) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "summaryOrderTableViewCell", for: indexPath) as! SummaryOrderTableViewCell
            
            cell.sumPrice.text = String(format: "%.2f", self.merTotalPrice) as String
            let distance = (basArr[indexPath.section] as! NSDictionary).object(forKey: "merDistance") as! String
            cell.deliveryPrice.text = String(format: "%.2f", Double.init(distance)! * deliveryRate) as String
            
            // totalPrice = totalPrice + merTotalPrice
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! BasketTableViewCell
            let order = orderList.object(at: indexPath.row - 1) as! NSDictionary
            
            
            cell.nameLbl.text = order.object(forKey: "menuName") as! String
            cell.numLbl.text =  "\(order.object(forKey: "orderDetailAmount") as! Int)"
            cell.priceLbl.text =  NSString(format: "%.2f", order.object(forKey: "menuPrice") as! Double) as String
            if order.object(forKey: "option") != nil && (order.object(forKey: "option") as! NSArray).count > 0 {
                cell.optionLbl.isHidden = false
                var str = "Option : "
                for op in (order.object(forKey: "option") as! NSArray){
                    
                    str = str + ((op as! NSDictionary).object(forKey: "optionName") as! String) + " "
                }
                cell.optionLbl.text = str
                
            }else{
                cell.optionLbl.isHidden = true
            }
            
            self.merTotalPrice = self.merTotalPrice + Double.init(cell.priceLbl.text!)!
            return cell
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = HeaderView(tableView: self.tableView, section: section)
        headerView.backgroundColor = UIColor.white
        let header = (basArr.object(at: section) as! NSDictionary).object(forKey: "merName") as! String
        headerView.merNameLbl.text = header
        //  headerView.addSubview(label)
        var imageView = UIImageView.init(frame: CGRect(x: 5, y: 5, width: headerView.frame.height - 10, height: headerView.frame.height - 10))
        imageView.image = UIImage(named: "image-not-found")
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        var line = UIView.init(frame: CGRect(x: 0, y: headerView.frame.height - 2, width: headerView.frame.width, height: 1.0))
        line.backgroundColor = UIColor.lightGray
        headerView.addSubview(line)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let orderList = ((basArr.object(at: indexPath.section) as! NSDictionary).object(forKey: "order") as! NSArray)
        if indexPath.row == 0{
            return 40
            
        }else if indexPath.row == (orderList.count + 1) {
            return 70
        }
        return 60
        
    }
    
    
}

