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

class WardrobeModel: DataManagerDelegate {
    
    // Have all files using model use the same instance
    static let sharedinstance = WardrobeModel()
    
    let types = ["Shirt", "Pants", "Shorts", "Shoes", "Dress", "Hat", "Underwear", "Socks", "Other"]
    let subtypes = ["Long-sleeve", "Short-sleeve", "Khakis", "Jeans", "Sneakers", "Dress Shoes", "Heels", "Boots", "Slides", "Sandals", "Slip-ons", "Baseball Hat", "Beanie", "Flat Rim Hat", "Boxers", "Briefs", "Dress Socks", "Other"]
    
    var filteredItems : [WardrobeItemMO]
    var allItems : [WardrobeItemMO]
    
    // Number of sections.  This should change depending on filter user chooses
    var numberOfSections = 1
    
    fileprivate init() {
        
        // Initialize wardrobe here using Core Data
        allItems = (dataManager.fetchManagedObjects(for: "WardrobeItemMO", sortKeys: ["name"], predicate: nil) as? [WardrobeItemMO])!
        filteredItems = allItems
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
        
        return filteredItems.count
    }
    
    func clothingItemFor(indexPath: IndexPath) -> WardrobeItemMO {
        
        return filteredItems[indexPath.row]
    }
    
    func clothingNameFor(indexPath: IndexPath) -> String {
        
        return filteredItems[indexPath.row].name!
    }
    
    func clothingTypeFor(indexPath: IndexPath) -> String {
        
        return filteredItems[indexPath.row].type!
    }
    
    func clothingSubTypeFor(indexPath: IndexPath) -> String {
        
        if let subtype = filteredItems[indexPath.row].subtype {
            return subtype
        }
        else {
            return "None"
        }
    }
    
    func clothingBrandNameFor(indexPath: IndexPath) -> String {
        
        if let brand = filteredItems[indexPath.row].brandName {
            return brand
        } else {
            return "Unknown"
        }
        
    }
    
    func clothingImageDataFor(indexPath: IndexPath) -> Data? {
        guard filteredItems[indexPath.row].imageData != nil else { return nil }
        
        return filteredItems[indexPath.row].imageData!
    }
    
    func clothingStoreNameFor(indexPath: IndexPath) -> String {
        
        if let store = filteredItems[indexPath.row].storeName {
            return store
        } else {
            return "Unknown"
        }
    }
    
    // MARK:- Filter Items
    
    func updateFilter(filter: (WardrobeItemMO) -> Bool) {
        filteredItems = allItems.filter(filter)
//        setSortedBuildings()
    }
    
    func resetFilter() {
        filteredItems = allItems
    }
    
    // MARK:- Add, Update, Delete items
    func addWardrobeItem(_ item: WardrobeItem) {
        
        let itemMO = item.addItem(with: dataManager)
        dataManager.saveContext()
        
        filteredItems.append(itemMO)
    }
    
    func updateWardrobeItem(_ item: WardrobeItem, atIndexPath indexPath: IndexPath) {
        
        filteredItems[indexPath.row].name = item.name
        filteredItems[indexPath.row].type = item.type
        filteredItems[indexPath.row].subtype = item.subType
        filteredItems[indexPath.row].brandName = item.brandName
        filteredItems[indexPath.row].storeName = item.storeName
        filteredItems[indexPath.row].dateOfPurchase = item.dateOfPurchase
        filteredItems[indexPath.row].imageData = item.imageData
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

// MARK:- Trends
extension WardrobeModel {
    
}
