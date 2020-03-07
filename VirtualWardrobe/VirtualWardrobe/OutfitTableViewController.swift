//
//  OutfitTableViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/12/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class OutfitTableViewController: UITableViewController {
    
    let wardrobeModel = WardrobeModel.sharedinstance
    @IBOutlet weak var bottomBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return wardrobeModel.numberOfOutfits
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wardrobeModel.numberOfItemsInOutfitFor(section: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OutfitTableViewCell", for: indexPath) as! OutfitItemTableViewCell
        
        if let imageData = wardrobeModel.imageDataOfOutfitFor(indexPath: indexPath) {
            cell.itemImageView.image = UIImage(data: imageData)
        } else {
            cell.itemImageView.image = UIImage(named: "noImageFound")
        }
        cell.itemNameLabel.text = wardrobeModel.itemNameForOutfitAt(indexPath: indexPath)
        cell.backgroundColor = .backgroundColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionTitle = wardrobeModel.outfitNameFor(section: section)
        return sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }

    // MARK:- Item Deletion

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the outfit from the data source
            wardrobeModel.deleteOutfitAt(indexPath: indexPath)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .left)
            
        } else if editingStyle == .insert {
            
        }    
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete Outfit") { (action, view, completion) in
            
            self.wardrobeModel.deleteOutfitAt(indexPath: indexPath)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            self.tableView.deleteSections(indexSet, with: .left)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeAction
    }
 

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "ToAddOutfit":
            let addOutfitController = segue.destination as? AddOutfitTableViewController
            addOutfitController?.view.backgroundColor = .backgroundColor
            addOutfitController?.tableView.backgroundColor = .backgroundColor
            addOutfitController?.bottomBarView.backgroundColor = .navigationColor
            
        default:
            assert(false, "Unhandled segue")
        }
    }
 

}
