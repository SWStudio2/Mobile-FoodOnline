//
//  Order.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/1/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//


import Foundation

class Order : NSObject {
    var order_address = ""
    var order_address_latitude = ""
    var order_address_longtitude = ""
    var order_created_datetime = ""
    var order_delivery_price = 0.0
    var order_delivery_rate = 0
    var order_food_price = 0.0
    var order_id = 0
    var order_total_price = 0.0
    var seqOrders:[SeqOrder] = []
    var order_estimate_datetime = ""
    var order_status = ""
    var order_status_id = 0
    var order_confirm_code = ""
    var customer = Customer()
    
    override init (){
    }
    
    init (json:NSDictionary){
        if json["orderAddress"] != nil {
        self.order_address = json["orderAddress"] as! String
        }
        if json["orderAddressLatitude"] != nil{
            self.order_address_latitude = json["orderAddressLatitude"] as! String
        }
        if json["orderAddressLongtitude"] != nil {
        self.order_address_longtitude = json["orderAddressLongtitude"] as! String
        }
        if json["order_created_datetime"] != nil {
            self.order_created_datetime = json["order_created_datetime"] as! String
        }
        if json["orderDeliveryPrice"] != nil {
            self.order_delivery_price = json["orderDeliveryPrice"] as! Double
        }
        if json["orderDeliveryRate"] != nil {
            self.order_delivery_rate = json["orderDeliveryRate"] as! Int
        }
        if json["orderFoodPrice"] != nil {
            self.order_food_price = json["orderFoodPrice"] as! Double
        }
        if json["orderId"] != nil {
            self.order_id = json["orderId"] as! Int
        }
        if json["orderTotalPrice"] != nil {
            self.order_total_price = json["orderTotalPrice"] as! Double
        }
        if json["order_estimate_datetime"] != nil {
            self.order_estimate_datetime = json["order_estimate_datetime"] as! String
        }
        if json["statusConfig"] != nil {
            self.order_status = (json["statusConfig"] as! NSDictionary)["status_name"] as! String
        }
        if json["orderConfirmCode"] != nil {
            self.order_confirm_code = json["orderConfirmCode"] as! String
        }
        if json["orderStatus"] != nil {
            self.order_status_id = json["orderStatus"] as! Int
        }
        if json["sequenceOrders"] != nil {
            let seqOrderList = json["sequenceOrders"] as! NSArray
            for seq in seqOrderList {
                var seqOrder = SeqOrder(json: seq as! NSDictionary)
                seqOrders.append(seqOrder)
            }
        }
        
        customer = Customer(json: json["customer"] as! NSDictionary)
        
    }
}

