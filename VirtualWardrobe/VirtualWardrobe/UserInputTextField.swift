//
//  UserInputTextField.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/5/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class UserInputTextField: UITextField {

    init() {
        super.init(frame: CGRect.zero)
        placeholder = "Enter text here"
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 15)
        borderStyle = UITextField.BorderStyle.roundedRect
        returnKeyType = UIReturnKeyType.done
        clearButtonMode = UITextField.ViewMode.whileEditing
        contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        placeholder = "Enter text here"
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 15)
        borderStyle = UITextField.BorderStyle.roundedRect
        returnKeyType = UIReturnKeyType.done
        clearButtonMode = UITextField.ViewMode.whileEditing
        contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
}
