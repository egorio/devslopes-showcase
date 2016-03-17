//
//  FeedTableCell.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/15/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class FeedTableCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!

    var post: Post!
    var request: Request?

    var firebaseLikes: Firebase!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }

    /*
     * Configure cell with post information
     */
    func configure(post: Post) {
        self.post = post
        self.firebaseLikes = DataService.instance.currentUser.childByAppendingPath("likes/" + post.id)

        postLabel.text = post.desc
        likesLabel.text = String(post.likes)
        likesButton.setImage(UIImage(named: "heart-empty"), forState: .Normal)

        firebaseLikes.observeSingleEventOfType(.Value) { (snapshot, _) in
            if snapshot.exists() {
                self.likesButton.setImage(UIImage(named: "heart-full"), forState: .Normal)
            }
        }

        configureImage(post.imageUrl)
    }

    /*
     * Set image from cache or download a new one from internet by url
     */
    private func configureImage(url: String?) {
        request?.cancel()

        postImage.image = nil
        postImage.hidden = true

        guard let url = url else {
            return
        }

        if let image = MemoryCache.get(url) {
            postImage.image = image
            postImage.hidden = false
        }
        else {
            Alamofire.request(.GET, url)
                .validate(contentType: ["image/*"])
                .response(completionHandler: { (request, response, data, error) in
                    guard error == nil else {
                        return
                    }

                    let image = UIImage(data: data!)!

                    self.postImage.image = image
                    self.postImage.hidden = false

                    MemoryCache.set(image, forKey: url)
            })
        }
    }

    @IBAction func likePost(sender: AnyObject) {
        firebaseLikes.observeSingleEventOfType(.Value) { (snapshot, _) in
            if snapshot.exists() {
                self.firebaseLikes.removeValue()
                self.likesButton.setImage(UIImage(named: "heart-empty"), forState: .Normal)
            }
            else {
                self.firebaseLikes.setValue(true)
                self.likesButton.setImage(UIImage(named: "heart-full"), forState: .Normal)
            }
        }
    }
}