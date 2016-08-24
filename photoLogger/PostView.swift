//
//  PostView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-24.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase

class PostView: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleTextField: TextFieldView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "PhotoLogger"
    }
    

    
    @IBAction func savePostButtonTapped(_ sender: AnyObject) {
        
        
    }


}

