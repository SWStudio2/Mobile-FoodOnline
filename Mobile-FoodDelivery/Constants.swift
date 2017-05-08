//
//  Constants.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/11/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
///Users/kewalins/Documents/IBMSD/Server/apache-tomcat-8.0.29

import Foundation
import UIKit

//class CONSTANTS {
    //Color
    let GRAY:UIColor = UIColor(red: 120/255, green: 144/255, blue: 156/255, alpha: 1)

    let header = ["Accept" : "application/json" , "Content-Type" : "application/json"]

    //  Segue
    let LOGINSUCCESS_SEGUE = "loginSuccessSegue"
    //let BASEURL = "https://fooddelivery-test.eu-gb.mybluemix.net/service/"
    let BASEURL = "http://127.0.0.1:8082/fooddelivery-0.8/service/"
    let BASETESTURL = "https://fooddelivery.eu-gb.mybluemix.net/service/"
    let BASEYUIURL = "https://b3d2039c.ngrok.io/service/"
    let DISTANCEMATRIX = "getdistancematrix"
    let AUTH = "customer/auth"
    let GETALL_MER = "merchant/getall"
    let GETESTIMATEDTIME = "getestimatedtime"
    let GETMENU = "merchant/"
    let INSERTMENU = "orders/inserorders"
    let STATUS = "status"
    let DELIVERYRATE_KEY = "delivery_rate"
    let CURRENTORDER = "orders/getOrderDetail"
    let GETORDER = "orders/getorder"
    let REGIS = "customer/regis"
    let GETNOTILIST = "orders/noti"
    let CHECKCURRENT = "orders/verifycurrent/"
    let READNOTI = "orders/noti/accept/"

    let DATA_KEY = "data"
    let CUS_KEY = "cus"
    let CUSID_KEY = "cus_id"
    let CUSNAME_KEY = "cus_name"
    let CUSCONTACT_KEY = "cus_contact_number"
    let CUSUSERNAME_KEY = "cus_username"

    let NOTI_TYPE_CUS = "Customer"
    let Y_FLAG = "Y"
    let N_FLAG = "N"

    let RECALTIME = 180

    let MINORDER = 1
    let MAXORDER = 20

    let MENUNAME = ["กลับสู่หน้าหลัก","ติดตามผลการสั่งอาหาร","แก้ไขข้อมูลส่วนตัว","ประวัติการสั่งอาหาร","ออกจากระบบ"]

    let STATUS_1 = "กำลังรอรับการตอบรับจากร้านค้า"
    let STATUS_2 = "กำลังทำอาหาร"
    let STATUS_3 = "กำลังส่งอาหาร"
    let STATUS_4 = "ส่งอาหารแล้ว"

let ORDER_WAITING_RESPONSE_STATUS 	= 1;//"รอรับออร์เดอร์";
let ORDER_COOKING_STATUS 				= 2; //กำลังทำอาหาร
let ORDER_DELIVERING_STATUS 			= 3; //กำลังส่งอาหาร
let ORDER_RECEIVED_STATUS 			= 4; //ส่งอาหารแล้ว

let MESSENGER_WAITING_CONFIRM_STATUS 	= 5; //รอการคอนเฟิร์ม
let MESSENGER_RECEIVING_STATUS 		= 6; //กำลังไปรับอาหาร
let MESSENGER_IGNORE_STATUS 			= 7; //ไม่ทำ
let MESSENGER_DELIVERING_STATUS		= 8; //กำลังไปส่งอาหาร
let MESSENGER_DELIVERIED_STATUS		= 9; //ส่งอาหารแล้ว
let MESSENGER_STATION_STATUS			= 10; //อยู่ที่จุดจอด

let MERCHANT_WAITING_CONFIRM_STATUS	= 11; // รอการคอนเฟิร๋ม
let MERCHANT_CONFIRMED_STATUS			= 12; //คอนเฟิร์มแล้ว
let MERCHANT_IGNORE_STATUS			= 13; //ไม่ทำ
let MERCHANT_RECEIVED_STATUS			= 14; //รับอาหารแล้ว
let ORDER_CANCELLED_STATUS 			= 15;
//}

