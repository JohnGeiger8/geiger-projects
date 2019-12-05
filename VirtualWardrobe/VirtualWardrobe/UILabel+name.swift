//
//  UILabel+name.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/4/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(named name: String) {
        self.init(frame: CGRect.zero)
        self.text = name
    }
}
