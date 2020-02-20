//
//  WardrobeItem.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/10/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import Foundation
import MapKit

struct WardrobeItem {
    var name : String
    var type : String
    var size : String
    var subType : String? // E.g. type = "shirt" subtype = "long-sleeve"
    var colors : [String]
    var seasons : [String]
    var brandName : String?
    var price : Double?
    var storeName : String?
    var storeLocation : CLLocationCoordinate2D?
    var imageName : String
    var imageData : Data?
    var dateOfPurchase : Date?
    var loanedTo : String?
    
    func addItem(with dataManager: DataManager) -> WardrobeItemMO {
        
        let itemMO = WardrobeItemMO(context: dataManager.context)
        
        itemMO.brandName = brandName
        itemMO.dateOfPurchase = dateOfPurchase
        itemMO.imageData = imageData
        itemMO.name = name
        itemMO.type = type
        itemMO.size = size
        itemMO.colors = colors
        itemMO.subtype = subType
        itemMO.storeName = storeName
        itemMO.loanedTo = loanedTo
        
        return itemMO
    }
}
