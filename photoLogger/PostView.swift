//
//  PostView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-24.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase

class PostView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleTextField: TextFieldView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var savePostButton: StyleRectangleButton!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "PhotoLogger"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func cameraButtonTapped(_ sender: AnyObject) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }

    
    @IBAction func savePostButtonTapped(_ sender: AnyObject) {
        
        
        // prepare image and post to Firebase Storage
        let image = imageView.image
        let imageUID = NSUUID().uuidString
        let imageData = UIImageJPEGRepresentation(image!, 0.2)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        
        DataService.ds.REF_IMAGES.child(imageUID).put(imageData!, metadata: metaData) { (metaData, error) in
            if error != nil {
                print("RGM: error uploading image to firebase storage")
            } else {
                print("RGM: image upload to firebase storage was successful")
                print("RGM: imageUID is \(imageUID)")
                print("RGM: metaData is \(metaData)")
                let downloadURL = metaData?.downloadURL()?.absoluteString
                print("RGM: downloadURL is \(downloadURL)")
                
            }
        }
        
    }


}

