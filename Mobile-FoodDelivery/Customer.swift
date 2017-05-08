//
//  Customer.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/1/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation

class Customer : NSObject{
    var cus_contact_number = ""
    var cus_id = 1
    var cus_name = ""
    
    
    override init(){
        
    }
    init (json:NSDictionary){
        self.cus_id = json["cusId"] as! Int
        self.cus_contact_number = json["cusContactNumber"] as! String
        self.cus_name = json["cusName"] as! String
    }
    
}
