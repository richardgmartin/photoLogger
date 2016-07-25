//
//  ViewController.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-07-19.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test data
        var post1 = Post(name: "Brenda", title: "Brenda's Program", description: "Exercise program for Brenda", date: "July 22, 2016", address: "123 Main Street", image: "")
        var post2 = Post(name: "Janet", title: "Janet's Program", description: "Exercise program for Janet", date: "July 18, 2016", address: "123 Reynolds Street", image: "")
        var post3 = Post(name: "Melanie", title: "Melanie's Program", description: "Exercise program for Melanie", date: "July 9, 2016", address: "123 Bank Street", image: "")
        
        posts.append(post1)
        posts.append(post2)
        posts.append(post3)
        
        tableView.reloadData()

    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellID") as? PostCell {
            cell.configureCell(post: post)
            return cell
        } else {
            let cell = PostCell()
            cell.configureCell(post: post)
            return cell
        }
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    



}

