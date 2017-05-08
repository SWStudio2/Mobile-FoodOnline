//
//  HistoryOrderViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 4/10/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import Alamofire

class HistoryOrderViewController: BaseViewController {
    @IBOutlet weak var historyTbv:UITableView!
    
    var historyList:[Order] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        self.historyTbv.delegate = self
        // Do any additional setup after loading the view.
        self.historyTbv.isHidden = false
        self.getCurrentOrder()/*
        if self.historyList == nil || self.historyList.count == 0 {
            self.historyTbv.isHidden = true
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getCurrentOrder(){
        // let frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
        // let activityIndicatorView = NVActivityIndicatorView(frame: frame,
        //                                                    type: NVActivityIndicatorType(rawValue: 23)!)
        // activityIndicatorView.color = UIColor.orange
        // mainView.addSubview(activityIndicatorView)
        // activityIndicatorView.startAnimating()
        let defaults = UserDefaults.standard
        let cusId = defaults.value(forKey: CUSID_KEY)
        let value1 = ["cusId" : cusId, "isCurrentOrder" : "Y"]
        Alamofire.request(BASEURL+GETORDER,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        //activityIndicatorView.stopAnimating()
                        print("example success")
                        //to get JSON return value
                        if let result = response.result.value {
                            print(result)
                            let JSON = result as! NSDictionary
                            print("JSON \(JSON)")
                            let orderList = (JSON.object(forKey: DATA_KEY)) as! NSArray
                            for orderDict in orderList{
                                let order = Order(json: orderDict as! NSDictionary)
                                self.historyList.append(order)
                                
                            }
                            print("historyList \(self.historyList.count)")
                             self.historyTbv.reloadData()
                            
                        }
                    default:
                        print("error with response status: \(status)")
                    }
                }
        }
        
    }

}
extension HistoryOrderViewController:UITableViewDelegate, UITableViewDataSource {

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        cell.orderNoLbl.text = "ออร์เดอร์รหัส \(historyList[indexPath.row].order_id)"
        cell.orderDate.text = historyList[indexPath.row].order_created_datetime.convertDateTime()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryDetailViewController") as? HistoryDetailViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
                viewController.order = historyList[indexPath.row]
            }
        }
    }
}
