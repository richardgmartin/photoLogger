//
//  LoginView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-10.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import Fabric

// 1. declare delegate protocol

protocol LoadDetailViewDelegate {
    func buildTable()
}


class LoginView: UIViewController {

    @IBOutlet weak var emailAddressText: EmailPasswordTextField!
    @IBOutlet weak var passwordText: EmailPasswordTextField!
    
    // 2. declare delegate property
    var delegate: LoadDetailViewDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // authenticate with Twitter
    @IBAction func twitterButtonTapped(_ sender: AnyObject) {
        
        Twitter.sharedInstance().start(withConsumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
        Fabric.with([Twitter.self()])

        Twitter.sharedInstance().logIn() { (session, error) in
            if (session != nil) {
                let authToken = session?.authToken
                let authTokenSecret = session?.authTokenSecret
                let credential = FIRTwitterAuthProvider.credential(withToken: authToken!, secret: authTokenSecret!)
                self.firebaseAuth(credential)
                
            } else {
                // alert user that twitter login failed
                print("Twitter login failed")
            }
        }
    }

    // authenticate with Facebook
    @IBAction func facebookButtonTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                // alert user that facebook authentication failed
            } else if result?.isCancelled == true {
                // alert user that login failed because user declines access via facebook permissions
            } else {
                // facebook successful authentication :: get credential
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    // authenticate with Firebase :: used by Facebook and Twitter login methods
    func firebaseAuth(_ _credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: _credential, completion: { (user, error) in
            if error != nil {
                // alert user that firebase authentication failed
            } else {
                // firebase authentication successful => post user in firebase database
                let userData = ["provider": user?.providerID]
                DataService.ds.createFirebaseDBUser(uid: (user?.uid)!, userData: userData as! Dictionary<String, String>)
                // 3. implement delegate method
                self.dismiss(animated: true, completion: {
                    self.delegate?.buildTable()
                })
            }
        })
    }
    
    // authenticate user with email + password or create new user with email + password
    @IBAction func signinTapped(_ sender: AnyObject) {
        if let email = emailAddressText.text, let password = passwordText.text {
            
            if email.isEmpty || password.isEmpty {
                // send alert that one of the fields is empty (email address and password fields cannot be empty)
                displayAlert(messageToDisplay: "Your Email Address and/or Password field(s) are empty. Please try again.")
            } else {
                let isEmailAddressValid = verifyEmailAddressValid(emailAddressString: email)
                // verify email address is valid
                if isEmailAddressValid {
                    // verify password is valid
                    if password.characters.count >= 6 {
                        firebaseEmailAuth(email: email, password: password)
                    } else {
                        // fire alert controller indicating that password is too short in length
                        displayAlert(messageToDisplay: "The password you provided is too short. You need at least 6 characters.")
                    }
                } else {
                    // fire alert controller stating that email address is invalid and must be enter a valid email address
                    displayAlert(messageToDisplay: "The email address you provided is invalid. Please make sure the email address is correct.")
                }
            }
        }
    }
    
    // firebase email sign authorization and signin in process
    func firebaseEmailAuth(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                // firebase authentication successful
                self.dismiss(animated: true, completion: {
                    self.delegate?.buildTable()
                })
            } else {
                // user does not exist in firebase :: create new user
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        // alert user that there was a problem creating user
                        self.displayAlert(messageToDisplay: "Unable to create your account. Please try again.")
                    } else {
                        // new user successfully created in firebase
                        // post user on firebase database using func inside DataService
                        if let user = user {
                            let userData = ["provider": user.providerID]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    }
                })
            }
        })
    }
    
    // verify email address
    func verifyEmailAddressValid(emailAddressString: String) -> Bool{
        var returnValue = true
        
        /* regex options
         "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
         "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
         "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        */
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,6}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegex, options: NSRegularExpression.Options.caseInsensitive)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, options: [], range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
    
    // alert controller to display message to user
    func displayAlert(messageToDisplay: String) {
        
        let alertController = UIAlertController(title: "Problem With Email Login", message: messageToDisplay, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Please Try Again.", style: .default) { (action: UIAlertAction!) in
            self.emailAddressText.text = ""
            self.passwordText.text = ""
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // function to complete the signin process :: post new user in firebase database and segue to DetailView
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        // 3. implement delegate method
        dismiss(animated: true) {
            self.delegate?.buildTable()
        }
    }
    
    // func to return the user back to the login page (called in other view controllers)
    @IBAction func unwindToLogin(storyboard: UIStoryboardSegue) {
    }
}
