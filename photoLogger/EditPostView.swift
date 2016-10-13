//
//  EditPostView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-09-20.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class EditPostView: UIViewController {
    
    var post: Post?
    
    @IBOutlet weak var taskImage: ImageSelector!
    @IBOutlet weak var taskTitle: TitleTextField!
    @IBOutlet weak var taskDescription: DescriptionTextView!
    @IBOutlet weak var savePostButton: SavePostButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PhotoLogger"
        self.taskTitle.text = post?.taskTitle
        self.taskDescription.text = post?.taskDescription
        self.taskImage.image = DetailView.imageCache.object(forKey: post!.taskImage as NSString)
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
            "taskAddress": (post?.taskAddress)!,
            "taskDate": (post?.taskDate)!,
            "taskImage": (post?.taskImage)!
        ]
        let firebasePostKey = post!.postKey
        print("EditView -> RGM -> postKey (aka firebasePost.key) is: \(firebasePostKey)")
        let firebasePostDetail = DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).child(firebasePostKey)
        print("EditView -> RGM -> DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).child(firebasePostKey) is \(firebasePostDetail)")
        firebasePostDetail.setValue(postUpdate)
    }
}
