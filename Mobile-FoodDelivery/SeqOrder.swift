//
//  SeqOrder.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/1/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation

class SeqOrder : NSObject {
    var seqor_id = 0
    var seqor_cook_status = ""
    var seqor_cook_time = 0
    var seqor_mer_distance = 0.0
    var seqor_receive_status = ""
    var seqor_sort = 0
    var merchant = Merchant()
    var orderDetails:[OrderDetail] = []
    var seqor_cook_status_id = 0
    var seqor_receive_status_id = 0
    init (json:NSDictionary){
        self.seqor_id = json["sequenceId"] as! Int
        self.seqor_cook_status = (json["statusConfigCook"] as! NSDictionary)["status_name"] as! String
        self.seqor_cook_time = json["sequenceCookTime"] as! Int
        self.seqor_mer_distance = json["sequenceMerDistance"] as! Double
        self.seqor_receive_status = (json["statusConfigReceive"] as! NSDictionary)["status_name"] as! String
        if json["sequenceSort"] != nil {
            self.seqor_sort = Int.init((json["sequenceSort"] as! String))!
        }
        self.seqor_cook_status_id = json["sequenceCookStatus"] as! Int
        self.seqor_receive_status_id = json["sequenceReceiveStatus"] as! Int
        merchant = Merchant(json: json["merchants"] as! NSDictionary)
        //orderDetail = OrderDetail(json: json["order_detail"] as! NSMutableDictionary)
        
        let orderDetailList = json["orderDetails"] as! NSArray
        for orderDetailDict in orderDetailList {
            let orderDetail = OrderDetail(json : orderDetailDict as! NSDictionary)
            orderDetails.append(orderDetail)
        }
    }
    
}
