//
//  ClothingTableViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 10/30/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class ClothingTableViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    
    
    let wardrobeModel = WardrobeModel.sharedinstance
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["By name", "By type", "By color", "By store"]
        
        tableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return wardrobeModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wardrobeModel.numberOfClothes(forSection: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothingCell", for: indexPath) as! ClothingTableViewCell

        // Configure the cell
        cell.clothingNameLabel.text = wardrobeModel.clothingNameFor(indexPath: indexPath)
        let clothingImage = UIImage(named: wardrobeModel.clothingImageNameFor(indexPath: indexPath))
        cell.clothingImageView.image = clothingImage
        cell.clothingImageView.contentMode = .scaleAspectFit
        cell.clothingInfoLabel.text = wardrobeModel.clothingStoreNameFor(indexPath: indexPath)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 300  // FIXME: Need to make this more dynamic
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK:- Search Results Updater
    
    func updateSearchResults(for searchController: UISearchController) {
        // IMPLEMENT
    }
}
