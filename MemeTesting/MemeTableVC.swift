//
//  MemeTableVC.swift
//  MemeTesting
//
//  Created by CHRISTOPHER WATSON on 08/6/15.
//  Copyright (c) 2015 CWatson. All rights reserved.
//

import Foundation
import UIKit

class MemeTableVC: UITableViewController {

    
let cellReuseIdentifier = "TableViewReuseIdentifier"


    var memes: [Meme]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let object = UIApplication.sharedApplication().delegate
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        memes = applicationDelegate.memes
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as! UITableViewCell
        
        let dictionary = self.memes[indexPath.row]
        
        return cell
    }

    
    
}