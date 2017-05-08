//
//  Option.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/1/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation

class Option : NSObject{
    var option_id = 0
    var option_neme = ""
    var option_price = 0.0
    
    init(json:NSDictionary){
        self.option_id = json["optionId"] as! Int
        self.option_neme = json["optionNeme"] as! String
        self.option_price = json["optionPrice"] as! Double
    }
}

