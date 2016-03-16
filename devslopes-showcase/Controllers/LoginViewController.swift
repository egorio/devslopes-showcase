//
//  ViewController.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/14/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Push logged in user to the next screen
        if (NSUserDefaults.standardUserDefaults().valueForKey(Auth.userKey) != nil) {
            self.performSegueWithIdentifier(Identifier.segueLoggedIn, sender: nil)
        }
    }

    /*
     * Auth with Facebook
     */
    @IBAction func authWithFacebook(sender: AnyObject) {
        let facebook = FBSDKLoginManager()

        facebook.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) in
            guard facebookError == nil else {
                return print("Facebook login failed. Error: \(facebookError)")
            }

            let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            print("Successfully logged in with Facebook. \(accessToken)")

            DataService.instance.firebase.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, authData) in
                guard error == nil else {
                    return print("Login failed. \(error)")
                }

                let user = ["provider": authData.provider!]
                DataService.instance.createUser(authData.uid, user: user)

                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: Auth.userKey)
                self.performSegueWithIdentifier(Identifier.segueLoggedIn, sender: nil)
            })
        }
    }

    /*
     * Auth with Email and Password
     * If account with provided email does not exist - we create a new one and login user
     */
    @IBAction func authWithEmail(sender: AnyObject) {
        guard let email = emailField.text where email != "", let password = passwordField.text where password != "" else {
            return showErrorAlert("Email and Password required", message: "Please enter Email and Password")
        }

        DataService.instance.firebase.authUser(email, password: password) { (error, authData) in
            if error != nil {
                // If account does not exist - we try to create a new one
                if error.code == Auth.firebaseErrorAccountNoExist {
                    DataService.instance.firebase.createUser(email, password: password, withValueCompletionBlock: { (error, result) in
                        guard error == nil else {
                            return self.showErrorAlert("Could not create account", message: "Problem creating account. Try something else.")
                        }

                        // Login as just created user
                        DataService.instance.firebase.authUser(email, password: password, withCompletionBlock: { (error, authData) in
                            guard error == nil else {
                                return print("Login failed. \(error)")
                            }

                            let user = ["provider": authData.provider!]
                            DataService.instance.createUser(authData.uid, user: user)

                            NSUserDefaults.standardUserDefaults().setValue(result["uid"], forKey: Auth.userKey)
                            self.performSegueWithIdentifier(Identifier.segueLoggedIn, sender: nil)
                        })
                    })
                }
                else {
                    return self.showErrorAlert("Email or Password incorrect", message: "Please check your Email and Password")
                }
            }
            else {
                // Login succesfull
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: Auth.userKey)
                self.performSegueWithIdentifier(Identifier.segueLoggedIn, sender: nil)
            }
        }
    }

    /*
     * Shows error alert
     */
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

        presentViewController(alert, animated: true, completion: nil)
    }
}
