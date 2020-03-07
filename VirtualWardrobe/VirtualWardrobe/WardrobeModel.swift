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

// Keep track of prototype cells in AddOutfitTableViewController
struct AddOutfitSections {
    static let OutfitName = 0
    static let WardrobeItem = 1
    static let AddNewItem = 2
}

class WardrobeModel: DataManagerDelegate {
    
    // Have all files using model use the same instance
    static let sharedinstance = WardrobeModel()
    
    let types = ["Shirt", "Suit", "Pants", "Jacket", "Coat", "Vest", "Shorts", "Shoes", "Dress", "Hat", "Underwear", "Socks", "Necklace", "Bracelet", "Earrings", "Purse", "Handbag", "Ring", "Other"]
    let subtypes = ["Long-sleeve", "Short-sleeve", "Flannel", "Sports Jersey", "Button-Down", "Polo", "Khakis", "Jeans", "Baseball Hat", "Beanie", "Flat Rim Hat", "Boxers", "Briefs", "Sneakers", "Dress Shoes", "Heels", "Boots", "Slides", "Sandals", "Slip-ons", "Dress Socks", "Other"]
    let trendFavorites = ["Favorite Store", "Favorite Brand", "Favorite Type of Wardrobe Item"]
    
    var allItems : [WardrobeItemMO]
    var filteredItems : [WardrobeItemMO]
    var allOutfits : [OutfitMO]
    var filteredOutfits : [OutfitMO]
    var newOutfitName : String?
    var newOutfitSections : [Int:Int] = [AddOutfitSections.OutfitName: 1, AddOutfitSections.AddNewItem: 1, AddOutfitSections.WardrobeItem: 0] // Number of rows of Add Outfit table view sections
    var filteredOutfitTypes : [String] = []
    var trends : [String:String] = [:]
    
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
    
    func deleteWardrobeItemAt(indexPath: IndexPath) {
        
        let item = filteredItems.remove(at: indexPath.row)
        dataManager.context.delete(item)
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
    
    func outfitNameFor(section: Int) -> String {
        
        return filteredOutfits[section].name!
    }
    
    func imageDataOfOutfitFor(indexPath: IndexPath) -> Data? {
        
        let outfit = filteredOutfits[indexPath.section]
        let items = outfit.isMadeUpOf
        let wardrobeItems = items?.allObjects as? [WardrobeItemMO]
        return wardrobeItems![indexPath.row].imageData
    }
    
    func itemNameForOutfitAt(indexPath: IndexPath) -> String {
        
        let outfit = filteredOutfits[indexPath.section]
        let items = outfit.isMadeUpOf
        let wardrobeItems = items?.allObjects as? [WardrobeItemMO]
        return wardrobeItems![indexPath.row].name!
    }
    
    func numberOfTypesForOutfits() -> Int {
        
        for type in types {
            let filter : (WardrobeItemMO) -> Bool = {(item: WardrobeItemMO) in return item.type!.contains(type)}
            if allItems.filter(filter).count > 0 {
                if !filteredOutfitTypes.contains(type) {
                    filteredOutfitTypes.append(type)
                }
            }
        }
        return filteredOutfitTypes.count
    }
    
    func filteredTypeFor(indexPath: IndexPath) -> String {
        return filteredOutfitTypes[indexPath.row]
    }
    
    func numberOfItemsInOutfitFor(section: Int) -> Int {
        let outfitItems = filteredOutfits[section].isMadeUpOf
        return outfitItems!.count
    }
    
    func addOutfit(_ outfitName: String, withWardrobeItems wardrobeItems: [WardrobeItemMO]) {
        
        let newOutfit = OutfitMO(context: dataManager.context)
        newOutfit.name = outfitName
        for item in wardrobeItems {
            newOutfit.addToIsMadeUpOf(item) // Add each part of outfit to it
        }
        dataManager.saveContext()
        allOutfits.append(newOutfit)
        resetOutfitFilter()
    }
    
    func addItemToOutfitFor(indexPath: IndexPath, item: WardrobeItemMO) {
        
        filteredOutfits[indexPath.section].addToIsMadeUpOf(item)
        dataManager.saveContext()
    }
    
    func deleteOutfitAt(indexPath: IndexPath) {
        
        let outfit = filteredOutfits.remove(at: indexPath.section)
        dataManager.context.delete(outfit)
        dataManager.saveContext()
    }
    
    // MARK:- Outfit filter
    
    func resetOutfitFilter() {
        filteredOutfits = allOutfits
    }
    
}

// MARK:- Trends
extension WardrobeModel {
    
    func clothesBy(_ timePeriod: String, sizeOfTimePeriod: Int) -> [String:Int] {
        
        var clothesByInterval : [String:Int] = [:]
        
        var timePeriodComponent : Calendar.Component = .year // Year by default
        switch timePeriod {
        case "Year":
            timePeriodComponent = .year
            
        case "Month":
            timePeriodComponent = .month
            
        case "Week":
            timePeriodComponent = .weekOfYear
            
        default:
            assert(false, "Unhandled time period")
        }
        
        // Check for dates within time period by year/month/week
        var laterDate = Date().lastDayOf(dateComponent: timePeriodComponent)
        var pastDate = laterDate.firstDayOf(dateComponent: timePeriodComponent)
        for _ in 0..<sizeOfTimePeriod {
            let itemFilter = createItemDateFilter(between: pastDate, and: laterDate)
            let clothesCount = allItems.filter(itemFilter).count
            clothesByInterval[pastDate.textFromComponent(component: timePeriodComponent)] = clothesCount
            
            laterDate = Calendar.current.date(byAdding: timePeriodComponent, value: -1, to: laterDate)!
            pastDate = laterDate.firstDayOf(dateComponent: timePeriodComponent)
        }
        
        return clothesByInterval
    }
    
    func createItemDateFilter(between firstDate: Date, and secondDate: Date) -> ((WardrobeItemMO) -> Bool) {
        
        // Creates filter for either week, month, or year for being between two dates
        let filter = { (item: WardrobeItemMO) -> Bool in
            if item.dateOfPurchase! < secondDate, item.dateOfPurchase! > firstDate {
                return true
            } else {
                return false
            }
        }
        return filter
    }
    
    var numberOfTrends : Int { return trendFavorites.count }
    
    func findTrends() {
        
        // Look at all trends' properties and the  and figure out most frequented one
        var allOptions : [String:[String]] = [:]
        for property in trendFavorites {
            allOptions[property] = [] // Have to initialize to append
            for item in allItems {
                if let propertyValue = itemProperty(item: item, property) {
                    allOptions[property]!.append(propertyValue.trimmingCharacters(in: CharacterSet(arrayLiteral: " ")))
                }
            }
            
            let propertyValueFrequency = NSCountedSet(array: allOptions[property]!)
            let favorite = propertyValueFrequency.max { propertyValueFrequency.count(for: $0) < propertyValueFrequency.count(for: $1) }
            trends[property] = favorite as? String
        }
    }
    
    func itemProperty(item: WardrobeItemMO, _ property: String) -> String? {
        switch property {
        case "Favorite Store":
            return item.storeName
        case "Favorite Brand":
            return item.brandName
        case "Favorite Type of Wardrobe Item":
            return item.type
        default:
            assert(false, "Unhandled favorite")
        }
    }
    
    func trendNameAt(indexPath: IndexPath) -> String {
        return trendFavorites[indexPath.row]
    }
    
    func favoriteOf(_ trendName: String) -> String? {
        return trends[trendName]
    }
}
