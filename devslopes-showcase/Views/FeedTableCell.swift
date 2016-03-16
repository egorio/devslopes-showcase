//
//  FeedTableCell.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/15/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit

class FeedTableCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var postLabel: UITextView!
    @IBOutlet weak var postImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }
}
