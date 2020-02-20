//
//  RootViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 11/13/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        navigationController?.navigationBar.barTintColor = .navigationColor
    }

    // MARK:- Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToWardrobe":
            let wardrobeController = segue.destination as? ClothingTableViewController
            wardrobeController?.tableView.backgroundColor = .backgroundColor
            wardrobeController?.view.backgroundColor = .backgroundColor
            wardrobeController?.bottomBarView.backgroundColor = .navigationColor
            
        case "ToTrends":
            let trendsController = segue.destination as? TrendsViewController
            trendsController?.view.backgroundColor = .backgroundColor
            
        case "ToOutfits":
            let outfitsController = segue.destination as? OutfitTableViewController
            outfitsController?.tableView.backgroundColor = .backgroundColor
            outfitsController?.view.backgroundColor = .backgroundColor
            outfitsController?.bottomBarView.backgroundColor = .navigationColor
            
        default:
            assert(false, "Unhandled segue")
        }
    }

}
