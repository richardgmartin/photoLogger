//
//  ViewController.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-07-19.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase



class DetailView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // test data
        let post1 = Post(name: "Brenda", title: "Brenda's Program", description: "Exercise program for Brenda", date: "July 22, 2016", address: "123 Main Street", image: "")
        let post2 = Post(name: "Janet", title: "Janet's Program", description: "Exercise program for Janet", date: "July 18, 2016", address: "123 Reynolds Street", image: "")
        let post3 = Post(name: "Melanie", title: "Melanie's Program", description: "Exercise program for Melanie", date: "July 9, 2016", address: "123 Bank Street", image: "")
        
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
        var cell:PostCell
        
        if (tableView.dequeueReusableCell(withIdentifier: "PostCellID") as? PostCell) != nil {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "PostCellID") as! PostCell
        } else {
            
            cell = PostCell()
        }
        
        cell.configureCell(post)
        return cell

    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        
        let currentUser = FIRAuth.auth()?.currentUser
        print("RGM: user named, \(currentUser?.email), successfully logged out")
        do {
            try! FIRAuth.auth()!.signOut()
        }
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}

