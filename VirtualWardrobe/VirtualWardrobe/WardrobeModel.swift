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
    var subType : String // E.g. type = "shirt" subtype = "long-sleeve"
    var colors : [String]
    var seasons : [String]
    var price : Double
    var storeName : String
    var storeLocation : CLLocationCoordinate2D
    var imageName : String
    var dateOfPurchase : Date
}


class WardrobeModel {
    
    // Have all files using model use the same instance
    static let sharedinstance = WardrobeModel()
    
    let clothingNames = ["Carson Wentz Eagles Jersey", "Sperry Docksider Shoes", "Red and Blue Flannel"]
    let clothingImageNames = ["Wentz Jersey", "Sperry Shoes", "Red and Blue Flannel"]
    let clothingStoreNames = ["NFLShop.com", "Goodwill", "REI"]
    
    // Number of sections.  This should change depending on filter user chooses
    var numberOfSections = 1
    
    fileprivate init() {
        
    }
    
    // MARK:- Clothing Table View Methods
    
    // Use switch-case statement to give number of rows for the section number depending on the filter chosen by the user
    func numberOfClothes(forSection section: Int) -> Int {
        
        return clothingStoreNames.count
    }
    
    func clothingNameFor(indexPath: IndexPath) -> String {
        
        return clothingNames[indexPath.row]
    }
    
    func clothingImageNameFor(indexPath: IndexPath) -> String {
        
        return clothingImageNames[indexPath.row]
    }
    
    func clothingStoreNameFor(indexPath: IndexPath) -> String {
        
        return clothingStoreNames[indexPath.row]
    }
}
