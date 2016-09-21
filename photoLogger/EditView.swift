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
    var firebasePostRef = String()
    var firebasePost = FIRDataSnapshot()

    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pullPostFromFirebase()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = postTitle
    }
    
    func pullPostFromFirebase() {
        
        let postKey = firebasePost.key
        print("postKey is: \(postKey)")
        
       
        let test = DataService.ds.REF_POSTS.child(postKey)
        let test2 = DataService.ds

    }
    

}
