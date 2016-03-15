//
//  MaterialButton.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/15/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = Theme.cornerRadius
        layer.shadowColor = Theme.shadowColor
        layer.shadowOpacity = Theme.shadowOpacity
        layer.shadowRadius = Theme.shadowRadius
        layer.shadowOffset = Theme.shadowOffset
    }
}
