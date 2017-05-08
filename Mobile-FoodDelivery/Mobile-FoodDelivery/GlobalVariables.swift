//
//  GlobalVariable.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 3/18/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//
import GoogleMaps

class GlobalVariables {
    
    // These are the properties you can store in your singleton
    var selectedLocation :CLLocationCoordinate2D?
    var currentLocation :CLLocationCoordinate2D?
    var selectedAddress : String = ""
    var basket = NSDictionary()
    var estimatedTime = 0.0
    var numOfBasket = 0
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class public var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
