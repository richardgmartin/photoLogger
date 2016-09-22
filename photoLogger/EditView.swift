//
//  EditView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-09-20.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase

class EditView: UIViewController {
    
    var postTitle = String()
    var postDescription = String()
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
        
        pullPostFromFirebase()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func pullPostFromFirebase() {
        
        let postKey = firebasePost.key
        print("postKey is: \(postKey)")
        
       
//        let test1 = DataService.ds.REF_POSTS.child(postKey)
//        let test2 = DataService.ds

    }
    
    @IBAction func savePostButtonTapped(_ sender: AnyObject) {
        
        
    }

}
