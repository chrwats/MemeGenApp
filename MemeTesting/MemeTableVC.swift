//
//  MemeTableVC.swift
//  MemeTesting
//
//  Created by CHRISTOPHER WATSON on 08/6/15.
//  Copyright (c) 2015 CWatson. All rights reserved.
//

import Foundation
import UIKit

var memes: [Meme]!

class MemeTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    
let cellReuseIdentifier = "TableViewReuseIdentifier"


    var memes: [Meme]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()

    }
    override func viewDidAppear(animated: Bool) {
        if((UIApplication.sharedApplication().delegate as! AppDelegate).memes.count<=0){
            self.performSegueWithIdentifier("memeEditorSeque", sender: nil)
        }
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        let sentMeme = memes[indexPath.row]
        cell.imageView?.image = sentMeme.memedImage
        cell.imageView?.sizeToFit()
        cell.textLabel?.text = sentMeme.top
        cell.detailTextLabel?.text = sentMeme.bottom
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailsController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailVC
        memeDetailsController.meme = memes[indexPath.row]
        
        // Pass the choosed index to the MemeDetailsViewController for deletion purpose "if requested by user"
        memeDetailsController.memeIndex = indexPath.row
        
        // To hide the bottom bar when pushed
        memeDetailsController.hidesBottomBarWhenPushed = true

        self.navigationController!.pushViewController(memeDetailsController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    @IBAction func addMemeButton(sender: AnyObject) {
        let storyboard = self.storyboard
        let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailVCSeque") {
            let memeDetailsController =
            self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailVC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("MemeDetailVC") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
    }
    }
}