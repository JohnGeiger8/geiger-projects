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
    var outfitName : String?
    @IBOutlet weak var bottomBarView: UIView!
    
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
        case AddOutfitSections.OutfitName:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutfitName", for: indexPath) as! OutfitNameTableViewCell
            cell.outfitNameTextField.delegate = self
            cell.backgroundColor = .backgroundColor
            
            return cell
            
        case AddOutfitSections.WardrobeItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WardrobeItem", for: indexPath) as! OutfitItemTableViewCell
            if let imageData = wardrobeItems[indexPath.row].imageData {
                cell.itemImageView.image = UIImage(data: imageData)
            } else {
                cell.itemImageView.image = UIImage(named: "NoImageFound")
            }
            cell.itemNameLabel.text = wardrobeItems[indexPath.row].name
            cell.backgroundColor = .backgroundColor
            
            return cell
            
        case AddOutfitSections.AddNewItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewItem", for: indexPath) as! AddItemToOutfitTableViewCell
            cell.backgroundColor = .backgroundColor
            
            return cell
            
        default:
            assert(false, "Unhandled cell")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == AddOutfitSections.WardrobeItem {
            return 200
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    // MARK:- Create Outfit
    
    func addItemToOutfit(item: WardrobeItemMO) {
        
        wardrobeItems.append(item)
        wardrobeModel.addWardrobeItemRow()
        
        let indexPathSection = AddOutfitSections.WardrobeItem
        let indexPath = IndexPath(row: wardrobeItems.count-1, section: indexPathSection)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "ChooseTypeSegue":
            let typeViewController = segue.destination as! OutfitItemTypeTableViewController
            typeViewController.tableView.backgroundColor = .backgroundColor
            typeViewController.view.backgroundColor = .backgroundColor
            typeViewController.addOutfitTableViewController = self
            
        default:
            assert(false, "Unhandled segue")
        }
    }
    
    @IBAction func unwindToAddOutfit(_ segue: UIStoryboardSegue) {
        
    }
    
    // MARK:- Action Methods
    
    @IBAction func addNewItemCell(_ sender: Any) {
        
        wardrobeModel.addNewItemRow()
        
        let indexPathSection = AddOutfitSections.AddNewItem
        let indexPath = IndexPath(row: 0, section: indexPathSection)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
    }
    
    @IBAction func addOutfit(_ sender: Any) {
        
        // Outfit must have a name and at least one item.  Use alert to tell user
        guard outfitName != nil, outfitName != "" else {
            let alertController = UIAlertController(title: "Incomplete", message: "Please name the Outfit", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        guard wardrobeItems.count > 0 else {
            let alertController = UIAlertController(title: "Incomplete", message: "Please add at least 1 item to the outfit", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)

            return
        }
        
        wardrobeModel.addOutfit(outfitName!, withWardrobeItems: wardrobeItems)
        navigationController?.popViewController(animated: true)
    }
}

extension AddOutfitTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        outfitName = textField.text
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        outfitName = textField.text
        textField.resignFirstResponder()
        return true
    }
}
