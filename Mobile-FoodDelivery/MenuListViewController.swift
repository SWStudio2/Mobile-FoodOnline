//
//  MenuListViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/19/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class MenuListViewController: BaseViewController {
    
    @IBOutlet weak var menuTbv:UITableView!
    //var merchantTitle:String? = ""
    var menuArr:NSArray = []
    var mer = Merchant()
    //var menuList = ["ชานม","ชานมโกโก้","ชานมเผือก","ชานมกาแฟเย็น","ชานมโกโก้","ชาเขียวบ๊วย"]
    //var priceList=["40","40","40","40","40","40"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        //self.addBasketAndPinMenuButton()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
        self.title = mer.merName//mer.object(forKey: "merName") as! String
    }
    override func viewWillAppear(_ animated: Bool) {
        self.addBasketAndPinMenuButton()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuDetailSegue" {
            
            let menuDetailVC = segue.destination as! MenuDetailViewController
            menuDetailVC.mer = mer
            menuDetailVC.menu = (sender as? NSDictionary)!
            
        }
    }

}

extension MenuListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuArr.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableVIewCell") as! MenuTableViewCell
        let row = indexPath.row
        cell.menuName.text = (menuArr.object(at: row) as! NSDictionary).object(forKey: "menuName") as! String?
        cell.menuPrice.text = NSString(format: "%.2f",(menuArr.object(at: row) as! NSDictionary).object(forKey: "menuPrice") as! Double) as String

       // cell.tickButton.tag = row
       // cell.tickButton.addTarget(self, action:#selector(MenuListViewController.tickClicked(_:)), for: .touchUpInside)
        
       // cell.tickButton.tag=1
        
       // cell.tickButton.setBackgroundImage(UIImage(named:"unchecked_checkbox.png"), for: UIControlState())
        
        return cell
        
    }
    
    /*
    func tickClicked(_ sender: UIButton!)
    {
        var value = sender.tag;
        
        if value == 1 {
            sender.setBackgroundImage(UIImage(named:"checked_2_filled.png"), for: UIControlState())
            sender.tag = 0
        }else{
            sender.setBackgroundImage(UIImage(named:"unchecked_checkbox.png"), for: UIControlState())
            sender.tag = 1

        }
        
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat
    {
        return 60.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = menuArr.object(at: indexPath.row) as! NSDictionary
        self.performSegue(withIdentifier: "menuDetailSegue", sender: dict)
    }
}
