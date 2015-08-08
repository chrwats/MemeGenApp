//
//  memeEditorVC.swift
//  MemeTesting
//
//  Created by CHRISTOPHER WATSON on 07/15/15.
//  Copyright (c) 2015 CWatson. All rights reserved.
//

import UIKit

class memeEditorVC: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    var memes: [Meme]!

    
    @IBOutlet weak var imagePickerOutlet: UIImageView!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName : -3.0,
    
    ]
    var activityViewController:UIActivityViewController?
    var imagePicked = false
    
    @IBAction func shareAction(sender: UIBarButtonItem) {
        let objectsToShare = [
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypePostToTwitter,
            UIActivityTypeAirDrop,
            UIActivityTypePostToFacebook,
            generateMemedImage()
        ]
        let activityViewController = UIActivityViewController(activityItems:objectsToShare, applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
        save()

        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success && self.memes.count>=1 {
                // Save the activity-passed Meme into the SharedDataContainer inside the AppDelegate using the following funciton
                
                // and show the Sent Memes View Selector after saving the Sent Meme
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("MemeTableVC") as! UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
        }

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        self.subscribeToKeyboardNotifications()
        readyToShare()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        memes = appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.unsubscribeFromKeyboardNotifications()
    }


    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        let pickController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.PhotoLibrary) {
                
        pickController.delegate = self
        pickController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary

        self.presentViewController(pickController, animated: true, completion: nil)
        }
        imagePicked = true
    }
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        let pickController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
        pickController.delegate = self
        pickController.sourceType = UIImagePickerControllerSourceType.Camera

        self.presentViewController(pickController, animated: true, completion: nil)
        }
        imagePicked = true

    }
    
    func imagePickerController(pickController: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            if let image = info[UIImagePickerControllerOriginalImage]as? UIImage {
                self.imagePickerOutlet.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    func imagePickerControllerDidCancel(pickController: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    func readyToShare(){
        if imagePicked{self.shareButton.enabled = true}
        else{
            self.shareButton.enabled = false
        }
    }
    
    
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and Navbar
        self.navigationController?.navigationBar.hidden = true;
        self.navigationController?.toolbar.hidden = true;

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //unhide the toolbar and navbar
        self.navigationController?.navigationBar.hidden = false;
        self.navigationController?.toolbar.hidden = false;
        println("meme saved in generateMemeImage function")
        return memedImage
        
    }
    
    func save(){
        var meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerOutlet.image!, memedImage: generateMemedImage())
        //add the meme to the array on the App Delegate

        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        println("meme saved in save function and added to the array")
        println("Meme array contains \(self.memes.count) items")

    }
    
    func testReturnImage() -> UIImage{
        var newMeme = UIGraphicsGetImageFromCurrentImageContext()
        return newMeme
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
   
    
    
}

