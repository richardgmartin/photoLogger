//
//  PostCell.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-07-25.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postClient: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postAddress: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post) {
        
        self.post = post
        
        postTitle.text = post.taskTitle
        // postClient.text = post.clientName
        // postDate.text = post.taskDate
        // postAddress.text = post.taskAddress
        postDescription.text = post.taskDescription
        
        
        // deal with image later
        
        
    }

    
}
