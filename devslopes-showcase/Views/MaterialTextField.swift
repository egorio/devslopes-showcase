//
//  MaterialTextField.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/15/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = Theme.textFieldCornerRadius
        layer.borderColor = Theme.textFieldBorderColor
        layer.borderWidth = Theme.textFielsBorderWidth
    }

    /*
     * Returns the drawing rectangle for the text field’s text
     */
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 7)
    }

    /*
     * Returns the rectangle in which editable text can be displayed.
     */
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 7)
    }
}
