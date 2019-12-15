//
//  AddOutfitTableViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/12/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class AddOutfitTableViewController: UITableViewController {

    let wardrobeModel = WardrobeModel.sharedinstance
    var wardrobeItems : [WardrobeItemMO] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return wardrobeModel.numberOfSectionsForAddOutfit
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return wardrobeModel.numberOfRowsInAddOutfitFor(section: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = wardrobeModel.typeOfCellFor(section: indexPath.section)
        switch cellType {
        case .OutfitName:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutfitName", for: indexPath) as! OutfitNameTableViewCell
            cell.outfitNameTextField.delegate = self
            cell.backgroundColor = .backgroundColor
            
            return cell
            
        case .WardrobeItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WardrobeItem", for: indexPath) as! OutfitItemTableViewCell
            //cell.itemImageView.image = UIImage(data: wardrobeModel.)
            cell.backgroundColor = .backgroundColor
            
            return cell
            
        case .AddNewItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewItem", for: indexPath) as! AddItemToOutfitTableViewCell
            cell.backgroundColor = .backgroundColor
            
            return cell
            
        default:
            assert(false, "Unhandled cell")
        }
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "ChooseTypeSegue":
            let typeViewController = segue.destination as! OutfitItemTypeTableViewController
            typeViewController.tableView.backgroundColor = .backgroundColor
            typeViewController.view.backgroundColor = .backgroundColor
            
        default:
            assert(false, "Unhandled segue")
        }
    }
    
    
    // MARK:- Action Methods
    
    @IBAction func addNewItemCell(_ sender: Any) {
        wardrobeModel.addNewItemRow()
        
        let indexPathSection = AddOutfitSections.AddNewItem.rawValue
        let indexPath = IndexPath(row: 0, section: indexPathSection)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
    }
}

extension AddOutfitTableViewController: UITextFieldDelegate {
    
    
}
