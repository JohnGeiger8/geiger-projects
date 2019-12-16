//
//  ItemDetailViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/15/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController, EditItemDelegate {
    
    var wardrobeModel = WardrobeModel.sharedinstance

    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPurchaseLabel: UILabel!
    @IBOutlet weak var datePurchasedLabel: UILabel!
    @IBOutlet weak var itemBrandLabel: UILabel!
    
    var wardrobeItem : WardrobeItemMO!
    var itemIndexPath : IndexPath!
    
    let font = UIFont(name: "Marker Felt", size: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewObjects()
    }
    
    func configureViewObjects() {
        
        // Colors
        itemTitleLabel.textColor = .primaryTextColor
        itemPurchaseLabel.textColor = .primaryTextColor
        itemBrandLabel.textColor = .primaryTextColor
        datePurchasedLabel.textColor = .primaryTextColor
        
        // Fonts
        itemTitleLabel.font = font
        itemPurchaseLabel.font = font
        itemBrandLabel.font = font
        datePurchasedLabel.font = font
        
        // Item information
        itemTitleLabel.text = wardrobeItem.name!
        itemPurchaseLabel.text = "Purchased at:\n" + wardrobeItem.storeName!
        datePurchasedLabel.text = "On Date:\n" + wardrobeItem.dateOfPurchase!.string
        itemBrandLabel.text = "Brand:\n" + wardrobeItem.brandName!
        if let imageData = wardrobeItem.imageData {
            itemImageView.image = UIImage(data: imageData)
        } else {
            itemImageView.image = UIImage(named: "noImageFound")
        }
        
        // Go to internet for website name
        let goToInternetTap = UITapGestureRecognizer(target: self, action: #selector(goToWebsite(_:)))
        itemPurchaseLabel.addGestureRecognizer(goToInternetTap)
        itemPurchaseLabel.isUserInteractionEnabled = true
    }
    
    @objc func goToWebsite(_ tapGesture: UITapGestureRecognizer) {
        
        if let url = URL(string: "https://" + wardrobeItem.storeName!) {
            if UIApplication.shared.canOpenURL(url) {
                let alertController = UIAlertController(title: "Leave Virtual Wardrobe?", message: "URL's safety is unknown. Would you like to open Safari?", preferredStyle: .actionSheet)
                let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: {(alert) in
                    
                    UIApplication.shared.open(url)
                })
                let denyAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alertController.addAction(confirmAction)
                alertController.addAction(denyAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                googleSearch()
            }
        } else {
            googleSearch()
        }
    }
    
    func googleSearch() {
        let alertController = UIAlertController(title: "Invalid URL/No application available to open URL", message: "Would you like to perform a Google search instead?", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: {(alert) in
            
            let googleSearch = "https://www.google.com/search?q=" + self.wardrobeItem.storeName!.replacingOccurrences(of: " ", with: "+")
            if let url = URL(string: googleSearch) {
                guard UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
            }
        })
        let denyAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(denyAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToDetail(_ segue: UIStoryboardSegue) {
    }
    
    
    @IBAction func editItem(_ sender: Any) {
        
        let editItemViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as? AddItemViewController)

        self.present(editItemViewController!, animated: true, completion: {
            
            editItemViewController?.configureForDetailView(item: self.wardrobeItem)
            editItemViewController?.editDelegate = self
            editItemViewController?.view.backgroundColor = .navigationColor
            editItemViewController?.mainScrollView.backgroundColor = .backgroundColor
        })

    }
    
    // MARK:- Edit Item Delegate
    
    func updateItem(_ item: WardrobeItem) {
        wardrobeModel.updateWardrobeItem(item, atIndexPath: itemIndexPath)
        
        itemTitleLabel.text = item.name
        itemPurchaseLabel.text = "Purchased at:\n" + item.storeName!
        datePurchasedLabel.text = "On Date:\n" + item.dateOfPurchase!.string
        itemBrandLabel.text = "Brand:\n" + item.brandName!
        if let imageData = wardrobeItem.imageData {
            itemImageView.image = UIImage(data: imageData)
        } else {
            itemImageView.image = UIImage(named: "noImageFound")
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "ToAddItem":
//
//        default:
//
//        }
    }
 

}
