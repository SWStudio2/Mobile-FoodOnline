//
//  BasketViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 3/19/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import Alamofire

class BasketViewController: BaseViewController {
    @IBOutlet weak var tableView:UIExpandableTableView!
    @IBOutlet weak var totalPriceLbl:UILabel!
    @IBOutlet weak var deliverPrice:UILabel!
    @IBOutlet weak var netPriceLbl:UILabel!
    @IBOutlet weak var orderBtn:UIButton!
    @IBOutlet weak var summaryView:UIView!
   // var items:[[Int]?] = []
    
    var  basArr = NSArray()
    var totalDistance = 0.0
    var totalPrice = 0.0
    var totalDeliverPrice = 0.0
    var merTotalPrice = 0.0
    var merDeliveryPrice = 0.0
    var deliveryRate = 0.0
    var merList:[Int] = []
    var reqParaGetEstimateTime:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.addBasketAndPinMenuButton()
        self.title = "ตะกร้า"
        // Do any additional setup after loading the view.
        // create data
        self.prepareBasketData()
        let defaults = UserDefaults.standard
        deliveryRate = Double.init(defaults.object(forKey: DELIVERYRATE_KEY) as! String)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.calculatePrice()
    }
    
    func prepareBasketData(){
        // create data
        if  GlobalVariables.sharedManager.basket.object(forKey: "merchant") != nil {
            basArr = GlobalVariables.sharedManager.basket.object(forKey: "merchant")! as! NSArray
            print("Basket \(GlobalVariables.sharedManager.basket)")
            tableView.reloadData()
            /*self.orderBtn.isHidden = false
            self.summaryView.isHidden = false
            if GlobalVariables.sharedManager.numOfBasket == 0 {
                self.orderBtn.isHidden = true
                self.summaryView.isHidden = true
            }*/
        }else{
           // self.orderBtn.isHidden = true
           // self.summaryView.isHidden = true
        }
    }
    
    func calculatePrice (){
        totalPrice = 0.0
        totalDeliverPrice = 0.0
        totalDistance = 0.0
        for mer in basArr {
            let distance = (mer as! NSDictionary).object(forKey: "merDistance") as! String
            totalDistance = totalDistance + Double.init(distance)!
            totalDeliverPrice = totalDeliverPrice + (Double.init(distance)! * deliveryRate)
            print("totalDeliverPrice \(totalDeliverPrice)")
            let orders = (mer as! NSDictionary).object(forKey: "order") as! NSArray
            for or in orders {
                totalPrice = totalPrice + ((or as! NSDictionary).object(forKey: "menuPrice") as! Double)
                
            }
            
        }
        self.deliverPrice.text = NSString(format: "%.2f", totalDeliverPrice) as String
        self.totalPriceLbl.text = NSString(format: "%.2f", totalPrice) as String
        self.netPriceLbl.text = NSString(format: "%.2f", totalPrice + totalDeliverPrice) as String
        
    }
