//
//  WardrobeModel.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 10/30/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import Foundation
import MapKit
import CoreData

struct WardrobeItem {
    var name : String
    var type : String
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
    
    func addItem(with dataManager: DataManager) -> WardrobeItemMO {
        
        let itemMO = WardrobeItemMO(context: dataManager.context)
        
        itemMO.brandName = brandName
        itemMO.dateOfPurchase = dateOfPurchase
        itemMO.imageData = imageData
        itemMO.name = name
        itemMO.type = type
        itemMO.subtype = subType
        itemMO.storeName = storeName
        
        return itemMO
    }
}


class WardrobeModel: DataManagerDelegate {
    
    // Have all files using model use the same instance
    static let sharedinstance = WardrobeModel()
    
    let types = ["Shirt", "Pants", "Shorts", "Shoes", "Dress", "Hat", "Underwear", "Socks", "Other"]
    let subtypes = ["Long-sleeve", "Short-sleeve", "Khakis", "Jeans", "Sneakers", "Dress Shoes", "Heels", "Boots", "Slides", "Sandals", "Slip-ons", "Baseball Hat", "Beanie", "Flat Rim Hat", "Boxers", "Briefs", "Dress Socks", "Other"]
    
    var allItems : [WardrobeItemMO]
    
    // Number of sections.  This should change depending on filter user chooses
    var numberOfSections = 1
    
    fileprivate init() {
        
        // Initialize wardrobe here using Core Data
        allItems = (dataManager.fetchManagedObjects(for: "WardrobeItemMO", sortKeys: ["name"], predicate: nil) as? [WardrobeItemMO])!
        dataManager.delegate = self
    }
    
    // MARK:- Core Data and Data Manager
    
    let dataManager = DataManager.sharedInstance
    let dataModelName = "WardrobeModel"
    let entityName = "WardrobeItemMO"
    
    func createDatabase() {
        // FIXME: do i need this
        dataManager.saveContext()
    }
    
    // MARK:- Clothing Table View Methods

    func numberOfClothes(forSection section: Int) -> Int {
        
        return allItems.count
    }
    
    func clothingItemFor(indexPath: IndexPath) -> WardrobeItemMO {
        
        return allItems[indexPath.row]
    }
    
    func clothingNameFor(indexPath: IndexPath) -> String {
        
        return allItems[indexPath.row].name!
    }
    
    func clothingTypeFor(indexPath: IndexPath) -> String {
        
        return allItems[indexPath.row].type!
    }
    
    func clothingSubTypeFor(indexPath: IndexPath) -> String {
        
        if let subtype = allItems[indexPath.row].subtype {
            return subtype
        }
        else {
            return "None"
        }
    }
    
    func clothingBrandNameFor(indexPath: IndexPath) -> String {
        
        if let brand = allItems[indexPath.row].brandName {
            return brand
        } else {
            return "Unknown"
        }
        
    }
    
    func clothingImageDataFor(indexPath: IndexPath) -> Data? {
        guard allItems[indexPath.row].imageData != nil else { return nil }
        
        return allItems[indexPath.row].imageData!
    }
    
    func clothingStoreNameFor(indexPath: IndexPath) -> String {
        
        if let store = allItems[indexPath.row].storeName {
            return store
        } else {
            return "Unknown"
        }
    }
    
    func addWardrobeItem(_ item: WardrobeItem) {
        
        let itemMO = item.addItem(with: dataManager)
        dataManager.saveContext()
        
        allItems.append(itemMO)
    }
    
    func updateWardrobeItem(_ item: WardrobeItem, atIndexPath indexPath: IndexPath) {
        
        allItems[indexPath.row].name = item.name
        allItems[indexPath.row].type = item.type
        allItems[indexPath.row].subtype = item.subType
        allItems[indexPath.row].brandName = item.brandName
        allItems[indexPath.row].storeName = item.storeName
        allItems[indexPath.row].dateOfPurchase = item.dateOfPurchase
        allItems[indexPath.row].imageData = item.imageData
        dataManager.saveContext()
    }
    
    // MARK: - Type and SubType Table View Controller
    var numberOfTypes : Int { return self.types.count }
    
    func typeFor(indexPath: IndexPath) -> String {
        
        return types[indexPath.row]
    }
    
    var numberOfSubTypes : Int { return self.subtypes.count }
    
    func subTypeFor(indexPath: IndexPath) -> String {
        
        return subtypes[indexPath.row]
    }
}
