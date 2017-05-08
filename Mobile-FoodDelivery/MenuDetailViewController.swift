//
//  MenuDetailViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/19/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import Alamofire

class MenuDetailViewController: BaseViewController, OptionDelegate {
    @IBOutlet weak var sumPriceLbl : UILabel!
    @IBOutlet weak var unitTxt:UITextField!
    @IBOutlet weak var remarkTxtField:UITextField!
    @IBOutlet weak var optionTbv:UITableView!
    
    var merName = ""
    var mer = Merchant()//NSDictionary()
    var menu = NSDictionary()
    var optionList = NSArray()
    var num = 1
    var sumPrice = 0.0
    let selectedOpts = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        //self.addBasketAndPinMenuButton()
        self.optionTbv.delegate = self
        // Do any additional setup after loading the view.
        self.title = menu.object(forKey: "menuName") as! String?
        var frameRect = remarkTxtField.frame;
        frameRect.size.height = 53;
        self.unitTxt.text = "\(num)"
        self.remarkTxtField.frame = frameRect;
        self.remarkTxtField.placeholder = "หมายเหตุ\r\n\r\n"
        self.optionTbv.delegate = self
        self.sumPrice = (menu.object(forKey: "menuPrice") as! Double) * Double.init(num)
        self.sumPriceLbl.text = NSString(format: "%.2f", sumPrice) as String

        if menu.object(forKey: "opt_menuList") != nil {
            optionList = menu.object(forKey: "opt_menuList") as! NSArray
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addBasketAndPinMenuButton()
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func clickedIncreaseItem(){
        if num < MAXORDER {
            num = num + 1
            self.unitTxt.text = "\(num)"
            calPrice()
            self.sumPriceLbl.text = NSString(format: "%.2f", sumPrice) as String
        }
        
    }
    
    @IBAction func clickedDecreaseItem(){
        if num > MINORDER {
            num = num - 1
            self.unitTxt.text = "\(num)"
           calPrice()
            self.sumPriceLbl.text = NSString(format: "%.2f", sumPrice) as String
        }
    }
    
    func clickedSelectItem(selectedOpt opt: NSDictionary, isAdded: Bool) {
        if isAdded {
            selectedOpts.add(opt)
            let optPrice = opt.object(forKey: "optionPrice") as! Double
            print("\(optPrice)")
          //  self.sumPrice = self.sumPrice + (optPrice * Double.init(num))
            calPrice()
        }else {
            selectedOpts.remove(opt)
           // let optPrice = opt.object(forKey: "option_price") as! Double
           // self.sumPrice = self.sumPrice - (optPrice * Double.init(num))
            let optPrice = opt.object(forKey: "optionPrice") as! Double
            print("\(optPrice)")
            calPrice()
        }
        self.sumPriceLbl.text = NSString(format: "%.2f", sumPrice) as String
    }
    
    func calPrice(){
        var sumPriceOpt = 0.0
        print("count \(selectedOpts.count)")
        for obj in selectedOpts {
            sumPriceOpt = sumPriceOpt + ((obj as! NSDictionary).object(forKey: "optionPrice") as! Double)
        }
        print("Total : \(sumPriceOpt)")
        self.sumPrice = (menu.object(forKey: "menuPrice") as! Double + sumPriceOpt) * Double.init(num)
    }
    
    @IBAction func clickedAddToBasket(){
        var order = NSDictionary()
        
        GlobalVariables.sharedManager.numOfBasket = GlobalVariables.sharedManager.numOfBasket + num
        self.refreshBasketNumber()
        let orderListTmp = NSMutableArray()
        var orderTmp = NSDictionary()
        var optList:[Int] = []
        
        
        orderTmp = [ "menuId" : menu.object(forKey: "menuId") as! Int,
            "menuName": menu.object(forKey: "menuName") as! String,
            "orderDetailAmount" : num,
            "menuPrice":self.sumPrice,
            "remark" : self.remarkTxtField.text,
            "option" : selectedOpts
            
        ]
        print("orderTmp \(orderTmp)")
        orderListTmp.add(orderTmp)
        var isExist = false
        
        var selectedMer = NSDictionary()
        if GlobalVariables.sharedManager.basket.object(forKey: "merchant") != nil {
            for mer1 in GlobalVariables.sharedManager.basket.object(forKey: "merchant") as! NSArray {
                let search = (mer1 as! NSDictionary).object(forKey: "merId") as! Int
                let curMerId = mer.merID//self.mer.object(forKey: "merID") as! Int
                print("\(search), \(curMerId)")
                if search == curMerId {
                    print("equal")
                    selectedMer = mer1 as! NSDictionary
                    isExist = true
                    break;
                }
            }
        }
        
        if !isExist {
            self.newMerchant(orderListTmp: orderListTmp)
        }else{
            (selectedMer.object(forKey: "order") as! NSMutableArray).add(orderTmp)
            
            print("selectedMer \(selectedMer)")
            
            print("basket \(GlobalVariables.sharedManager.basket)")
        }
        
        
        print("orderListTmp \(orderListTmp)")
    }
    
    func newMerchant(orderListTmp: NSMutableArray)  {
        print("getDistance")
        var lat = "13.739852"
        var long = "100.530840"
        var distance = "0.00"
        if GlobalVariables.sharedManager.selectedLocation != nil {
            lat = "\(GlobalVariables.sharedManager.selectedLocation!.latitude)"
            long =  "\(GlobalVariables.sharedManager.selectedLocation!.longitude)"
        }else{
            
            lat = "\(GlobalVariables.sharedManager.currentLocation!.latitude)"
            long =  "\(GlobalVariables.sharedManager.currentLocation!.longitude)"
        }
        let value1 = [ "oriLat" : lat,
                       "oriLng" : long,
                       "desLat" : mer.merLatitude,
                       "desLng" : mer.merLongtitude]
        print(value1)
        print("merId \(mer.merID)")
        Alamofire.request(BASETESTURL+DISTANCEMATRIX,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print("reponse \(response)")
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        print("getDistance example success")
                        //to get JSON return value
                        if let result = response.result.value {
                            print(result)
                            let JSON = result as! NSDictionary
                            distance = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: "distance") as! String
                            var arr = NSMutableArray()
                            var basket :NSDictionary = [ "merId" : self.mer.merID,
                                                         "merLatitude" : self.mer.merLatitude,
                                                         "merLongitude" : self.mer.merLongtitude,
                                                         "merName" : self.mer.merName,
                                                         "merDistance" : distance,
                                                         "order" : orderListTmp]
                            if GlobalVariables.sharedManager.basket.object(forKey: "merchant") != nil {
                                arr = GlobalVariables.sharedManager.basket.object(forKey: "merchant") as! NSMutableArray
                            }
                            arr.add(basket)
                            GlobalVariables.sharedManager.basket = ["merchant":arr]
                        }
                    default:
                        print("error with response status: \(status)")
                        
                    }
                }
        }

    }

}
extension MenuDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionViewCell") as! OptionTableViewCell
        let opt = optionList.object(at: indexPath.row) as! NSDictionary
        cell.optionNameLabel.text = opt.object(forKey: "optionName") as? String
        cell.priceOptLabel.text = NSString(format: "%.2f",opt.object(forKey: "optionPrice") as! Double) as String

        cell.option = opt
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
