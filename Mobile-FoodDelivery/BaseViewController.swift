//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import GoogleMaps

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    var label = UILabel()
    var btnBasketMenu = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Home\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("HomeViewController")
            
            break
        case 1:
            print("Current Order\n", terminator: "")
            
           self.openViewControllerBasedOnIdentifier("CurrentOrderStatusViewController")
            break
        case 3:
            print("History Order\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("HistoryOrderViewController")
            break
        case 4:
            print("Logout\n", terminator: "")
            GlobalVariables.sharedManager.basket = NSDictionary()
            GlobalVariables.sharedManager.selectedLocation = nil
            GlobalVariables.sharedManager.numOfBasket = 0
            GlobalVariables.sharedManager.estimatedTime = 0.0
            GlobalVariables.sharedManager.selectedAddress = ""
            let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeNavigationController")
            present(destViewController, animated: true, completion: nil)
            
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : HamburgerViewController = self.storyboard!.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
    
    func addBasketAndPinMenuButton(){
        // Pin Menu
        let btnPinMenu = UIButton(type: UIButtonType.system)
        btnPinMenu.setImage(UIImage(named: "location_filled"), for: UIControlState())
            
        btnPinMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnPinMenu.addTarget(self, action: #selector(BaseViewController.onPinMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let pinBarItem = UIBarButtonItem(customView: btnPinMenu)
        // Basket Menu
        btnBasketMenu = UIButton(type: UIButtonType.system)
        btnBasketMenu.setImage(UIImage(named: "ingredients_filled"), for: UIControlState())
        
        btnBasketMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnBasketMenu.addTarget(self, action: #selector(BaseViewController.onBasketMenuMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let basketBarItem = UIBarButtonItem(customView: btnBasketMenu)
        
        
        label = UILabel(frame: CGRect(x: -1, y: -4, width: 15, height: 15))
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.red//UIColor(red: 255/256, green: 134/256, blue: 84/256, alpha: 1)
        if GlobalVariables.sharedManager.numOfBasket != 0 {
            label.text = "\(GlobalVariables.sharedManager.numOfBasket)"
            label.sizeToFit()
        }else {
            label.text = ""
            label.sizeToFit()
        }
    
        /*
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.red.cgColor
        //you can change the line width
        
        btnBasketMenu.layer.addSublayer(shapeLayer)
        */
        
        btnBasketMenu.addSubview(label)
        self.navigationItem.rightBarButtonItems = [pinBarItem,basketBarItem]
    }
    
    func onPinMenuButtonPressed(_ sender : UIButton){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapPinViewController") as? MapPinViewController {
            if let navigator = navigationController {
               // viewController.mappinVCDelegate = self as! MapPinViewControllerDelegate
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    func onBasketMenuMenuButtonPressed(_ sender : UIButton){
        print("Bastet")
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasketViewController") as? BasketViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    func onBackMenuButtonPressed(_ sender : UIButton){
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func addBackButton(){
        // Pin Menu
        let btnBackMenu = UIButton(type: UIButtonType.system)
        btnBackMenu.setImage(UIImage(named: "back"), for: UIControlState())
        
        btnBackMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnBackMenu.addTarget(self, action: #selector(BaseViewController.onBackMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnBackMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func refreshBasketNumber(){
        print("refreshBasketNumber")
        if GlobalVariables.sharedManager.numOfBasket != 0 {
            label.text = "\(GlobalVariables.sharedManager.numOfBasket)"

            label.sizeToFit()

            UIView.animate(withDuration: 0.5, delay: 0.8, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                self.label.alpha = 0.0
                
            }, completion: nil)
            self.label.alpha = 1.0
        }else{
            label.text = ""
        }
        
    }
    
    func alertPopupFail(){
        let alert = UIAlertController(title: "แจ้งเตือน", message: "ขออภัยค่ะ ขณะนี้ระบบขัดข้อง กรุณาทดลองใหม่อีกครัง" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
