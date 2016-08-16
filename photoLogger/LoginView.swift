//
//  LoginView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-10.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase

class LoginView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // authenticate with Facebook
    
    @IBAction func facebookButtonTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                // facebook authentication failed
                print("RGM: unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                // user declines access via facebook oermissions
                print("RGM: user declined permission to access via Facebook")
            } else {
                // facebook successful authentication
                print("RGM: user successfully authenticated via Facebook")
                // get credential
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(_credential: credential)
            }
        }
    }
    
    // authenticate with Firebase :: used by most federated access means
    
    func firebaseAuth(_credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: _credential, completion: { (user, error) in
            if error != nil {
                print("RGM: unable to authenticate with Firebase - \(error)")
            } else {
                print("RGM: successfully authenticated with Firebase")
            }
        })
    }

}
