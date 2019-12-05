//
//  AddItemViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 11/14/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit
import MapKit

protocol AddItemDelegate : NSObject {
    func addNewItem(_ item: WardrobeItem)
}

class AddItemViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, ImageSelectorDelegate, TypeSelectionDelegate {
    
    var fieldLabels : [UILabel] = []
    var userInputObjectDictionary = [String: [UIView]]() // holds uiview objects user will use to fill information based on label name
    var nameTextField : UITextField!
    var typeButton : CurvedEdgeButton!
    var subtypeButton : CurvedEdgeButton!
    var purchasedOnlineButton : CurvedEdgeButton!
    var purchasedInStoreButton : CurvedEdgeButton!
    var brandNameTextField : UITextField!
    
    // Item spacing
    let ySpacing = 12.0
    let xSpacing = 8.0

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var itemSubTypeLabel: UILabel!
    @IBOutlet weak var submitButton: CurvedEdgeButton!
    @IBOutlet weak var itemBrandTextField: UITextField!
    
    var imageSelector : ImageSelector?
    weak var delegate : AddItemDelegate?
    
    // WardrobeItem fields
    var imageData : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollView.delegate = self
        itemNameTextField.delegate = self
        
        imageSelector = ImageSelector(withDelegate: self)
        
        // Create all objects for user input
        createLabels()
        createUserInputDevices()
        
        // Need to set up handling for the keyboard appearing to keep everything visible when it appears
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func createLabels() {

        let labelNames = ["Name", "Type", "Subtype", "Purchased", "Brand"]//, "Date"]

        for name in labelNames {
            let label = UILabel(named: name)
            fieldLabels.append(label)
        }
    }
    
    func createUserInputDevices() {
        
        nameTextField = UITextField()
        userInputObjectDictionary["Name"] = [nameTextField]
        
        typeButton = CurvedEdgeButton(frame: CGRect.zero)
        subtypeButton = CurvedEdgeButton(frame: CGRect.zero)
        typeButton.imageView?.image = UIImage(named: "DropDownArrow")
        subtypeButton.imageView?.image = UIImage(named: "DropDownArrow")
        subtypeButton.isEnabled = false
        userInputObjectDictionary["Type"] = [typeButton]
        userInputObjectDictionary["Subtype"] = [subtypeButton]
        
        purchasedOnlineButton = CurvedEdgeButton(named: "Online")
        purchasedInStoreButton = CurvedEdgeButton(named: "In Store")
        userInputObjectDictionary["Purchased"] = [purchasedOnlineButton, purchasedInStoreButton]
        
        brandNameTextField = UITextField()
        userInputObjectDictionary["Brand"] = [brandNameTextField]
        
        //purchaseDatePicker = UIDatePicker()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        // Add gesture recognizer for adding an image for the item
        let tapSelector = #selector(addImage(_:))
        let addImageTap = UITapGestureRecognizer(target: self, action: tapSelector)
        addImageTap.delegate = self
        itemImageView.addGestureRecognizer(addImageTap)
        itemImageView.isUserInteractionEnabled = true
        
        mainScrollView.contentSize = self.view.frame.size
        
        // Layout all objects for user input
        var currentY = Double(itemImageView.frame.origin.y + itemImageView.frame.height) + ySpacing
        
        for label in fieldLabels {
            let origin = CGPoint(x: xSpacing, y: currentY)
            label.frame.origin = origin
            label.frame.size = label.intrinsicContentSize
            currentY = currentY + Double(label.frame.size.height) + ySpacing
            
            // Now do layout of actual user input objects
            if let views = userInputObjectDictionary[label.text!] {
                let currentX = xSpacing
                for view in views {
                    
                }
            }
            
            mainScrollView.addSubview(label)
        }
    }
    
    // MARK:- Image Selector Delegate
    func selectedImage(image: UIImage) {
        
        itemImageView.image = image
        imageData = image.jpegData(compressionQuality: 1.0)
    }
    
    //MARK:- Type Selection Delegate
    func selectType(_ type: String) {
        
        itemTypeLabel.text = type
    }
    
    func selectSubType(_ type: String) {
        
        itemSubTypeLabel.text = type
    }
    
    // MARK:- Keyboard Handlers
    @objc func keyboardWillShow(notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let contentInsets =  UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        mainScrollView.contentInset = contentInsets
//        mainScrollView.setContentOffset(CGPoint(x: 0.0, y: buildingInfoTextView.frame.origin.y), animated: true)
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        
        mainScrollView.contentInset = UIEdgeInsets.zero
        mainScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK:- Gesture Recognizers
    
    @objc func addImage(_ sender: UITapGestureRecognizer) {
        
        imageSelector?.present(withViewController: self)
    }
    
    // MARK:- Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ChooseTypeSegue":
            let navigationViewController = segue.destination as! UINavigationController
            let typeTableViewController = navigationViewController.topViewController as! TypeTableViewController
            typeTableViewController.delegate = self
            
        case "ChooseSubTypeSegue":
            let navigationViewController = segue.destination as! UINavigationController
            let subtypeTableViewController = navigationViewController.topViewController as! SubTypeTableViewController
            subtypeTableViewController.delegate = self
            
        case "UnwindFromAddItem":
            print("Back to Wardrobe")
            
        default:
            assert(false, "Unhandled segue from AddItemViewController")
        }
    }
    
    @IBAction func unwindToAddItemSegue(segue: UIStoryboardSegue) {
        
    }
    
    // MARK:- Action Methods
    @IBAction func chooseItemSubType(_ sender: Any) {
    }
    
    @IBAction func submitItem(_ sender: Any) {
        guard itemNameTextField.text != "", itemTypeLabel.text != "Choose..." else { return }
        
        let newItem = WardrobeItem(name: itemNameTextField.text!, type: itemTypeLabel.text!, subType: itemSubTypeLabel.text!, colors: [], seasons: [], brandName: itemBrandTextField.text!, price: nil, storeName: "", storeLocation: nil, imageName: "", imageData: imageData, dateOfPurchase: nil)
        delegate?.addNewItem(newItem)
        dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK:- Image Picker

protocol ImageSelectorDelegate: NSObject {
    func selectedImage(image: UIImage)
}

class ImageSelector : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePickerViewController : UIImagePickerController
    weak var imageSelectorDelegate : ImageSelectorDelegate?
    
    init(withDelegate delegate: ImageSelectorDelegate) {
        
        imagePickerViewController = UIImagePickerController()
        super.init()
        
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        
        imageSelectorDelegate = delegate
    }
    
    func present(withViewController viewController: UIViewController) {
        
        // Let user choose between their camera and photos
        let photoAlertController = UIAlertController(title: "How?", message: nil, preferredStyle: .alert)
        
        // Create actions for each way of changing the photo
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        photoAlertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Use Camera", style: .default) { (action) in
                
                viewController.present(self.imagePickerViewController, animated: true, completion: nil)
            }
            photoAlertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let photoAction = UIAlertAction(title: "Browse Photos", style: .default) { (action) in
                guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return }
                
                viewController.present(self.imagePickerViewController, animated: true, completion: nil)
            }
            photoAlertController.addAction(photoAction)
        }
        
        viewController.present(photoAlertController, animated: true, completion: nil)
    }
    
    // MARK:- Image Picker Controller Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            imageSelectorDelegate?.selectedImage(image: selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
