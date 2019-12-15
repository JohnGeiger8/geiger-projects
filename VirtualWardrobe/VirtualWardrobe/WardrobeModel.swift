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

enum AddOutfitSections: Int {
    case OutfitName = 0
    case AddNewItem = 1
    case WardrobeItem = 2
}

class WardrobeModel: DataManagerDelegate {
    
    // Have all files using model use the same instance
    static let sharedinstance = WardrobeModel()
    
    let types = ["Shirt", "Suit", "Pants", "Jacket", "Coat", "Vest", "Shorts", "Shoes", "Dress", "Hat", "Underwear", "Socks", "Necklace", "Bracelet", "Earrings", "Purse", "Handbag", "Ring", "Other"]
    let subtypes = ["Long-sleeve", "Short-sleeve", "Flannel", "Sports Jersey", "Button-Down", "Polo", "Khakis", "Jeans", "Baseball Hat", "Beanie", "Flat Rim Hat", "Boxers", "Briefs", "Sneakers", "Dress Shoes", "Heels", "Boots", "Slides", "Sandals", "Slip-ons", "Dress Socks", "Other"]
    
    var allItems : [WardrobeItemMO]
    var filteredItems : [WardrobeItemMO]
    var allOutfits : [OutfitMO]
    var filteredOutfits : [OutfitMO]
    var newOutfitName : String?
    var newOutfitSections : [Int:Int] = [AddOutfitSections.OutfitName.rawValue: 1, AddOutfitSections.AddNewItem.rawValue: 1, AddOutfitSections.WardrobeItem.rawValue: 0] // Row numbers of Add Outfit table view sections
    
    fileprivate init() {
        
        // Initialize wardrobe and outfits here using Core Data
        allItems = (dataManager.fetchManagedObjects(for: "WardrobeItemMO", sortKeys: ["name"], predicate: nil) as? [WardrobeItemMO])!
        allOutfits = (dataManager.fetchManagedObjects(for: "OutfitMO", sortKeys: ["name"], predicate: nil) as? [OutfitMO])!
        filteredOutfits = allOutfits
        filteredItems = allItems
        dataManager.delegate = self
    }
    
    // MARK:- Core Data and Data Manager
    
    let dataManager = DataManager.sharedInstance
    let dataModelName = "VirtualWardrobe"
    let entityName = "WardrobeItemMO"
    
