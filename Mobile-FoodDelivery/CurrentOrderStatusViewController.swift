//
//  CurrentOrderStatusViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 4/9/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

import UIKit
import NVActivityIndicatorView
import Foundation
import Alamofire

class CurrentOrderStatusViewController: BaseViewController , NVActivityIndicatorViewable {
    @IBOutlet weak var confirmCodeLbl : UILabel!
    @IBOutlet weak var estimateTimeLbl:UILabel!
    @IBOutlet weak var load1 :UIView!
    @IBOutlet weak var load2 :UIView!
    @IBOutlet weak var load3 :UIView!
    @IBOutlet weak var tableView:UIExpandableTableView!
    @IBOutlet weak var totalPriceLbl:UILabel!
    @IBOutlet weak var deliverPrice:UILabel!
    @IBOutlet weak var netPriceLbl:UILabel!
    @IBOutlet weak var step1img:UIImageView!
    @IBOutlet weak var step2img:UIImageView!
    @IBOutlet weak var step3img:UIImageView!
    @IBOutlet weak var step4img:UIImageView!
    @IBOutlet weak var orderStatusLbl:UILabel!
    @IBOutlet weak var comLoad1 :UIView!
    @IBOutlet weak var comLoad2 :UIView!
    @IBOutlet weak var comLoad3 :UIView!
    @IBOutlet weak var mainView :UIView!
    @IBOutlet weak var hideView:UIView!
    var load1act :NVActivityIndicatorView!
    var load2act :NVActivityIndicatorView!
    var load3act :NVActivityIndicatorView!
    
    var order = Order()
    
  /*
    var confirmOrder = ""
    var estimateTime = ""
    var orderNo = ""*/
    //var  basArr = NSArray()
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
        
        
        
