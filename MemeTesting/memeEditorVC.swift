//
//  MemeEditorVC.swift
//  MemeTesting
//
//  Created by CHRISTOPHER WATSON on 07/15/15.
//  Copyright (c) 2015 CWatson. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UITextFieldDelegate
{
    var memes: [Meme]!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber(float: -3.0)
    
    ]
    var activityViewController:UIActivityViewController?
    var imagePicked = false
    
    func defaultSettings() {
        topTextField.text = "TOP"
        topTextField.textAlignment = .Center
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .Center
    }
    
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
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.save()
                // Save the activity-passed Meme into the SharedDataContainer inside the AppDelegate using the following funciton
                // and show the Sent Memes View Selector after saving the Sent Meme
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("memeTabVC") as! UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        topTextField.delegate = self
        bottomTextField.delegate = self
        self.subscribeToKeyboardNotifications()
        readyToShare()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "endEditing")
        view.addGestureRecognizer(tap)
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        defaultSettings()

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
                self.imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    func imagePickerControllerDidCancel(pickController: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    func readyToShare(){
        if((UIApplication.sharedApplication().delegate as! AppDelegate).memes.count > 0) || imagePicked{
            self.shareButton.enabled = true
            self.cancelButton.enabled = true
        }else{
            self.shareButton.enabled = false
        }
    }
    
    
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and Navbar
        self.topToolBar.hidden = true
        self.bottomToolBar.hidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
                self.view.drawViewHierarchyInRect(self.view.bounds,afterScreenUpdates: true)
                let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
       
        
        // Unhide the toolbar and navbar
        self.topToolBar.hidden = false
        self.bottomToolBar.hidden = false
        return memedImage
    }
    
    func save(){
        // Add the meme to the array on the App Delegate
        var meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imageView.image!, memedImage: generateMemedImage())
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
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
        if bottomTextField.editing {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.CGRectValue().height
        } else {
            // Return 0, not to shift the entire view up while editing the top textfield
            return 0
        }
    }
    
    func endEditing(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    @IBAction func cancelClicked(sender: AnyObject) {
        if((UIApplication.sharedApplication().delegate as! AppDelegate).memes.count < 1){
            var alert = UIAlertController(title: "Error", message: "No saved Memes to view.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click to return to Meme editor", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("memeTabVC") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
}