/*
    func getBasketList(){
        if let path = Bundle.main.path(forResource: "Basket", ofType: "json")
        {
            if let jsonData = NSData (contentsOfFile: path)
            {
                do {
                    if let jsonResult: NSMutableDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary   {
                        print("jsonResult \(jsonResult)")
                        if (jsonResult.object(forKey: "merchant") != nil) {
                            basArr = jsonResult.object(forKey: "merchant")! as! NSArray
                            tableView.reloadData()
                            
                            
                        }
                    }
                } catch let error {
                    print("error")
                }
            }
        }
        
    }
*/
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedOrderMenu(_ sender : UIButton){
        
        
        self.merList.removeAll()
        for mer in basArr {
            print("mer \((mer as! NSDictionary).object(forKey: "merId")!)")
           merList.append((mer as! NSDictionary).object(forKey: "merId")! as! Int)
        }
        var lat = "13.739852"
        var long = "100.530840"
        if GlobalVariables.sharedManager.selectedLocation != nil {
            lat = "\(GlobalVariables.sharedManager.selectedLocation!.latitude)"
            long =  "\(GlobalVariables.sharedManager.selectedLocation!.longitude)"
        }else{
            
            lat = "\(GlobalVariables.sharedManager.currentLocation!.latitude)"
            long =  "\(GlobalVariables.sharedManager.currentLocation!.longitude)"
        }
        let  value1:[String:Any]  = ["cusLatitude" : lat ,
                        "cusLongitude" : long,
                        "merchantList" : merList]
        print("value11 \(value1)")
        self.reqParaGetEstimateTime = value1
        /*
        let  value1  = ["cusLatitude" : "13.739852" ,
                        "cusLatitude" : "100.530840"] as [String : Any]
        */
        
        
       // let configuration = URLSessionConfiguration.default
      //  configuration.timeoutIntervalForRequest = 10800 // seconds
      //  configuration.timeoutIntervalForResource = 10800
      //  let alamoFireManager = Alamofire.SessionManager(configuration: configuration)
       /* let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 240
        manager.session.configuration.timeoutIntervalForResource = 240*/
        

        
        var request = URLRequest(url: NSURL.init(string: BASEURL+GETESTIMATEDTIME)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 240
        request.httpBody = try! JSONSerialization.data(withJSONObject: value1, options: [])
        Alamofire.request(request ).responseJSON {
            response in
       // manager.request(BASEURL+GETESTIMATEDTIME,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
         //   .responseJSON { response in
                print("response \(response)")
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        print("example success")
                        //to get JSON return value
                        if let result = response.result.value {
                            print(result)
                            let JSON = result as! NSDictionary
                            GlobalVariables.sharedManager.estimatedTime = Double.init((JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: "estimatedTime") as! String)!
                            // Define identifier
                            let notificationName = Notification.Name("getEstimatedTime")
                            NotificationCenter.default.post(name: notificationName, object: nil)
                            

                        }
                    default:
                        print("error with response status: \(status)")
                    }
                }
        }
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as? ConfirmOrderViewController {
            if let navigator = self.navigationController {
                navigator.pushViewController(viewController, animated: true)
                //viewController.estimatedTime = Double.init(estimatedTime)!
                viewController.distance = self.totalDistance
                viewController.foodPrice = self.totalPrice
                viewController.deliveryPrice = self.totalDeliverPrice
                viewController.reqParaGetEstimateTime = self.reqParaGetEstimateTime
            }
        }
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

