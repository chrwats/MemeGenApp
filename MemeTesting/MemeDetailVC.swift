//
//  MemeDetailVC.swift
//  MemeTesting
//
//  Created by CHRISTOPHER WATSON on 08/6/15.
//  Copyright (c) 2015 CWatson. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailVC: UIViewController {
    
    var meme: Meme!
    @IBOutlet weak var imageViewCell: UIImageView!
    
    // Get the Index of the selected Meme from Table or Collection view
    var memeIndex: Int?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageViewCell!.image = meme.memedImage
//        var image = meme.image
//        var top = meme.top
//        var bottom = meme.bottom
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Delete", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteButton")
    }
    
    // Delete A Meme function
    func deleteADetailedMeme() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(memeIndex!)
        imageViewCell!.image = nil
    }
    
    //TODO: Add in the edit functionality
    func deleteButton() {
        let alertController = UIAlertController(title: "Delete", message: "Delete this Meme?", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
//        //not quite sure yet how to get the original image and text back into the edit view controller, so leaving the edit function out for now
//        let OKAction = UIAlertAction(title: "Edit", style: .Default) { (action) in
//            var controller: MemeEditorVC
//        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[self.memeIndex!]
//            dump(meme)
//            controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorVC
//          
        //this is throwing an optional nil error
//            controller.imageView.image = self.meme.image
//            controller.topTextField.text = self.meme.top
//            controller.bottomTextField.text = self.meme.bottom
//            
//            println(controller.topTextField.text)
//            println(controller.bottomTextField.text)
//
//            //present new VC
//            self.presentViewController(controller, animated: true, completion: nil)
//        }
//        alertController.addAction(OKAction)

        let destroyAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            self.deleteADetailedMeme()
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(destroyAction)
        
        presentViewController(alertController, animated: true) {
            // ...
        }
    
    }
    func segueToMemeEditorWithDeletion() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorVC
        presentViewController(controller, animated: true)
            {(action) in self.deleteADetailedMeme()}
    }
    
   

    
    
}