//
//  PostCell.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-07-25.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postAddress: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    weak var detailViewController = UIViewController()
    
    
//    var post: Post! {
//        didSet {
//            // takes care of self.post = post
//            
//        }
//    }
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        
        postTitle.text = post.taskTitle
        postDescription.text = post.taskDescription
        postDate.text = post.taskDate
        postAddress.text = post.taskAddress
        
        if img != nil {
            // set image in cell to image in cache
            self.postImg.image = img
        } else {
            // image is not in cache, so retrieve image from firebase storage
            let ref = FIRStorage.storage().reference(forURL: post.taskImage)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("PostCell -> configureCell -> DetailView: RGM: problem downloading image from firebase storage")
                } else {
                    // image downloaded from firebase storage
                    print("PostCell -> configureCell -> DetailView: RGM: image successfully downloaded from firebase storage")
                    // download the image from firebase storage into cache
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            DetailView.imageCache.setObject(img, forKey: post.taskImage as NSString)
                        }
                    }
                }
            })
        }
    }
}
