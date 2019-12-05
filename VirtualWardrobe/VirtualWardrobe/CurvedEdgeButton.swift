//
//  CurvedEdgeButton.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 11/15/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class CurvedEdgeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Customize button appearance
        layer.cornerRadius = 5
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}
