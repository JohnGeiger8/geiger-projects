//
//  CurvedEdgeButton.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 11/15/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class CurvedEdgeButton: UIButton {
    
    convenience init(named name: String) {
        
        self.init(frame: CGRect.zero)
        setTitle(name, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Customize button appearance
        layer.cornerRadius = 5
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.backgroundColor = .brightBlue
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Customize button appearance
        layer.cornerRadius = 5
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.backgroundColor = .brightBlue
    }
    
}
