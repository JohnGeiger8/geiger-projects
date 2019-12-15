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

        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return wardrobeModel.numberOfOutfits
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wardrobeModel.numberOfItemsInOutfitFor(section: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OutfitItemCell", for: indexPath)
        
        cell.imageView?.image = UIImage(data: wardrobeModel.imageDataForOutfitItemFor(indexPath: indexPath))
        cell.backgroundColor = .backgroundColor
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "ToAddOutfit":
            let addOutfitController = segue.destination as? AddOutfitTableViewController
            addOutfitController?.view.backgroundColor = .backgroundColor
            addOutfitController?.tableView.backgroundColor = .backgroundColor
        default:
            assert(false, "Unhandled segue")
        }
    }
 

}
