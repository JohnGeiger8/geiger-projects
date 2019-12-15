//
//  ClothingTableViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 10/30/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

enum SearchWardrobeFilters {
    case ByName
    case ByType
    case ByColor
    case ByStore
}

class ClothingTableViewController: UITableViewController {
    
    let wardrobeModel = WardrobeModel.sharedinstance
    let searchController = UISearchController(searchResultsController: nil)
    var filterIndex = SearchWardrobeFilters.ByName
    
    @IBOutlet weak var bottomBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Search Bar
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.scopeButtonTitles = ["By name", "By type", "By color", "By store"]
        searchController.searchBar.delegate = self // Causes weird issues with Search bar display
        
        tableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wardrobeModel.numberOfClothes(forSection: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothingCell", for: indexPath) as! ClothingTableViewCell

        // Configure the cell
        cell.itemNameLabel.text = wardrobeModel.clothingNameFor(indexPath: indexPath)
        if let imageData = wardrobeModel.clothingImageDataFor(indexPath: indexPath) {
            let image = UIImage(data: imageData)
            cell.itemImageView.image = image
        }
        else {
            let image = UIImage(named: "noImageFound")
            cell.itemImageView.image = image
        }
        cell.itemImageView.contentMode = .scaleAspectFit
        cell.itemInfoLabel.text = wardrobeModel.clothingStoreNameFor(indexPath: indexPath)
        cell.itemLoanedButton.isHidden = wardrobeModel.itemLoanedToFor(indexPath: indexPath) == nil
        
        cell.backgroundColor = .backgroundColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Present an item detail view controller
        let itemDetailViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as? AddItemViewController)
        
        self.present(itemDetailViewController!, animated: true, completion: {

            let wardrobeItem = self.wardrobeModel.clothingItemFor(indexPath: indexPath)
            itemDetailViewController?.configureForDetailView(item: wardrobeItem, atIndexPath: indexPath)
            itemDetailViewController?.delegate = self
            itemDetailViewController?.view.backgroundColor = .navigationColor
            itemDetailViewController?.mainScrollView.backgroundColor = .backgroundColor
        })
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 250  // FIXME: Need to make this more dynamic
    }
    
    // MARK:- Deletion of Items
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            wardrobeModel.deleteWardrobeItemAt(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            self.wardrobeModel.deleteWardrobeItemAt(indexPath: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeAction
    }
    
    // MARK:- Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AddItem":
            let destinationViewController = segue.destination as! AddItemViewController
            destinationViewController.delegate = self
            destinationViewController.view.backgroundColor = .backgroundColor
            destinationViewController.mainScrollView.backgroundColor = .backgroundColor
            
        default:
            assert(false, "Unhandled segue")
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
}

// MARK:- Search Bar and Results Delegates

extension ClothingTableViewController : UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text!
        guard !searchText.isEmpty else { return }
        var filter = {(item: WardrobeItemMO) in item.name!.contains(searchText)}
        
        // Choose how to filter depending on selected scope button
        switch filterIndex {
            case .ByName:
                filter = {(item: WardrobeItemMO) in item.name!.contains(searchText)}
            
            case .ByType:
                filter = {(item: WardrobeItemMO) in item.type!.contains(searchText)}
            
            case .ByColor:
                filter = {(item: WardrobeItemMO) in item.colors!.contains(searchText)}
            
            case .ByStore:
                filter = {(item: WardrobeItemMO) in
                    if let storeName = item.storeName {
                        return storeName.contains(searchText)
                    } else {
                        return false
                    }
                }
            
            default:
                assert(false, "Unhandled filter chosen")
            }
        
        self.wardrobeModel.updateItemFilter(filter: filter)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        switch selectedScope {
        case 0:
            filterIndex = .ByName
        case 1:
            filterIndex = .ByType
        case 2:
            filterIndex = .ByColor
        case 3:
            filterIndex = .ByStore
        default:
            assert(false, "Unhandled filter case")
        }
        searchController.searchBar.reloadInputViews()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            wardrobeModel.resetItemFilter()
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        wardrobeModel.resetItemFilter()
        tableView.reloadData()
        //let topRow = IndexPath(row: 0, section: 0)
        //tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
    }
    
}

// MARK:- AddItemDelegate
extension ClothingTableViewController : AddItemDelegate {
    
    func addNewItem(_ item: WardrobeItem) {
        wardrobeModel.addWardrobeItem(item)
        self.tableView.reloadData()
    }
    
    func updateItem(_ item: WardrobeItem, atIndexPath indexPath: IndexPath) {
        wardrobeModel.updateWardrobeItem(item, atIndexPath: indexPath)
        self.tableView.reloadData()
    }

}
