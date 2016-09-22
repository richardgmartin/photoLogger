//
//  EditView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-09-20.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class EditView: UIViewController {
    
    var postTitle = String()
    var postDescription = String()
    var postAddress = String()
    var postDate = String()
    var postImageURL = String()
    var postImage = UIImage()
    var firebasePostRef = String()
    var firebasePost = FIRDataSnapshot()
    
    
    @IBOutlet weak var taskImage: ImageSelector!
    @IBOutlet weak var taskTitle: TitleTextField!
    @IBOutlet weak var taskDescription: DescriptionTextView!
    @IBOutlet weak var savePostButton: SavePostButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PhotoLogger"
        
        self.taskTitle.text = postTitle
        self.taskDescription.text = postDescription
        self.taskImage.image = postImage

    }

    @IBAction func savePostButtonTapped(_ sender: AnyObject) {
        
        // initiate progress indicator
        SVProgressHUD.show(withStatus: "Updating Post.")

        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.updateFirebasePost()
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateFirebasePost() {
        
        let newTaskTitle = taskTitle.text
        print("EditView -> RGM -> newTaskTitle is: \(newTaskTitle)")
        let newTaskDescription = taskDescription.text
        print("EditView -> RGM -> newTaskDescription is: \(newTaskDescription)")
        
        let postUpdate: Dictionary<String, String> = [
            "taskTitle": newTaskTitle!,
            "taskDescription": newTaskDescription!,
            "taskAddress": postAddress,
            "taskDate": postDate,
            "taskImage": postImageURL
        ]
        
        let firebasePostKey = firebasePost.key
        print("EditView -> RGM -> postKey (aka firebasePost.key) is: \(firebasePostKey)")
        let firebasePostDetail = DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).child(firebasePostKey)
        print("EditView -> RGM -> DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).child(firebasePostKey) is \(firebasePostDetail)")
        
        firebasePostDetail.setValue(postUpdate)
    }
}
