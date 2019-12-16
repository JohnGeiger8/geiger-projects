//
//  SubTypeTableViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 11/24/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class SubTypeTableViewController: UITableViewController {
    
    let wardrobeModel = WardrobeModel.sharedinstance
    weak var delegate : TypeSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wardrobeModel.numberOfSubTypes
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubTypeTableViewCell", for: indexPath)

        cell.textLabel!.text = wardrobeModel.subTypeFor(indexPath: indexPath)
        cell.backgroundColor = .backgroundColor

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
        delegate?.selectSubType(wardrobeModel.subTypeFor(indexPath: indexPath))
    }
}