    func createDatabase() {
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
    
    func itemLoanedToFor(indexPath: IndexPath) -> String? {
        
        return filteredItems[indexPath.row].loanedTo
    }
    
    // MARK:- Filter Items
    
    func updateItemFilter(filter: (WardrobeItemMO) -> Bool) {
        filteredItems = allItems.filter(filter)
    }
    
    func resetItemFilter() {
        filteredItems = allItems
    }
    
    // MARK:- Add, Update, Delete items
    func addWardrobeItem(_ item: WardrobeItem) {
        
        let itemMO = item.addItem(with: dataManager)
        dataManager.saveContext()
        allItems.append(itemMO)
        resetItemFilter()
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
        filteredItems[indexPath.row].loanedTo = item.loanedTo
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

// MARK:- Outfits
extension WardrobeModel {
    
    // Outfits Table View Data Source
    var numberOfOutfits : Int { return filteredOutfits.count }
    
    func outfitNameFor(indexPath: IndexPath) -> String {
        
        return filteredOutfits[indexPath.section].name!
    }
    
    func imageDataForOutfitItemFor(indexPath: IndexPath) -> Data {
        
        // FIXME: Not always image data
        let outfit = filteredOutfits[indexPath.section]
        let items = outfit.isMadeUpOf
        let wardrobeItems = items?.allObjects as? [WardrobeItemMO]
        return wardrobeItems![indexPath.row].imageData!
    }
    
    func numberOfItemsInOutfitFor(section: Int) -> Int {
        let outfitItems = filteredOutfits[section].isMadeUpOf
        return outfitItems!.count
    }
    
    func addOutfit(_ outfit: OutfitMO) {
        
        
        dataManager.saveContext()
    }
    
    func addItemToOutfitFor(indexPath: IndexPath, item: WardrobeItemMO) {
        
        filteredOutfits[indexPath.section].addToIsMadeUpOf(item)
        dataManager.saveContext()
    }
    
    // MARK:- Outfit filter
    
    func resetOutfitFilter() {
        filteredOutfits = allOutfits
    }
    
    // MARK:- Add Outfit Table View Data Source
    
    var numberOfSectionsForAddOutfit : Int { return newOutfitSections.count }
    
    func numberOfRowsInAddOutfitFor(section: Int) -> Int {
        
        switch section {
        case AddOutfitSections.AddNewItem.rawValue:
            return newOutfitSections[section]!
            
        case AddOutfitSections.OutfitName.rawValue:
            return newOutfitSections[section]!
            
        case AddOutfitSections.WardrobeItem.rawValue:
            return newOutfitSections[section]!
        default:
            assert(false, "Unhandled section")
        }
    }
    
    func typeOfCellFor(section: Int) -> AddOutfitSections {
        
        switch section {
        case AddOutfitSections.AddNewItem.rawValue:
            return AddOutfitSections.AddNewItem
            
        case AddOutfitSections.OutfitName.rawValue:
            return AddOutfitSections.OutfitName
            
        case AddOutfitSections.WardrobeItem.rawValue:
            return AddOutfitSections.WardrobeItem
            
        default:
            assert(false, "Unhandled cell type")
        }
    }
    
    func addNewItemRow() {
        
        let currentNumber = newOutfitSections[AddOutfitSections.AddNewItem.rawValue]
        newOutfitSections[AddOutfitSections.AddNewItem.rawValue] = currentNumber! + 1
    }
}

// MARK:- Trends
extension WardrobeModel {
    
    func clothesBy(_ timePeriod: String, sizeOfTimePeriod: Int) -> [String:Int] {
        
        var allItemsFiltered = allItems // Need to filter items within time period of size sizeOfTimePeriod
        var timePeriodFilter = { (item: WardrobeItemMO) -> Bool in return true}
        var clothesByInterval : [String:Int] = [:]
        let calendar = Calendar.current
        
        var timePeriodComponent : Calendar.Component = .year // Year by default
        var currentTimePeriod : Int = 0
        switch timePeriod {
        case "Year":
            currentTimePeriod = calendar.component(.year, from: Date()) // Current year
            timePeriodComponent = .year
//            timePeriodFilter = { (item: WardrobeItemMO) -> Bool in
//                let purchaseYear = calendar.component(.year, from: item.dateOfPurchase!)
//                if purchaseYear <= currentTimePeriod, purchaseYear > currentTimePeriod - sizeOfTimePeriod { return true }
//                else { return false }
//            }
            
        case "Month":
            currentTimePeriod = calendar.component(.month, from: Date()) // Current month
            timePeriodComponent = .month
            // FIXME: Filter needs to make sure we aren't looking at prior years' months.  There's an easier way to do this. Possibly difference of dates
//            timePeriodFilter = { (item: WardrobeItemMO) -> Bool in
//                let purchaseYear = calendar.component(.year, from: item.dateOfPurchase!)
//                let purchaseMonth = calendar.component(.month, from: item.dateOfPurchase!)
//                let currentYear = calendar.component(.year, from: Date())
//                let currentMonth = calendar.component(.month, from: Date())
//                guard purchaseYear <= currentYear, purchaseYear > currentYear - sizeOfTimePeriod else { return false } // Correct years checks
//                let monthDifference = (currentMonth - purchaseMonth) % 12
//                guard monthDifference < sizeOfTimePeriod, purchaseMonth < currentMonth else { return false } // Correct months check
//                return true
//            }
            
        // FIXME: Figure out how to do months with correct years being checked
        case "Week":
            currentTimePeriod = calendar.component(.weekOfYear, from: Date()) // Current week out of 52
//            timePeriodFilter = { (item: WardrobeItemMO) -> Bool in
//                let purchaseYear = calendar.component(.year, from: item.dateOfPurchase!)
//                let purchaseMonth = calendar.component(.month, from: item.dateOfPurchase!)
//                let purchaseWeek = calendar.component(.weekOfYear, from: item.dateOfPurchase!)
//                let currentYear = calendar.component(.year, from: Date())
//                let currentMonth = calendar.component(.month, from: Date())
//                let currentWeek = calendar.component(.weekOfYear, from: Date())
//                guard purchaseYear <= currentYear, purchaseYear > currentYear - sizeOfTimePeriod else { return false } // Correct years checks
//                let monthDifference = (currentMonth - purchaseMonth) % 12
//                guard monthDifference < sizeOfTimePeriod, purchaseMonth < currentMonth else { return false } // Correct months check
//                let weekDifference = (currentWeek - purchaseWeek) % 52
//                guard weekDifference < sizeOfTimePeriod, purchaseWeek
//                return true
//            }
            break
        default:
            assert(false, "Unhandled time period")
        }
        
        for _ in 0..<sizeOfTimePeriod {
            let itemFilter = createItemDateFilter(by: timePeriodComponent, forTime: currentTimePeriod)
            let clothesCount = allItems.filter(itemFilter).count
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
