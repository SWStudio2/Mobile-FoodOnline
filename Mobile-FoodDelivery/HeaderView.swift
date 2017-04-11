//
//  HeaderView.swift
//  LabelTeste
//
//  Created by Rondinelli Morais on 11/09/15.
//  Copyright (c) 2015 Rondinelli Morais. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: NSObjectProtocol {
    func headerViewOpen(_ section:Int)
    func headerViewClose(_ section:Int)
}

class HeaderView: UIView {
    
    var delegate:HeaderViewDelegate?
    var section:Int?
    var tableView:UIExpandableTableView?
    var merImg = UIImageView()
    var merNameLbl = UILabel()
    
    required init(tableView:UIExpandableTableView, section:Int){
        print("Header")
        var height = tableView.delegate?.tableView!(tableView, heightForHeaderInSection: section)
        var frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: height!)
        
        super.init(frame: frame)
        
        self.tableView = tableView
        self.delegate = tableView
        self.section = section
        //self.merNameLbl.text = "Hi"
        
        merImg.frame = CGRect(x: 8, y: 8, width: 65, height: 65)
        self.addSubview(merImg)
        merNameLbl.frame = CGRect(x: 88, y: 8, width: 224, height: 65)
        self.addSubview(merNameLbl)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var toggleButton = UIButton()
        toggleButton.addTarget(self, action: "toggle:", for: UIControlEvents.touchUpInside)
        toggleButton.backgroundColor = UIColor.clear
        toggleButton.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(toggleButton)
    }
    
    func toggle(_ sender:AnyObject){

        if self.tableView!.sectionOpen != section! {
            self.delegate?.headerViewOpen(section!)
        } else if self.tableView!.sectionOpen != NSNotFound {
            self.delegate?.headerViewClose(self.tableView!.sectionOpen)
        }
    }
}
