//
//  HistoryOrderViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 4/10/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class HistoryOrderViewController: UIViewController {
    @IBOutlet weak var historyTbv:UITableView!
    
    var historyList:NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTbv.delegate = self
        // Do any additional setup after loading the view.
        if self.historyList == nil || self.historyList?.count == 0 {
            self.historyTbv.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension HistoryOrderViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        return cell
    }
}
