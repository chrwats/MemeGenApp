//
//  MemeCollectionVC.swift
//  MemeTesting
//
//  Created by CHRISTOPHER WATSON on 08/6/15.
//  Copyright (c) 2015 CWatson. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
{
    var memes: [Meme]!

    let cellReuseIdentifier = "MemeCollectionReuseIdentifier"
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let memeCellTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 14)!,
        NSStrokeWidthAttributeName: NSNumber(float: -3.0)
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //backgroundColor = UIColor.clearColor()
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count == 0 {
            let storyboard = self.storyboard
            let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC") as! UIViewController
            presentViewController(vc, animated: true, completion: nil)
        }
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (3 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    override func viewWillAppear(animated: Bool) {
        collectionView?.reloadData()

    }
    
    @IBAction func AddMemeButton(sender: AnyObject) {
        let storyboard = self.storyboard
        let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC") as! UIViewController
        presentViewController(vc, animated: true, completion: nil)

    }
    
    // Get the collection view's cells count
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    // Return the Cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! MemeCustomCollectionCell
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.item]
        cell.memedImage.image = meme.image
        cell.top.text = meme.top
        cell.bottom.text = meme.bottom
        cell.top.defaultTextAttributes = memeCellTextAttributes
        cell.bottom.defaultTextAttributes = memeCellTextAttributes
        cell.top.textAlignment = .Center
        cell.bottom.textAlignment = .Center
        let imageView = UIImageView(image: meme.image)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        // Show the selected meme in a large scaled view called MemeDetailsViewController
        let memeDetailsController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailVC
       
        memeDetailsController.hidesBottomBarWhenPushed = true
        memeDetailsController.meme = memes[indexPath.item]
        memeDetailsController.memeIndex = indexPath.item
        navigationController!.pushViewController(memeDetailsController, animated: true)    }
   
}


