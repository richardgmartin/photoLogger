//
//  ViewController.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-07-19.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase

class DetailView: UIViewController, UITableViewDelegate, UITableViewDataSource, LoadDetailViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var posts = [Post]()
    var postToEdit = FIRDataSnapshot()
    var fbPost = FIRDataSnapshot()
    var loadDetailView: LoginView?
    var haveICheckedFirebase = false
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    // MARK: - declare global cache var
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "PhotoLogger"

        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        
        // self.setNeedsStatusBarAppearanceUpdate()
                        
        if FIRAuth.auth()?.currentUser == nil {
            performSegue(withIdentifier: "goToSignIn", sender: nil)
        } else {
            
            buildTable()
        }
    }
    
    
    // MARK: display message while waiting for posts to download from firebase
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let emptyViewMessage = UILabel()
        
        // initiate a 'wait' message
        emptyViewMessage.text = "Please wait while we see if you have any posts."
        emptyViewMessage.textAlignment = .center
        emptyViewMessage.numberOfLines = 0
        emptyViewMessage.textColor = .darkGray
        emptyViewMessage.font = UIFont(name: "NotoSans", size: 12)
        
        
        if haveICheckedFirebase {
            emptyViewMessage.text = "You have no posts. Time to start posting."
        } else {
            perform(#selector (doSomething), with: nil, afterDelay: 3)
        }
        
        return emptyViewMessage
    }
    
    func doSomething() {
        haveICheckedFirebase = true
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.posts.count > 0 {
            return 0
        } else {
            return view.frame.height - 64
        }
    }
    
    // MARK: func call to load posts array with firebase database data/posts
    func buildTable() {
        // MARK: - firebase observer to track new post adds
        DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).observe(.childAdded, with: { (snapshot) in
            if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                let postKey = snapshot.key
                // call custom (convenience) init in Post.swift class to create a post
                let post = Post(postKey: postKey, postData: postDict as! Dictionary<String, String>)
                // append post to posts array (of Post type)
                self.posts.append(post)
            }
            self.tableView.reloadData()
        })
        
        // MARK: - firebase observer to track post edits/changes
        DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).observe(.childChanged, with: { (snapshot) in
            let postData = snapshot.value as! Dictionary<String, AnyObject>
            let postKey = snapshot.key
            let updatedPost = Post(postKey: postKey, postData: postData as! Dictionary<String, String>)
            let index = self.posts.index {
                $0.postKey == postKey
            }
            self.posts[index!] = updatedPost
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.title = "PhotoLogger"
    }
    
    // MARK: - delete individual posts from table view and firebase database and images from firebase storage
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postImageURL = posts[indexPath.row].taskImage
            
            let postKey = posts[indexPath.row].postKey
            
            posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).child(postKey).removeValue()
            
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: postImageURL)
            
            storageRef.delete(completion: { (error ) in
                if (error != nil) {
                    print("DetailView -> RGM: error deleting image \(error)")
                } else {
                    print("DetailView -> RGM: image deleted")
                }
            })
        }
    }

    // MARK: - tableView Methods :: set up populating table view with cells
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        var cell:PostCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "PostCellID") as! PostCell
            
        // check if we can source image from image cache
        if let img = DetailView.imageCache.object(forKey: post.taskImage as NSString) {
            cell.configureCell(post: post, img: img)
        } else {
            // image is not there :: return post data without image
            cell.configureCell(post: post, img: nil)
        }
        // assign tag attribute in shareButton the cell index row number
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - logout user
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        
        let currentUser = FIRAuth.auth()?.currentUser
        do {
            try! FIRAuth.auth()!.signOut()
            print("DetailView: RGM: user named, \(currentUser?.email), successfully logged out")
        }
        posts = [Post]()
        haveICheckedFirebase = false
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    // MARK: - add post with segue
    @IBAction func addPostButtonTapped(_ sender: AnyObject) {
        navigationItem.title = nil
        performSegue(withIdentifier: "addPostSegue", sender: nil)
    }
    
    // MARK: - edit post with segue :: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "editPostSegue", sender: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - prepareForSegue for editPost and logOut
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPostSegue", let dvc = segue.destination as? EditPostView, let postIndex = tableView.indexPathForSelectedRow?.row  {
            
            // back bar text
            let backBar = UIBarButtonItem()
            backBar.title = "Back"
            navigationController?.navigationBar.tintColor = .white
            navigationItem.backBarButtonItem = backBar
            
            // assign dvc attributes to carry across to EditView controller on segue
            dvc.post = posts[postIndex]
            
            // when done, deselect the row
            let pathIndex = self.tableView.indexPathForSelectedRow
            self.tableView.deselectRow(at: pathIndex!, animated: true)
        } else if segue.identifier == "goToSignIn" {
            loadDetailView = segue.destination as? LoginView
            loadDetailView?.delegate = self
        } else if segue.identifier == "addPostSegue" {
            navigationController?.navigationBar.tintColor = .white
        }
    }
    
    // MARK: - (selector) logic to share post
    @IBAction  func sharePost(sender: UIButton) {
        
        var objectsToShare: [AnyObject]?
        let titlePost = "Title: " + self.posts[sender.tag].taskTitle as String
        let descriptionPost = "Description: " + self.posts[sender.tag].taskDescription as String
        let imagePost = DetailView.imageCache.object(forKey: self.posts[sender.tag].taskImage as NSString)
        
        objectsToShare = [titlePost as AnyObject, descriptionPost as AnyObject, imagePost! as UIImage]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare!, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
   }
