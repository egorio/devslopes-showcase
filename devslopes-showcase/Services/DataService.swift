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

    var firebase: Firebase {
        return _firebase
    }
}