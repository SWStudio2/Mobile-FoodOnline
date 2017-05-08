//
//  Menu.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/1/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation
class Menu : NSObject{
    var menu_id = 0
    var menu_name = ""
    var menu_price = 0.0
    override init(){
        
    }
    init(json:NSDictionary){
        self.menu_id = json["menuId"] as! Int
        self.menu_name = json["menuName"] as! String
        self.menu_price = json["menuPrice"] as! Double
        
    }
}
