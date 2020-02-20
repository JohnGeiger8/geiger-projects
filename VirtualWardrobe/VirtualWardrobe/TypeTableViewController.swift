//
//  TypeTableViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 11/23/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

protocol TypeSelectionDelegate : NSObject {
    func selectType(_ type: String)
    func selectSubType(_ type: String)
}

class TypeTableViewController: UITableViewController {
    
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
        
        return wardrobeModel.numberOfTypes
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeTableViewCell", for: indexPath)

        cell.textLabel?.text = wardrobeModel.typeFor(indexPath: indexPath)
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
        delegate?.selectType(wardrobeModel.typeFor(indexPath: indexPath))
    }
}
