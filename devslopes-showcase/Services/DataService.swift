//
//  DataService.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/15/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let instance = DataService()

    private var _firebase = Firebase(url: "https://egorio-showcase.firebaseio.com")
    private var _users = Firebase(url: "https://egorio-showcase.firebaseio.com/users")
    private var _posts = Firebase(url: "https://egorio-showcase.firebaseio.com/posts")

    var firebase: Firebase {
        return _firebase
    }

    var users: Firebase {
        return _users
    }

    var posts: Firebase {
        return _posts
    }
    
    var currentUser: Firebase {
        let id = NSUserDefaults.standardUserDefaults().valueForKey(Auth.userKey) as! String
        return Firebase(url: "\(_users)").childByAppendingPath(id)!
    }

    func createUser(id: String, user: [String: String]) {
        users.childByAppendingPath(id).setValue(user)
    }

    func createPost(post: [String: AnyObject]) {
        posts.childByAutoId().setValue(post)
    }
}