extension BasketViewController:UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("basArr.count \(basArr.count)")
        return basArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (basArr.count > 0) {
            if (self.tableView.sectionOpen != NSNotFound && section == self.tableView.sectionOpen) {
                
                return  ((basArr.object(at: section) as! NSDictionary).object(forKey: "order") as! NSArray).count + 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("index \(indexPath.section) \(indexPath.row)")
        let orderList = ((basArr.object(at: indexPath.section) as! NSDictionary).object(forKey: "order") as! NSArray)
        print("orderList \(orderList)")
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
        headerView.section = section
        headerView.backgroundColor = UIColor.white
        let header = (basArr.object(at: section) as! NSDictionary).object(forKey: "merName") as! String
        
        headerView.merNameLbl.text = header
        //  headerView.addSubview(label)
        var imageView = UIImageView.init(frame: CGRect(x: 5, y: 5, width: headerView.frame.height - 10, height: headerView.frame.height - 10))
        imageView.image = UIImage(named: "image-not-found")
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        
        
        // line
        var line = UIView.init(frame: CGRect(x: 0, y: headerView.frame.height - 2, width: headerView.frame.width, height: 1.0))
        line.backgroundColor = UIColor.lightGray
        headerView.addSubview(line)
        var view = UIView.init(frame: CGRect(x: 0 , y: 0, width: headerView.frame.width, height: headerView.frame.height))
        view.addSubview(headerView)
        var deleteButton = UIButton.init(frame: CGRect(x: headerView.frame.width - 30 , y: 0, width: 30, height: 30))
        deleteButton.setImage(UIImage(named: "multiply_filled"), for: UIControlState.normal)

        deleteButton.addTarget(self, action: #selector(BasketViewController.removeMerchantFromBasket(_:)), for: UIControlEvents.touchUpInside)
        deleteButton.tag = section
        deleteButton.contentMode = .scaleAspectFit
        view.addSubview(deleteButton)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // removeItemFromBasket(index: indexPath)
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let orderList = ((basArr.object(at: indexPath.section) as! NSDictionary).object(forKey: "order") as! NSArray)
        if indexPath.row == (orderList.count + 1) {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Alert", message: "ต้องการลบเมนูหรือไม่", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ยืนยัน", style: .default, handler: { action in
                self.removeItemFromBasket(index: indexPath)
            }))
            
            alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    func removeItemFromBasket(index : IndexPath){
        var selectedMer = NSDictionary()
        print("")
        let orderList = ((basArr.object(at: index.section) as! NSDictionary).object(forKey: "order") as! NSArray)
        let selectedOrder = orderList.object(at: index.row - 1) as! NSDictionary
        if GlobalVariables.sharedManager.basket.object(forKey: "merchant") != nil {
            for mer in GlobalVariables.sharedManager.basket.object(forKey: "merchant") as! NSMutableArray {
                let orders = (mer as! NSDictionary).object(forKey: "order") as! NSMutableArray
                for order in orders as! NSArray {
                    if (order as! NSDictionary).isEqual(to: selectedOrder as! [AnyHashable : Any]) {
                        if orders.count == 1 {
                            (GlobalVariables.sharedManager.basket.object(forKey: "merchant") as! NSMutableArray).remove(mer)
                            
                        }else{
                            orders.remove(order)
                        }
                        GlobalVariables.sharedManager.numOfBasket = GlobalVariables.sharedManager.numOfBasket -  ((order as! NSDictionary).object(forKey: "orderDetailAmount") as! Int)
                        print("GlobalVariables.sharedManager.basket \(GlobalVariables.sharedManager.basket)")
                        self.prepareBasketData()
                        self.calculatePrice()
                        self.tableView.sectionOpen = NSNotFound
                        self.refreshBasketNumber()
                        break;
                    }
                }
            }
        }
        
    }
    
    func removeMerchantFromBasket(_ sender : UIButton){
        let alert = UIAlertController(title: "Alert", message: "ต้องการลบเมนูหรือไม่", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ยืนยัน", style: .default, handler: { action in
            var amountDeletedOrder = 0
            let section = sender.tag
            print("section \(section)")
            let merOrders = (self.basArr.object(at:section) as! NSDictionary)
            if (GlobalVariables.sharedManager.basket.object(forKey: "merchant") as! NSMutableArray).count == 1 {
                GlobalVariables.sharedManager.basket = NSDictionary()
                
            }else{
            for mer in GlobalVariables.sharedManager.basket.object(forKey: "merchant") as! NSMutableArray {
                if merOrders.isEqual(to: mer as! [AnyHashable : Any]) {
                    let orders = (mer as! NSDictionary).object(forKey: "order") as! NSMutableArray
                    for order in orders as! NSArray {
                        amountDeletedOrder = amountDeletedOrder + ((order as! NSDictionary).object(forKey: "orderDetailAmount") as! Int)
                    }
                    (GlobalVariables.sharedManager.basket.object(forKey: "merchant") as! NSMutableArray).remove(mer)
                    GlobalVariables.sharedManager.numOfBasket = GlobalVariables.sharedManager.numOfBasket - amountDeletedOrder
                    print("GlobalVariables.sharedManager.basket \(GlobalVariables.sharedManager.basket)")
                    self.prepareBasketData()
                    self.calculatePrice()
                    self.tableView.sectionOpen = NSNotFound
                    self.refreshBasketNumber()
                    break;
                }
            }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)


    }
    
}
