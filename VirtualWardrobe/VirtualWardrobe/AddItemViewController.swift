//
//  AddItemViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 11/14/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

//protocol AddItemDelegate {
//    
//}

class AddItemViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var submitButton: CurvedEdgeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollView.delegate = self
        itemNameTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        mainScrollView.contentSize = self.view.frame.size
    }
    
    
}
