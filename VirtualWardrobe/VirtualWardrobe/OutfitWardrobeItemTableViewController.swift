//
//  OutfitWardrobeItemTableViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/14/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class OutfitWardrobeItemTableViewController: UITableViewController {

    let wardrobeModel = WardrobeModel.sharedinstance
    var itemsType : String!
    var selectedItem : WardrobeItemMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let filter = {(wardrobeItem: WardrobeItemMO) in
            wardrobeItem.type!.contains(self.itemsType)
        }
        wardrobeModel.updateItemFilter(filter: filter)
        return wardrobeModel.numberOfClothes(forSection: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ClothingTableViewCell
        
        cell.itemImageView.image = UIImage(data: wardrobeModel.clothingImageDataFor(indexPath: indexPath)!)
        cell.itemNameLabel.text = wardrobeModel.clothingNameFor(indexPath: indexPath)
        cell.brandNameLabel.text = wardrobeModel.clothingBrandNameFor(indexPath: indexPath)
        cell.itemInfoLabel.text = wardrobeModel.clothingStoreNameFor(indexPath: indexPath)
        cell.backgroundColor = .backgroundColor

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedItem = wardrobeModel.clothingItemFor(indexPath: indexPath)
        performSegue(withIdentifier: "UnwindToAddOutfits", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "UnwindToAddOutfits":
            let addOutfitsViewController = segue.destination as! AddOutfitTableViewController
            addOutfitsViewController.addItemToOutfit(item: selectedItem!)
            
        default:
            assert(false, "Unhandled segue")
        }
    }
}
