//
//  Customer.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 4/10/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation

class Customer {
    var cusId = ""
    var cusName = ""
    var cusUsername = ""
    var cusContactNumber = ""
    
    init(cusId : String, cusName : String, cusUsername:String, cusContactNumber:String){
        self.cusId = cusId
        self.cusName = cusName
        self.cusUsername = cusUsername
        self.cusContactNumber = cusContactNumber
    }
}
