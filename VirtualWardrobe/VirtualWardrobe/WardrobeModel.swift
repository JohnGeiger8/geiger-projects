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
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DoItNow")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
