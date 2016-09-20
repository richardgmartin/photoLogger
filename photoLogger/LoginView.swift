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

class LoginView: UIViewController {

    @IBOutlet weak var emailAddressText: EmailPasswordTextField!
    @IBOutlet weak var passwordText: EmailPasswordTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // check to see if user already signed in
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // user already signed in
                print("LoginView: RGM: the user, \(user), is already signed in.")
                self.performSegue(withIdentifier: "goToPostFeed", sender: nil)
            }
        })
    
    }

    
    // authenticate with Facebook
    
    @IBAction func facebookButtonTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        print("LoginView: RGM: at inititalization the facebookLogin is - \(facebookLogin)")
        
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            print("LoginView: RGM: result is - \(result?.isCancelled)")
            print("LoginView: RGM: error is - \(error)")
            print("LoginView: RGM: inside the completion handler facebookLogin is - \(facebookLogin)")
            
            if error != nil {
                // facebook authentication failed
                print("LoginView: RGM: unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                // user declines access via facebook permissions
                print("LoginView: RGM: user declined permission to access via Facebook")
            } else {
                // facebook successful authentication
                print("LoginView: RGM: user successfully authenticated via Facebook")
                // get credential
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    // authenticate with Firebase :: used by Facebook login
    
    func firebaseAuth(_ _credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: _credential, completion: { (user, error) in
            if error != nil {
                // firebase authentication failed
                print("LoginView: RGM: unable to authenticate with Firebase - \(error)")
            } else {
                // firebase authentication successful
                print("LoginView: RGM: successfully authenticated with Firebase")
            }
        })
    }
    
    // authenticate user with email + password or create new user with email + password

    @IBAction func signinTapped(_ sender: AnyObject) {
        if let email = emailAddressText.text, let password = passwordText.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    // firebase authentication successful
                    print("LoginView: RGM: Email user successfully authenticated with Firebase")
                } else {
                    // user does not exist in firebase :: create new user
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            // problem creating user
                            print("LoginView: RGM: problem creating new user from email and password")
                        } else {
                            // new user successfully created in firebase
                            print("LoginView: RGM: new user from email and password successfully created")
                            
                            // post user on firebase database using func inside DataService
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        } else {
            // send alert to user (when we go to production
            print("LoginView: RGM: email address and/or password fields empty")
        }
    }
    
    // function to complete the signin process :: post new user in firebase database and segue to DetailView
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        performSegue(withIdentifier: "goToPostFeed", sender: nil)
    }
}
