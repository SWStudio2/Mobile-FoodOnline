//
//  Merchant.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/1/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation

import Foundation

class Merchant : NSObject {
    var merID = 1
    var cookingTime = 10
    var merAddress = ""
    var merContactNumber = ""
    var merLatitude = ""
    var merLongtitude = ""
    var merName = ""
    var merOpenStatus = ""
    var merPercentShare = 0
    var merPicName = ""
    var merRegisFlag = 0
    var merDistance = ""
    var merDuration = ""
    override init(){
        
    }
    init(json:NSDictionary){
        self.merID = json["merID"] as! Int
        self.cookingTime = json["cookingTime"] as! Int
        self.merAddress = json["merAddress"] as! String
        self.merContactNumber = json["merContactNumber"] as! String
        self.merLatitude = json["merLatitude"] as! String
        self.merLongtitude = json["merLongtitude"] as! String
        self.merID = json["merID"] as! Int
        self.merName = json["merName"] as! String
        self.merOpenStatus = json["merOpenStatus"] as! String
        //       self.merPercentShare = json["merPercentShare"] as! Int
        //       self.merPicName = json["merPicName"] as! String
        self.merRegisFlag = json["merRegisFlag"] as! Int
        
    }
}
