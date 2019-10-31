//
//  WardrobeModel.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 10/30/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import Foundation
import MapKit

struct Clothing {
    var name : String
    var type : String
    var colors : [String]
    var seasons : [String]
    var price : Double
    var storeName : String
    var storeLocation : CLLocationCoordinate2D
}


class WardrobeModel {
    
    // Have all files using model use the same instance
    static let sharedinstance = WardrobeModel()
    
    fileprivate init() {
        
    }
}
