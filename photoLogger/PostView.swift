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
    var imageSelected: Bool = false
    
    enum Reset : String {
        
        case LogoImage = "photo-logger-logo"
        case TitleField = ""
        case DescriptionField = " "
    }
    
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
        imageSelected = true
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cameraButtonTapped(_ sender: AnyObject) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }

    
    @IBAction func savePostButtonTapped(_ sender: AnyObject) {
        
        // check to make sure post entries complete
        
        guard let postTitle = titleTextField.text, postTitle != "" else {
            print("RGM: post title must be provided")
            return
        }
        
        guard let postDescription = descriptionTextView.text, postDescription != "" else {
            print("RGM: post description must be provided")
            return
        }
        
        guard let image = imageView.image, imageSelected == true else {
            print("RGM: image must be selected")
            return
        }
        
        // prepare image and post to Firebase Storage
        let imageUID = NSUUID().uuidString
        let imageData = UIImageJPEGRepresentation(image, 0.2)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        
        // TODO: Check if the user ID is really needed
       // let userID = "FEb60c3X69WsSN1JZvLrP7qDRVD3"
        
        DataService.ds.REF_IMAGES.child(imageUID).put(imageData!, metadata: metaData) { (metaData, error) in
            if error != nil {
                print("RGM: error uploading image to firebase storage")
            } else {
                print("RGM: image upload to firebase storage was successful")
                print("RGM: imageUID is \(imageUID)")
                print("RGM: metaData is \(metaData)")
                
                let downloadURL = metaData?.downloadURL()?.absoluteString
                print("RGM: downloadURL is \(downloadURL)")
                if let url = downloadURL {
                    self.postDataToFirebase(imageURL: url)
                }
            }
        }
    }
    
    // upload post data (with image url) to Firebase database
    
    func postDataToFirebase(imageURL: String) {
        
        let photoLoggerPost: Dictionary<String, String> = [
            "taskImage": imageURL,
            "taskTitle": titleTextField.text!,
            "taskDescription": descriptionTextView.text
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(photoLoggerPost)
        
        reset()
    }
    
    func reset() {
        
        // reset fields
        titleTextField.text = Reset.TitleField.rawValue
        descriptionTextView.text = Reset.DescriptionField.rawValue
        imageView.image = UIImage(named: Reset.LogoImage.rawValue)
    }
}

