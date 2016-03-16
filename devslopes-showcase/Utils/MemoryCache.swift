//
//  MemoryCache.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/16/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit

class MemoryCache {

    static private let instance: NSCache = {
        let cache = NSCache()
        cache.name = "cache"
        cache.countLimit = 200 // Max number of items in memory.
        cache.totalCostLimit = (cache.countLimit / 2) * 1024 * 1024 // Max Mb can be used (500 Kb per items).
        return cache
    }()

    // Getter for images
    static func get(forKey: String) -> UIImage? {
        return instance.objectForKey(forKey) as? UIImage
    }

    // Setter for images
    static func set(data: UIImage, forKey: String) {
        instance.setObject(data, forKey: forKey, cost: (UIImageJPEGRepresentation(data, 0)?.length) ?? 0)
    }

    // Remover
    static func remove(forKey: String) {
        instance.removeObjectForKey(forKey)
    }
}