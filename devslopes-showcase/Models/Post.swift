//
//  Post.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/16/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation

class Post {
    private var _desc: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!

    private var _id: String!

    var desc: String {
        return _desc
    }

    var imageUrl: String? {
        return _imageUrl
    }

    var likes: Int {
        return _likes
    }

    var username: String {
        return _username
    }

    init(description: String, imageUrl: String?, username: String) {
        self._desc = description
        self._imageUrl = imageUrl
        self._username = username
    }

    init(id: String, dictionary: [String: AnyObject]) {
        self._id = id

        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }

        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }

        if let desc = dictionary["description"] as? String {
            self._desc = desc
        }
    }
}
