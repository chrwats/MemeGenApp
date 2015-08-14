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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.backgroundColor = UIColor.clearColor()
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count == 0 {
            let storyboard = self.storyboard
            let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
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
        self.presentViewController(vc, animated: true, completion: nil)

    }
    
    // Get the collection view's cells count
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    // Return the Cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! MemeCustomCollectionCell
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.item]
        cell.memedImage.image = meme.memedImage

        //cell.setText(meme.topText, bottomString: meme.bottomText)
        let imageView = UIImageView(image: meme.image)
        cell.backgroundView = imageView
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        // Show the selected meme in a large scaled view called MemeDetailsViewController
        let memeDetailsController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailVC
        memeDetailsController.hidesBottomBarWhenPushed = true
        memeDetailsController.meme = self.memes[indexPath.item]
        
        // Pass the choosed index to the MemeDetailsViewController for deletion purpose "if requested by user"
        memeDetailsController.memeIndex = indexPath.item
        self.navigationController!.pushViewController(memeDetailsController, animated: true)    }
    
    // Get the cell's size in the CollectionView Grid
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let memeDimension = self.view.frame.size.width / 4.5
//
//        return CGSizeMake(memeDimension, memeDimension)
//    }
    
    // Get the margins to apply to the items in the CollectionView
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        let leftRightInset = self.view.frame.size.width / 7.0
//        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
//    }
   
    

    
}


