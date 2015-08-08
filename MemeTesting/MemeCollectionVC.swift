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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let object = UIApplication.sharedApplication().delegate
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        memes = applicationDelegate.memes
        
        collectionView?.reloadData()

        if memes.count == 0 {
            let storyboard = self.storyboard
            let vc = storyboard!.instantiateViewControllerWithIdentifier("memeEditorVC") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }

        
    }
    
    
    // Get the collection view's cells count
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    // Return the Cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! MemeCustomCollectionCell
        
        let meme = memes[indexPath.item]
        cell.memedImage.image = meme.memedImage

        //cell.setText(meme.topText, bottomString: meme.bottomText)
        let imageView = UIImageView(image: meme.image)
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        println("Cell \(indexPath.row) selected")
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailVC
        self.navigationController!.pushViewController(detailController, animated: true)

    }
    
}


