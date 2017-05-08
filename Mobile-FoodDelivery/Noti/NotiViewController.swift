//
//  NotiViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/5/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import Alamofire

class NotiViewController: BaseViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    var notiList:[Noti] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getNotiList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNotiList(){
        let defaults = UserDefaults.standard
        let cusId = defaults.value(forKey: CUSID_KEY) as! String
        
        
        let  value  = ["noti_type" : NOTI_TYPE_CUS ,
                       "noti_ref_id" : Int64.init(cusId)] as [String : Any]
        
        Alamofire.request(BASEURL+GETNOTILIST,method: .post, parameters: value, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print("Response \(response)")
                if let jsonResult = response.result.value {
                    do {
                        if ((jsonResult as AnyObject).object(forKey: DATA_KEY) != nil) {
                            let dataDicts = (jsonResult as AnyObject).object(forKey: DATA_KEY) as! NSArray
                            
                            self.initValue(dataDicts: dataDicts)
                            self.tableView.reloadData()
                            
                        }
                    } catch let error {
                        print("error")
                    }
                }
        }
        
    }
    
    func initValue(dataDicts:NSArray){
        for notiDict in dataDicts {
            let noti = Noti(json: notiDict as! NSDictionary)
            notiList.append(noti)
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

extension NotiViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "notiTableViewCell", for: indexPath) as! NotiTableViewCell
        let noti = notiList[indexPath.row]
        cell.dateLbl.text = noti.noti_created_date.convertDateTime()
        cell.titleLbl.text = "แจ้งเตือนออร์เดอร์รหัส \(noti.noti_order_id)"
        cell.detailLabel.text = noti.noti_message_detail
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotiDetailViewController") as? NotiDetailViewController {
            if let navigator = navigationController {
                viewController.noti = notiList[index]
                navigator.pushViewController(viewController, animated: true)
            }
        }
        Alamofire.request(BASEURL+READNOTI+"\(notiList[index].noti_id)").responseJSON{ response in
            if let JSON = response.result.value {
                print("JSON \(JSON)")
                
            }
        }
        
    }
}
