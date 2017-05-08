//
//  ConfirmOrderViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 3/19/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import NVActivityIndicatorView

class ConfirmOrderViewController: BaseViewController, GMSMapViewDelegate , NVActivityIndicatorViewable {
    @IBOutlet weak var estimateLbl:UILabel!
    @IBOutlet weak var addressTxt:UITextView!
    @IBOutlet weak var mapView:GMSMapView!
    @IBOutlet weak var priceLbl:UILabel!
    @IBOutlet weak var load:UIView!
    @IBOutlet weak var countLbl:UILabel!
    @IBOutlet weak var countMsgLbl:UILabel!
    @IBOutlet weak var cashBtn:UIButton!
    @IBOutlet weak var creditBtn:UIButton!
    @IBOutlet weak var addressView:UIView!
    var activityIndicatorView:NVActivityIndicatorView? = nil
    
    var count = RECALTIME
    var price = 0.0
    var foodPrice = 0.0
    var deliveryPrice = 0.0
    var distance = 0.0
    var reqParaGetEstimateTime:[String:Any] = [:]
    var estimatedTime = 0.0
    var estimatedDateTime = ""
    var isStop = false
    var isCash = true
    
    func methodOfReceivedNotification(){
        print("Received")
        estimatedTime = GlobalVariables.sharedManager.estimatedTime
        self.initialTime()
        self.countLbl.isHidden = false
        self.estimateLbl.isHidden = false
        self.countMsgLbl.isHidden = false

        
        var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ConfirmOrderViewController.update), userInfo: nil, repeats: true)
        if let loadView = activityIndicatorView {
            loadView.stopAnimating()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ยืนยันการชำระเงิน"
        self.intialValue()
        self.countLbl.isHidden = true
        self.estimateLbl.isHidden = true
        self.countMsgLbl.isHidden = true
        self.addLoading()
        if let loadView = activityIndicatorView {
            loadView.startAnimating()
        }
      //  self.addressTxt.layer.borderColor = UIColor.darkGray as! CGColor
      //  self.addressTxt.layer.borderWidth = 1.0
      //  self.addressTxt.layer.cornerRadius = 5
      //  self.addressTxt.backgroundColor = UIColor.clear
        // var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ConfirmOrderViewController.update), userInfo: nil, repeats: true)
       // var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ConfirmOrderViewController.update), userInfo: nil, repeats: true)
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmOrderViewController.methodOfReceivedNotification), name: NSNotification.Name(rawValue: "getEstimatedTime"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func update() {
        
        if(count > 0){
            let minutes = String(count / 60)
            var seconds = String(count % 60)
            if seconds.characters.count == 1 {
                seconds = "0"+seconds
            }
            countLbl.text = minutes + ":" + seconds
            count -= 1
        }
        if count == 0 && !isStop {
            self.recalEstimateTime()
            self.countLbl.text = "0.00"
            self.isStop = true
            self.estimateLbl.isHidden = true
        }
        
    }
    
    func recalEstimateTime(){
        activityIndicatorView!.startAnimating()
        var request = URLRequest(url: NSURL.init(string: BASEURL+GETESTIMATEDTIME)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 240
        request.httpBody = try! JSONSerialization.data(withJSONObject: reqParaGetEstimateTime, options: [])
        Alamofire.request(request ).responseJSON {
            response in
        /*Alamofire.request(BASEURL+GETESTIMATEDTIME,method: .post, parameters: reqParaGetEstimateTime, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
         */       if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                        //to get JSON return value
                        if let result = response.result.value {
                            print(result)
                            let JSON = result as! NSDictionary
                            let est = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: "estimatedTime") as! String
                            self.estimatedTime = Double.init(est)!
                            self.initialTime()
                            self.estimateLbl.isHidden = false
                            self.count = RECALTIME
                            self.isStop = false
                            self.activityIndicatorView!.stopAnimating()
                        }
                    default:
                        print("error with response status: \(status)")
                    }
                }
        }

    }
    
    func initialTime(){
        let comps = NSDateComponents()
        
        comps.minute = Int(estimatedTime)
        
        let cal = NSCalendar.current
        
        let r = cal.date(byAdding: comps as DateComponents, to: NSDate() as Date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        dateFormatter.locale = NSLocale.current
        // dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        let str = dateFormatter.string(from: r!)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        dateFormatter1.locale = NSLocale.current
        estimatedDateTime = dateFormatter1.string(from: r!)
        
        print("Time \(str)")
        self.estimateLbl.text = "\(str) น."
    }
    
    func intialValue(){
        self.initialTime()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        if let location = GlobalVariables.sharedManager.selectedLocation {
            let marker = GMSMarker(position: location)
            marker.map = mapView
            let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
            self.mapView.camera = GMSCameraPosition(target: loc.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
        }else{
            let loc = CLLocation(latitude: (GlobalVariables.sharedManager.currentLocation?.latitude)!, longitude: (GlobalVariables.sharedManager.currentLocation?.longitude)!)
            self.mapView.camera = GMSCameraPosition(target: loc.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            let marker = GMSMarker(position: GlobalVariables.sharedManager.currentLocation!)
            marker.map = mapView
        }
        
        print("GlobalVariables.sharedManager.selectedAddress '\(GlobalVariables.sharedManager.selectedAddress)'")
        if GlobalVariables.sharedManager.selectedAddress == "" {
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(GlobalVariables.sharedManager.currentLocation!) { response , error in
                if let address = response?.firstResult() {
                    GlobalVariables.sharedManager.selectedAddress = "\(address.thoroughfare!) \(address.locality!) \(address.subLocality!)"
                    self.addressTxt.text = GlobalVariables.sharedManager.selectedAddress
                    
                    
                }
            }
        }else{
            self.addressTxt.text = GlobalVariables.sharedManager.selectedAddress
        }
        self.priceLbl.text = String(format:"%.2f",foodPrice+deliveryPrice)
    }
    func addLoading(){
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: 29)!)
        activityIndicatorView!.padding = 10
        activityIndicatorView!.color = UIColor.white
        activityIndicatorView!.backgroundColor = UIColor.clear
        self.load.addSubview(activityIndicatorView!)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedConfirmOrder(_ sender : UIButton){
        let basArr = GlobalVariables.sharedManager.basket
        let defaults = UserDefaults.standard
        let cusId = defaults.object(forKey: CUSID_KEY)
        defaults.object(forKey: DELIVERYRATE_KEY)
        
        
        
        var lat = "13.739852"
        var long = "100.530840"
        if GlobalVariables.sharedManager.selectedLocation != nil {
            lat = "\(GlobalVariables.sharedManager.selectedLocation!.latitude)"
            long =  "\(GlobalVariables.sharedManager.selectedLocation!.longitude)"
        }else{
            
            lat = "\(GlobalVariables.sharedManager.currentLocation!.latitude)"
            long =  "\(GlobalVariables.sharedManager.currentLocation!.longitude)"
        }
        let allOrder = ["orderAddress":GlobalVariables.sharedManager.selectedAddress,
                        "orderAddressLatitude": lat,
                        "orderAddressLongitude": long,
                        "orderTotalPrice": deliveryPrice+foodPrice,
                        "orderDeliveryPrice":deliveryPrice,
                        "orderFoodPrice":foodPrice,
                        "orderDistance":distance,
                        "orderEstimateTime" : estimatedTime,
                        "orderEstimateDateTime" : estimatedDateTime,
                        "merchant":basArr.object(forKey: "merchant")] as [String : Any]
        let  value1:[String:Any]  = ["cusId" : cusId!,
                                     "allOrder" : allOrder]
        print("value11 \(value1)")
        /*
         let  value1  = ["cusLatitude" : "13.739852" ,
         "cusLatitude" : "100.530840"] as [String : Any]
         */
    
        
        Alamofire.request(BASEURL+INSERTMENU,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print("response \(response)")
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        print("example success")
                        //to get JSON return value
                        if let result = response.result.value {
                            print(result)
                            let JSON = result as! NSDictionary
                            let confirmCode = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: "orderConfirmCode") as! String
                            let orderNo = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: "orderNo") as! NSNumber
                            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderStatusViewController") as? OrderStatusViewController {
                                if let navigator = self.navigationController {
                                    navigator.pushViewController(viewController, animated: true)
                                    viewController.confirmOrder = "\(confirmCode)"
                                    let comps = NSDateComponents()
                                    
                                    comps.minute = Int(self.estimatedTime)
                                    
                                    let cal = NSCalendar.current
                                    
                                    let r = cal.date(byAdding: comps as DateComponents, to: NSDate() as Date)
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "HH:mm"
                                    
                                    dateFormatter.locale = NSLocale.current
                                    // dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
                                    let str = dateFormatter.string(from: r!)
                                    viewController.estimateTime = str
                                }
                            }
                        }
                    default:
                        print("error with response status: \(status)")
                    }
                }
        }
    }
    @IBAction func clickedInfo(){
        // เวลาที่แสดงเป็นเวลาจากการประมาณ อาจช้าหรือเร็วกว่าที่แจ้งไม่เกินครึ่งชั่วโมง
        let alert = UIAlertController(title: "คำเตือน", message: "เวลาที่แสดงเป็นเวลาจากการประมาณ อาจช้าหรือเร็วกว่าที่แจ้งไม่เกินครึ่งชั่วโมง", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clickedCashButton(){
        if !isCash {
            self.cashBtn.setImage(UIImage(named: "checked_filled"), for: UIControlState.normal)
            self.creditBtn.setImage(UIImage(named: "active_state_filled"), for: UIControlState.normal)
            self.isCash = true
        }
    }
    
    @IBAction func clickedCreditButton(){
        if isCash {
            self.cashBtn.setImage(UIImage(named: "active_state_filled"), for: UIControlState.normal)
            self.creditBtn.setImage(UIImage(named: "checked_filled"), for: UIControlState.normal)
            self.isCash = false
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
