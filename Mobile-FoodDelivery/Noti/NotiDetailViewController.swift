//
//  NotiDetailViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/5/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class NotiDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var detailTxt : UITextView!
    var noti = Noti()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "แจ้งเตือนออร์เดอร์รหัส \(noti.noti_order_id)"
        self.dateLbl.text = noti.noti_created_date.convertDateTime()
        self.detailTxt.text = noti.noti_message_detail
        // Do any additional setup after loading the view.
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
    
}