        /*if  GlobalVariables.sharedManager.basket.object(forKey: "merchant") != nil {
            basArr = GlobalVariables.sharedManager.basket.object(forKey: "merchant")! as! NSArray
            tableView.reloadData()
        }*/
        /*
        let defaults = UserDefaults.standard
        deliveryRate = Double.init(defaults.object(forKey: DELIVERYRATE_KEY) as! String)!
        self.getCurrentOrder()*/
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        deliveryRate = Double.init(defaults.object(forKey: DELIVERYRATE_KEY) as! String)!
        self.getCurrentOrder()
    }
    
    func setOrderInfo(orderNo:String, confirmOrder:String, estimateTime:String, status:Int, total : String, deliver : String, netPrice : String, orderStatusName:String){
        self.title = "ออร์เดอร์รหัส \(orderNo)"
        self.confirmCodeLbl.text = "รหัสรับสินค้า \(confirmOrder)"
        self.estimateTimeLbl.text = "ถึงเวลาโดยประมาณ : \(estimateTime) น."
        // Do any additional setup after loading the view.
        self.totalPriceLbl.text = total
        self.deliverPrice.text = deliver
        self.netPriceLbl.text = netPrice
        self.checkStatus(status: status, orderStatusName: orderStatusName)
    }
    
    func getCurrentOrder(){
        hideView.isHidden = false
        let frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: 23)!)
        activityIndicatorView.color = UIColor.orange
        mainView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        let defaults = UserDefaults.standard
        let cusId = defaults.value(forKey: CUSID_KEY)
        let value1 = ["cusId" : cusId, "isCurrentOrder" : "Y"]
        Alamofire.request(BASEURL+GETORDER,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        activityIndicatorView.stopAnimating()
                        print("example success")
                        //to get JSON return value
                        if let result = response.result.value {
                            print(result)
                            let JSON = result as! NSDictionary
                            print("JSON \(JSON)")
                            let orderList = (JSON.object(forKey: DATA_KEY)) as! NSArray
                            if orderList.count > 0 {
                                self.hideView.alpha = 1.0
                                
                                UIView.animate(withDuration: 2, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                    self.hideView.alpha = 0.0
                                }, completion: nil)
                                
                                self.order = Order(json: orderList[0] as! NSDictionary)
                                let orderNo = "\(self.order.order_id)"
                                let confirmOrder = self.order.order_confirm_code
                                let orderStatus = self.order.order_status_id
                                let orderStatusName = self.order.order_status
                                /*
                            let comps = NSDateComponents()
                            
                            comps.hour = 7
                            var orderEstimatedDateTime = self.order.order_estimate_datetime
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            dateFormatter.locale = NSLocale.current
                            let cal = NSCalendar.current
                            var date = dateFormatter.date(from: self.order.order_estimate_datetime)
                            let r = cal.date(byAdding: comps as DateComponents, to: date!)
                            let str = dateFormatter.string(from: r!)
                            
                            orderEstimatedDateTime = str
                            
                            
                            let start = orderEstimatedDateTime.index(orderEstimatedDateTime.startIndex, offsetBy: 11)
                            let end = orderEstimatedDateTime.index(orderEstimatedDateTime.endIndex, offsetBy: -3)
                            let range = start..<end
                            
                            orderEstimatedDateTime = orderEstimatedDateTime.substring(with: range)
                                 
                            */
                                let orderEstimatedDateTime = self.order.order_estimate_datetime.convertTime()
                                let orderDeliveryPrice = String.init(format : "%.2f", self.order.order_delivery_price as! Double)
                                let orderFoodPrice = String.init(format : "%.2f", self.order.order_food_price as! Double)
                                let orderTotalPrice = String.init(format : "%.2f", self.order.order_total_price as! Double)
                                self.setOrderInfo(orderNo: orderNo, confirmOrder: confirmOrder, estimateTime: orderEstimatedDateTime, status:orderStatus, total : orderFoodPrice, deliver : orderDeliveryPrice, netPrice : orderTotalPrice, orderStatusName: orderStatusName)
                                self.tableView.reloadData()
                            }
                        }
                    default:
                        print("error with response status: \(status)")
                    }
                }
        }
        
    }
    
    
    
    
    func checkStatus(status:Int, orderStatusName:String){
        self.hideView.isHidden = true
        orderStatusLbl.text = orderStatusName
        if status == ORDER_WAITING_RESPONSE_STATUS {
            load1act = self.addLoading(load1)
            step2img = UIImageView(image: UIImage(named: "phone_filled"))
            step2img = UIImageView(image: UIImage(named: "restaurant"))
            step3img = UIImageView(image: UIImage(named: "motorcycle"))
            step4img = UIImageView(image: UIImage(named: "exterior"))
            comLoad1.isHidden = true
            comLoad2.isHidden = true
            comLoad3.isHidden = true
        }else if status == ORDER_COOKING_STATUS {
            load2act = self.addLoading(load2)
            step2img = UIImageView(image: UIImage(named: "phone_filled"))
            step2img = UIImageView(image: UIImage(named: "restaurant_filled"))
            step3img = UIImageView(image: UIImage(named: "motorcycle"))
            step4img = UIImageView(image: UIImage(named: "exterior"))
            comLoad1.isHidden = false
            comLoad2.isHidden = true
            comLoad3.isHidden = true
        }else if status == ORDER_DELIVERING_STATUS {
            load3act = self.addLoading(load3)
            step2img = UIImageView(image: UIImage(named: "phone_filled"))
            step2img = UIImageView(image: UIImage(named: "restaurant_filled"))
            step3img = UIImageView(image: UIImage(named: "motorcycle_filled"))
            step4img = UIImageView(image: UIImage(named: "exterior"))
            comLoad1.isHidden = false
            comLoad2.isHidden = false
            comLoad3.isHidden = true
        }else if status == ORDER_RECEIVED_STATUS {
            
            step2img = UIImageView(image: UIImage(named: "phone_filled"))
            step2img = UIImageView(image: UIImage(named: "restaurant_filled"))
            step3img = UIImageView(image: UIImage(named: "motorcycle_filled"))
            step4img = UIImageView(image: UIImage(named: "exterior_filled"))
            comLoad1.isHidden = false
            comLoad2.isHidden = false
            comLoad3.isHidden = false
            
        }else if status == ORDER_CANCELLED_STATUS {
            step2img = UIImageView(image: UIImage(named: "phone"))
            step2img = UIImageView(image: UIImage(named: "restaurant"))
            step3img = UIImageView(image: UIImage(named: "motorcycle"))
            step4img = UIImageView(image: UIImage(named: "exterior"))
            comLoad1.isHidden = true
            comLoad2.isHidden = true
            comLoad3.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addLoading(_ load:UIView) -> NVActivityIndicatorView {
        let frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: 1)!)
        activityIndicatorView.padding = 20
        activityIndicatorView.color = UIColor.orange
        load.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        return activityIndicatorView
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

extension CurrentOrderStatusViewController:UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return order.seqOrders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if (order.seqOrders.count > 0) {
            if (self.tableView.sectionOpen != NSNotFound && section == self.tableView.sectionOpen) {
                
                return  order.seqOrders[section].orderDetails.count + 2
            }
         }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let orderList = order.seqOrders[indexPath.section].orderDetails
        
        if indexPath.row == 0{
            merDeliveryPrice = 0.0
            merTotalPrice = 0.0
            var cell = tableView.dequeueReusableCell(withIdentifier: "titleOrderTableViewCell", for: indexPath) as! TitleOrderTableViewCell
            //cell.textLabel?.text = "section \(indexPath.section) row \(indexPath.row)"
            //cell.textLabel?.backgroundColor = UIColor.clear
            return cell
            
        }else if indexPath.row == ((order.seqOrders[indexPath.section].orderDetails.count) + 1) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "summaryOrderTableViewCell", for: indexPath) as! SummaryOrderTableViewCell
            
            cell.sumPrice.text = String(format: "%.2f", self.merTotalPrice) as String
            let distance = order.seqOrders[indexPath.section].seqor_mer_distance
            let rate = Double.init(order.order_delivery_rate)
            cell.deliveryPrice.text = String(format: "%.2f", Double.init(distance) * rate) as String
            

           // cell.sumPrice.text = String(format: "%.2f", self.merTotalPrice) as String
            
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
            for opt in (orderDetail.options) {
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
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = HeaderView(tableView: self.tableView, section: section)
        headerView.backgroundColor = UIColor.white
        let header = order.seqOrders[section].merchant.merName
        headerView.merNameLbl.text = header
        var imageView = UIImageView.init(frame: CGRect(x: 5, y: 5, width: headerView.frame.height - 10, height: headerView.frame.height - 10))
        imageView.image = UIImage(named: "image-not-found")
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        var line = UIView.init(frame: CGRect(x: 0, y: headerView.frame.height - 2, width: headerView.frame.width, height: 1.0))
        line.backgroundColor = UIColor.lightGray
        if order.seqOrders[section].seqor_cook_status_id == MERCHANT_IGNORE_STATUS {
            headerView.backgroundColor = UIColor.lightGray
        }
        headerView.addSubview(line)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let orderDetails = order.seqOrders[indexPath.section].orderDetails
        if indexPath.row == 0{
            return 40
            
        }else if indexPath.row == ((orderDetails.count) + 1) {
            return 70
        }
        return 60
        
    }
}

