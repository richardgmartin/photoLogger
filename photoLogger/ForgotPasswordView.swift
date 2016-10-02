//
//  ForgotPasswordView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-09-28.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordView: UIViewController {

    
    @IBOutlet weak var emailTextField: EmailPasswordTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func submitButtonTapped(_ sender: ForgotPasswordButton) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email address.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            var message = ""
            var title = ""
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                if error != nil {
                    title = "Something went wrong."
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success"
                    message = "Email password has been sent."
                    self.emailTextField.text = ""
                }
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
