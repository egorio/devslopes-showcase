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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
     * Auth with Facebook
     */
    @IBAction func authWithFacebook(sender: AnyObject) {
        let facebook = FBSDKLoginManager()

        facebook.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) in
            if facebookError != nil {
                print("Facebook login failed. Error: \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
            }
        }
    }
}
