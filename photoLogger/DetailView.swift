//
//  ViewController.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-07-19.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet

extension DetailView: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Posts Available!")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Time to add some PhotoLogger posts.")
    }
    
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "photo-logger-girl")
//    }
    
    
}

class DetailView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var posts = [Post]()
    // declare global cache var
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        // set up and initiate firebase observer
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let postsSnap = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in postsSnap {
                    print("DetailView: RGM || SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let postKey = snap.key
                        // call custom (convenience) init in Post.swift class to create a post
                        let post = Post(postKey: postKey, postData: postDict as! Dictionary<String, String>)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
            // self.tableView.reloadEmptyDataSet()
            print("DetailView: RGM: snap posts are: \(self.posts)")
        })
        
    }
    
    // clear out delegate and data source assignments for DZNEmptyDataSet when class is destroyed
    
//    deinit {
//        self.tableView.emptyDataSetSource = nil
//        self.tableView.emptyDataSetDelegate = nil
//    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        var cell:PostCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "PostCellID") as! PostCell
            
        // check if we can source image from image cache
        if let img = DetailView.imageCache.object(forKey: post.taskImage as NSString) {
            cell.configureCell(post: post, img: img)
            return cell
        } else {
            // image is not there :: return post data without image
            cell.configureCell(post: post, img: nil)
            return cell
        }
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        
        let currentUser = FIRAuth.auth()?.currentUser
        print("DetailView: RGM: user named, \(currentUser?.email), successfully logged out")
        do {
            try! FIRAuth.auth()!.signOut()
        }
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    
    
    @IBAction func addPostButtonTapped(_ sender: AnyObject) {
        
        navigationItem.title = nil

        performSegue(withIdentifier: "addPostSegue", sender: nil)
    }
    

}

