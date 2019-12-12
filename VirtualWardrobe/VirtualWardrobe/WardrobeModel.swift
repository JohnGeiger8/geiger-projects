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
    }
    
    func resetFilter() {
        filteredItems = allItems
    }
    
    // MARK:- Add, Update, Delete items
    func addWardrobeItem(_ item: WardrobeItem) {
        
        let itemMO = item.addItem(with: dataManager)
        dataManager.saveContext()
        
        allItems.append(itemMO)
    }
    
    func updateWardrobeItem(_ item: WardrobeItem, atIndexPath indexPath: IndexPath) {
        
        filteredItems[indexPath.row].name = item.name
        filteredItems[indexPath.row].type = item.type
        filteredItems[indexPath.row].colors = item.colors
        filteredItems[indexPath.row].size = item.size
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
    
    func clothesBy(_ timePeriod: String, sizeOfTimePeriod: Int) -> [String:Int] {
        
        var clothesByInterval : [String:Int] = [:]
        let calendar = Calendar.current
        
        var timePeriodComponent : Calendar.Component = .year // Year by default
        var currentTimePeriod : Int = 0
        switch timePeriod {
        case "Year":
            currentTimePeriod = calendar.component(.year, from: Date()) // Current year
            timePeriodComponent = .year
        case "Month":
            currentTimePeriod = calendar.component(.month, from: Date()) // Current month
            timePeriodComponent = .month
        case "Week":
//            currentTimePeriod = calendar.component(.wee, from: <#T##Date#>)
            break
        default:
            assert(false, "Unhandled time period")
        }
        
        for _ in 0..<sizeOfTimePeriod {
            let filter = createItemDateFilter(by: timePeriodComponent, forTime: currentTimePeriod)
            let clothesCount = allItems.filter(filter).count
            clothesByInterval[String(currentTimePeriod)] = clothesCount
            currentTimePeriod -= 1
        }
        
        return clothesByInterval
    }
    
    func createItemDateFilter(by component: Calendar.Component, forTime targetTime: Int) -> ((WardrobeItemMO) -> Bool) {
        
        let calendar = Calendar.current
        
        // Creates filter for either week, month, or year, and checks that component's value (targetTime) against the item's date of purchase
        let filter = { (item: WardrobeItemMO) -> Bool in
            if calendar.component(component, from: item.dateOfPurchase!) != targetTime {
                return false
            } else {
                return true
            }
        }
        return filter
    }
    
    var favoriteStore : String {
        
        // Look at all items' purchased store/website and figure out most frequented one
        var stores : [String] = []
        for item in allItems {
            if let _ = item.storeName {
                let store = item.storeName!.trimmingCharacters(in: CharacterSet(arrayLiteral: " "))
                stores.append(store)
            }
        }
        let storeFrequencies = NSCountedSet(array: stores)
        let favoriteStore = storeFrequencies.max { storeFrequencies.count(for: $0) < storeFrequencies.count(for: $1) }
        
        return favoriteStore as! String
    }
}
