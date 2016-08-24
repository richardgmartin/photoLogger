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
        
        
        
    }


}

