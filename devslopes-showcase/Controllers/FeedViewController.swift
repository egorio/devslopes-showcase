//
//  FeedViewController.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/15/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.estimatedRowHeight = 300

        DataService.instance.posts.observeEventType(.Value, withBlock: { (snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [FDataSnapshot] else {
                return
            }

            self.posts = []
            for snapshot in snapshots {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let post = Post(id: snapshot.key, dictionary: dictionary)

                    self.posts.append(post)
                }
            }

            self.tableView.reloadData()
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCellWithIdentifier(Identifier.cellFeed) as? FeedTableCell) ?? FeedTableCell()

        let post = posts[indexPath.row]

        cell.configure(post)

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]

        if post.imageUrl == nil {
            return 200
        }

        return tableView.estimatedRowHeight
    }
}
