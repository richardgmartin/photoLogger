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
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        
        var emptyView = true
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                print("DetailView: RGM: snapshot.childrenCount is: \(snapshot.childrenCount)")
                if snapshot.childrenCount == 0 {
                    emptyView = true
                    print("DetailView: RGM: emptyView (when true) is: \(emptyView)")
                    // return emptyView
                } else {
                    emptyView = false
                    print("DetailView: RGM: emptyView (when false) is: \(emptyView)")
                    // return emptyView
                }
                
                }, withCancel: nil)
            
            DispatchQueue.main.async {
                print("DetailView: RGM: emptyView is: \(emptyView)")
            }
        }
        
        print("DetailView: RGM: emptyView is: \(emptyView)")
        return emptyView
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Posts Available.")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Time to add some PhotoLogger posts.")
    }
    
    /*
     unable to get working ... 
     
     
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "photo-logger-girl")
    }
 */
    
    
}

class DetailView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var posts = [Post]()
    var fbposts = [FIRDataSnapshot]()
    var postToEdit = FIRDataSnapshot()
    var fbPost = FIRDataSnapshot()
    
    // declare global cache var
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.perform(#selector(drawEmptyLabels), with: nil, afterDelay: 2)
        
        self.tableView.tableFooterView = UIView()
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        
        self.tableView.delegate = self
        
        // set up and initiate firebase observer
        DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).observe(.childAdded, with: { (snapshot) in
            if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                let postKey = snapshot.key
                // call custom (convenience) init in Post.swift class to create a post
                let post = Post(postKey: postKey, postData: postDict as! Dictionary<String, String>)
                // append post to posts array (of Post type)
                self.posts.append(post)
                // append snapshot to fbposts array (of type FIRDataSnapshot)
                self.fbposts.append(snapshot)
            }
            
            self.tableView.reloadData()
            // self.tableView.reloadEmptyDataSet()
            print("DetailView: RGM: snap posts are: \(self.posts)")
        })
        
    }
    
    // clear out delegate and data source assignments for DZNEmptyDataSet when class is destroyed
    
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
    
    // delete individual posts from table view and firebase database and images from firebase storage
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postImageURL = posts[indexPath.row].taskImage
            
            posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let firebasePost = fbposts[indexPath.row]
            firebasePost.ref.removeValue()
            
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: postImageURL)
            
            // let storageRef = DataService.ds.REF_IMAGES.child(postImageURL)
            storageRef.delete(completion: { (error ) in
                if (error != nil) {
                    print("DetailView -> RGM: error deleting image \(error)")
                } else {
                    print("DetailView -> RGM: image deleted")
                }
            })
        }
    }

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
            // return cell
        } else {
            // image is not there :: return post data without image
            cell.configureCell(post: post, img: nil)
            // return cell
        }
        return cell
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        
        let currentUser = FIRAuth.auth()?.currentUser
        
        do {
            try! FIRAuth.auth()!.signOut()
            print("DetailView: RGM: user named, \(currentUser?.email), successfully logged out")
            
        }
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    @IBAction func addPostButtonTapped(_ sender: AnyObject) {
        
        navigationItem.title = nil

        performSegue(withIdentifier: "addPostSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       //  tableView .deselectRow(at: indexPath, animated: false)
        
        self.postToEdit = fbposts[indexPath.row]
        print("row selected \(self.postToEdit)")
        performSegue(withIdentifier: "editPostSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPostSegue", let dvc = segue.destination as? EditView, let postIndex = tableView.indexPathForSelectedRow?.row  {
            // let dvc = segue.destination as? EditView
            // let postIndex = tableView.indexPathForSelectedRow?.row
            dvc.postTitle = posts[postIndex].taskTitle
            dvc.firebasePostRef = posts[postIndex].postKey
            dvc.firebasePost = fbposts[postIndex]
        }
    }
   }
