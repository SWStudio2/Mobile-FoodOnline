//
//  RegistationViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 5/7/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import Alamofire

class RegistationViewController: UIViewController {

    @IBOutlet weak var emailTxt:UITextField!
    @IBOutlet weak var pwdTxt:UITextField!
    @IBOutlet weak var rePwdTxt:UITextField!
    @IBOutlet weak var nameTxt:UITextField!
    @IBOutlet weak var mobilenoTxt:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickedRegis(){
        if self.emailTxt.text != "" && self.pwdTxt.text != "" && self.rePwdTxt.text != ""
            && self.nameTxt.text != "" && self.mobilenoTxt.text != "" {
            if self.rePwdTxt.text == self.pwdTxt.text {
                self.regis()
            }else {
                self.validateFailurePopup(title: "ตรวจสอบข้อมูล",msg: "โปรดกรอกรหัสผ่านและยืนยันรหัสให้ถูกต้อง")
            }
            
        }else {
            self.validateFailurePopup(title: "ตรวจสอบข้อมูล" ,msg: "กรุณากรอกข้อมูลให้ครบถ้วน")
        }
    }
    
    func regis(){
        let  value  = ["cusUserName" : self.emailTxt.text ,
                        "cusPassword" : self.pwdTxt.text,
                        "cusContactNumber" : self.mobilenoTxt.text,
                        "cusName" : self.nameTxt.text,
                        
                        ]
        
        Alamofire.request(BASEURL+REGIS,method: .post, parameters: value, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print("Response \(response)")
                
                //to get status code
                if response.result.isSuccess {
                    if let status = response.response?.statusCode {
                        switch(status){
                        case 200:
                        
                            print("example success")
                        //to get JSON return value
                            if let result = response.result.value {
                                let JSON = result as! NSDictionary
                                let isPass = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: "isPass") as! String
                                let msg = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: "msg") as! String
                                self.regisResultPopup(msg: msg, isPass: isPass)
                                
                            }
                        default:
                            print("error with response status: \(status)")
                            self.regisResultPopup(msg: "ขออภัยค่ะ ระบบขัดข้อง \r\n ไม่สามารถลงทะเบียนได้ในขณะนี้ กรุณาลงทะเบียนใหม่อีกครั้ง", isPass: N_FLAG)
                        }
                    }
                }else{
                    self.regisResultPopup(msg: "ขออภัยค่ะ ระบบขัดข้อง \r\n ไม่สามารถลงทะเบียนได้ในขณะนี้ กรุณาลงทะเบียนใหม่อีกครั้ง", isPass: N_FLAG)
                }
                
                
        }

    }
    
    func validateFailurePopup(title:String, msg:String){
        let alert = UIAlertController(title: title, message: msg , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.emailTxt.text = ""
        self.pwdTxt.text = ""
        self.rePwdTxt.text = ""
        self.nameTxt.text = ""
        self.mobilenoTxt.text = ""
        
    }
    
    func regisResultPopup(msg:String, isPass:String){
        let alert = UIAlertController(title: "ผลการสมัครสมาชิก", message: msg , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.emailTxt.text = ""
        self.pwdTxt.text = ""
        self.rePwdTxt.text = ""
        self.nameTxt.text = ""
        self.mobilenoTxt.text = ""
        if isPass == Y_FLAG {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
