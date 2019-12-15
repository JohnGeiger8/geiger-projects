//
//  OutfitItemTypeTableViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/14/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class OutfitItemTypeTableViewController: UITableViewController {

    var wardrobeModel = WardrobeModel.sharedinstance
    var chosenType : String?
    var addOutfitTableViewController : AddOutfitTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wardrobeModel.numberOfTypes
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
        cell.textLabel?.text = wardrobeModel.typeFor(indexPath: indexPath)
        cell.backgroundColor = .backgroundColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenType = wardrobeModel.typeFor(indexPath: indexPath)
        performSegue(withIdentifier: "SelectItemSegue", sender: self)
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "SelectItemSegue":
            let itemViewController = segue.destination as! OutfitWardrobeItemTableViewController
            itemViewController.tableView.backgroundColor = .backgroundColor
            itemViewController.view.backgroundColor = .backgroundColor
            itemViewController.itemsType = chosenType!
            
        default:
            assert(false, "Unhandled segue")
        }
    }
 
}
