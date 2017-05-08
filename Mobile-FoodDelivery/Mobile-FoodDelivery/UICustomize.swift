//
//  UICustomize.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/11/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    func setButton() {
        //White Border
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.layer.bounds
      //  borderLayer.strokeColor = UIColor.green.cgColor
        borderLayer.fillColor = UIColor(red: 120/255, green: 144/255, blue: 156/255, alpha: 1).cgColor
        borderLayer.lineWidth = 10.5
        
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: UIRectCorner.allCorners,
                                cornerRadii: CGSize(width: 5, height: 5))
        borderLayer.path = path.cgPath
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.layer.addSublayer(borderLayer)
    }
}
