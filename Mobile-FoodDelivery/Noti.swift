//
//  Noti.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/1/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation


import Foundation

class Noti : NSObject {
    var noti_id = 0
    var noti_type = ""
    var noti_message_type = ""
    var noti_message_detail = ""
    var noti_read_flag = 0
    var noti_order_id = 0
    var noti_created_date = ""
    
    
    override init(){
        
    }
    
    init(json:NSDictionary){
        self.noti_id = json["noti_id"] as! Int
        self.noti_type = json["noti_type"] as! String
        self.noti_message_type = json["noti_message_type"] as! String
        self.noti_message_detail = json["noti_message_detail"] as! String
        self.noti_read_flag = json["noti_read_flag"] as! Int
        self.noti_order_id = json["noti_order_id"] as! Int
        
        self.noti_created_date = json["noti_created_date"] as! String
        
    }
}
