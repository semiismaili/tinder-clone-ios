//
//  LogInViewController.swift
//  tinder
//
//  Created by Semi Ismaili on 5/1/20.
//  Copyright © 2020 Semi Ismaili. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var paswordTextField: UITextField!
    @IBOutlet weak var changeLogInSignUpButton: UIButton!
    @IBOutlet weak var logInSignUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var signUpMode = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
    }
    
    @IBAction func logInSignUpTapped(_ sender: Any) {
    
        if signUpMode{ //sign up
            
            let user = PFUser()
            user.username = usernameTextField.text
            user.password = paswordTextField.text
            
            user.signUpInBackground(block: { (success, error) in
                if error != nil {
                    var errorMessage = "SignUp Failed - Try Again"
                    
                    if let newError =  error as NSError?{
                        if let detailError = newError.userInfo["error"] as? String {
                            errorMessage =  detailError
                        }
                    }
                    
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                    
                }else{
                    print("Sign Up succesful!")
                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                }
            })
            
        }else{ //log in
            
            if let username = usernameTextField.text {
                if let password = paswordTextField.text{
                    
                    PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
                        if error != nil {
                            var errorMessage = "Log In Failed - Try Again"
                            
                            if let newError =  error as NSError?{
                                if let detailError = newError.userInfo["error"] as? String {
                                    errorMessage =  detailError
                                }
                            }
                            
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = errorMessage
                            
                        }else{
                            print("Log In succesful!")
                            self.performSegue(withIdentifier: "updateSegue", sender: nil)
                        }
                    })
                }
            }
            
           
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "updateSegue", sender: nil)
        }
    }
    
    @IBAction func changeLogInSignUpTapped(_ sender: Any) {
    
        if signUpMode {
            logInSignUpButton.setTitle("Log In", for: .normal)
            changeLogInSignUpButton.setTitle("Sign Up", for: .normal)
            signUpMode = false
        } else {
            logInSignUpButton.setTitle("Sign Up", for: .normal)
            changeLogInSignUpButton.setTitle("Log In", for: .normal)
            signUpMode = true
        }
        
    }
}
