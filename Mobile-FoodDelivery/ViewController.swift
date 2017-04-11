//
//  ViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 1/29/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var txtUsername : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var btnLogin : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnLogin.setButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        txtUsername.text = "user1@test.com"
        txtPassword.text = "pass"
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginClicked(){
   
        let name = txtUsername.text!
        let pass =  txtPassword.text!
        let  value1  = ["email" : name ,
                        "password" : pass]
        
       Alamofire.request(BASETESTURL+AUTH,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print("Response \(response)")
                
                //to get status code
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        print("example success")
                        //to get JSON return value
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            let cusId = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: CUSID_KEY)
                            let cusContact = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: CUSCONTACT_KEY)
                            let cusName = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: CUSNAME_KEY)
                            let cusUsername = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: CUSUSERNAME_KEY)
                            let deliveryRate = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: DELIVERYRATE_KEY)
      
                             print(deliveryRate!)
                             let defaults = UserDefaults.standard
                             defaults.set(cusId,forKey: CUSID_KEY)
                             defaults.set(cusName,forKey: CUSNAME_KEY)
                             defaults.set(cusUsername,forKey: CUSUSERNAME_KEY)
                             defaults.set(cusContact,forKey: CUSCONTACT_KEY)
                             defaults.set(deliveryRate, forKey: DELIVERYRATE_KEY)
                             self.performSegue(withIdentifier: LOGINSUCCESS_SEGUE, sender: JSON)
                            print("Success")

                        }
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
        }

    }
    
    @IBAction func onLogin(){
        print("onClick")
        
        
        let name = txtUsername.text!
        let pass =  txtPassword.text!
        let  value1  = ["user" : name ,
                        "password" : pass]
        
        
        
        Alamofire.request(BASEURL+AUTH,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print("Response \(response)")
                //self.performSegue(withIdentifier: LOGINSUCCESS_SEGUE, sender: nil)
                
                if let JSON = response.result.value {
                    let json = (JSON as! NSMutableDictionary)
                    if json.object(forKey: STATUS) as! NSNumber == 200 {
                     /*   let cusId = (json.object(forKey: DATA_KEY) as! NSMutableDictionary).value(forKey: CUSID_KEY)
                        let deliveryRate = (json.object(forKey: DATA_KEY) as! NSMutableDictionary).value(forKey: DELIVERYRATE_KEY)
                        print(cusId)
                        print(deliveryRate)
                        let defaults = UserDefaults.standard
                        defaults.set(cusId,forKey: CUSID_KEY)
                        defaults.set(deliveryRate, forKey: CUSID_KEY)
                    */   self.performSegue(withIdentifier: LOGINSUCCESS_SEGUE, sender: JSON)
                        print("Success")
                    }
                    
                }
        }
        
    }

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CONSTANTS.loginSuccessSegue{
            print("prepare")
        }
    }
*/
    
}

