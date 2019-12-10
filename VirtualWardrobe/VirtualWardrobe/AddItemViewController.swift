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
    func updateItem(_ item: WardrobeItem, atIndexPath indexPath: IndexPath)
}

class AddItemViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, TypeSelectionDelegate, PurchaseDateDelegate, ImageSelectorDelegate {
    
    var fieldLabels : [UILabel] = []
    var userInputObjectDictionary = [String: [UIView]]() // holds uiview objects user will use to fill information based on label name
    var nameTextField : UserInputTextField!
    var typeButton : CurvedEdgeButton!
    var subtypeButton : CurvedEdgeButton!
    var purchaseSourceTextField : UserInputTextField!
    var brandNameTextField : UserInputTextField!
    var purchaseDateButton : CurvedEdgeButton!
    var colorTextFields : [UserInputTextField] = []
    
    var isTypeSelected : Bool = false
    
    // Item spacing
    let ySpacing = 15.0
    let xSpacing = 8.0

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var submitButton: CurvedEdgeButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var imageSelector : ImageSelector?
    weak var delegate : AddItemDelegate?
    
    // Item selection fields
    var selectedItemIndexPath : IndexPath?

    // WardrobeItem fields
    var imageData : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSelector = ImageSelector(withDelegate: self)
        
        // Create all objects for user input
        createLabels()
        createUserInputDevices()
        
        // Need to set up handling for the keyboard appearing to keep everything visible when it appears
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Need Gesture Recognizer for getting rid of keyboard
        let dismissTap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(dismissTap)
    }
    
    func createLabels() {

        let labelNames = ["Name", "Type", "Subtype", "Purchased", "Brand", "Date Purchased", "Colors"]

        for name in labelNames {
            let label = UILabel(named: name)
            fieldLabels.append(label)
        }
    }
    
    func createUserInputDevices() {
        
        nameTextField = UserInputTextField()
        nameTextField.placeholder = "Name"
        userInputObjectDictionary["Name"] = [nameTextField]
        
        typeButton = CurvedEdgeButton(named: "Choose Item Type")
        subtypeButton = CurvedEdgeButton(named: "Choose Item Subtype")
        subtypeButton.isEnabled = false
        typeButton.addTarget(self, action: #selector(chooseItemType(_:)), for: .touchUpInside)
        subtypeButton.addTarget(self, action: #selector(chooseItemSubtype(_:)), for: .touchUpInside)
        userInputObjectDictionary["Type"] = [typeButton]
        userInputObjectDictionary["Subtype"] = [subtypeButton]
        
        purchaseSourceTextField = UserInputTextField()
        purchaseSourceTextField.placeholder = "Store/Website Name"
        userInputObjectDictionary["Purchased"] = [purchaseSourceTextField]
        
        brandNameTextField = UserInputTextField()
        brandNameTextField.placeholder = "Brand name"
        userInputObjectDictionary["Brand"] = [brandNameTextField]
        
        purchaseDateButton = CurvedEdgeButton(named: "Choose Date")
        purchaseDateButton.addTarget(self, action: #selector(chooseItemPurchaseDate(_:)), for: .touchUpInside)
        userInputObjectDictionary["Date Purchased"] = [purchaseDateButton]
        
        let colorTextField = UserInputTextField()
        colorTextField.placeholder = "E.g. Blue"
        colorTextFields.append(colorTextField)
        userInputObjectDictionary["Colors"] = colorTextFields
        
        mainScrollView.delegate = self
        nameTextField.delegate = self
        purchaseSourceTextField.delegate = self
        brandNameTextField.delegate = self
        colorTextField.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        
        // Add gesture recognizer for adding an image for the item
        let tapSelector = #selector(addImage(_:))
        let addImageTap = UITapGestureRecognizer(target: self, action: tapSelector)
        addImageTap.delegate = self
        itemImageView.addGestureRecognizer(addImageTap)
        itemImageView.isUserInteractionEnabled = true
        
        // Layout all objects for user input
        var currentY = Double(itemImageView.frame.origin.y + itemImageView.frame.height) + ySpacing
        
        for label in fieldLabels {
            let origin = CGPoint(x: xSpacing, y: currentY)
            label.frame.origin = origin
            label.frame.size = label.intrinsicContentSize
            
            let labelFrame = label.frame
            // Now do layout of actual user input objects corresponding to this label
            if let views = userInputObjectDictionary[label.text!] {
                let currentX = xSpacing + Double(labelFrame.origin.x + labelFrame.width)
                for aView in views {
                    let viewOrigin = CGPoint(x: currentX, y: currentY)
                    let width = (Double(self.view.frame.width) - currentX -  xSpacing)
                    let viewSize = CGSize(width: width, height: 28.0)
                    aView.frame = CGRect(origin: viewOrigin, size: viewSize)
                    mainScrollView.addSubview(aView)
                    
                    currentY = currentY + Double(label.frame.size.height) + ySpacing
                }
            }
            
            mainScrollView.addSubview(label)
        }
        let bottomLabel = fieldLabels.last!
        let scrollViewHeight = bottomLabel.frame.origin.y + bottomLabel.frame.size.height + CGFloat(ySpacing)
        mainScrollView.contentSize = CGSize(width: view.frame.width, height: scrollViewHeight)
    }
    
    //MARK:- Type Selection Delegate
    func selectType(_ type: String) {
        
        typeButton.setTitle(type, for: .normal)
        isTypeSelected = true
        subtypeButton.isEnabled = true
    }
    
    func selectSubType(_ type: String) {
        
        subtypeButton.setTitle(type, for: .normal)
    }
    
    func selectPurchaseDate(_ date: Date) {
        
        purchaseDateButton.setTitle(" Date here ", for: .normal)
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
            let typeTableViewController = segue.destination as! TypeTableViewController
            typeTableViewController.delegate = self
            typeTableViewController.tableView.backgroundColor = .backgroundColor
            typeTableViewController.view.backgroundColor = .backgroundColor
            
        case "ChooseSubTypeSegue":
            let subtypeTableViewController = segue.destination as! SubTypeTableViewController
            subtypeTableViewController.delegate = self
            subtypeTableViewController.tableView.backgroundColor = .backgroundColor
            subtypeTableViewController.view.backgroundColor = .backgroundColor
            
        case "ChooseDateSegue":
            let dateViewController = segue.destination as! DatePickerViewController
            dateViewController.delegate = self
            dateViewController.view.backgroundColor = .backgroundColor
            
        case "UnwindFromItemDetail":
            break
            
        default:
            assert(false, "Unhandled segue from AddItemViewController")
        }
    }
    
    @IBAction func unwindToAddItemSegue(segue: UIStoryboardSegue) {
        
    }
    
    // MARK:- Action and Obj-C Methods
    
    @objc func chooseItemType(_ sender: UIButton) {
        performSegue(withIdentifier: "ChooseTypeSegue", sender: sender)
    }
    
    @objc func chooseItemSubtype(_ sender: UIButton) {
        performSegue(withIdentifier: "ChooseSubTypeSegue", sender: sender)
    }
    
    @objc func chooseItemPurchaseDate(_ sender: UIButton) {
        performSegue(withIdentifier: "ChooseDateSegue", sender: sender)
    }
    
    @IBAction func submitItem(_ sender: Any) {
        guard nameTextField.text != "", isTypeSelected else { return }
        // FIXME: Add size
        let newItem = WardrobeItem(name: nameTextField.text!, type: typeButton.titleLabel!.text!, size: "Medium", subType: subtypeButton.titleLabel!.text, colors: [], seasons: [], brandName: brandNameTextField.text!, price: nil, storeName: purchaseSourceTextField.text!, storeLocation: nil, imageName: "", imageData: imageData, dateOfPurchase: nil)//purchaseDateButton.title(for: .normal)) FIXME: date of purchase
        delegate?.addNewItem(newItem)
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- Configure controller for a Detail view
extension AddItemViewController {
    
    func configureForDetailView(item: WardrobeItemMO, atIndexPath indexPath: IndexPath) {
        
        selectedItemIndexPath = indexPath
        titleLabel.text = item.name
        nameTextField.text = item.name
        typeButton.setTitle(item.type, for: .normal)
        subtypeButton.setTitle(item.subtype, for: .normal)
        purchaseSourceTextField.text = item.storeName
        brandNameTextField.text = item.brandName
        purchaseDateButton.setTitle("item.dateOfPurchase", for: .normal)
        
        if let itemImageData = item.imageData {
            let itemImage = UIImage(data: itemImageData)
            itemImageView.image = itemImage!
            
            imageData = itemImageData
        }
        else {
            let itemImage = UIImage(named: "noImageFound")
            itemImageView.image = itemImage!
        }
        
        // Fields shouldn't be editable by default
        for inputObjects in userInputObjectDictionary.values {
            for viewObject in inputObjects {
                viewObject.isUserInteractionEnabled = false
            }
        }
        
        submitButton.isHidden = true
        editButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    @IBAction func toggleEditingFields(_ sender: Any) {
        
        if editButton.title(for: .normal) == "Edit" {
            editButton.setTitle("Done", for: .normal)
        }
        else {
            editButton.setTitle("Edit", for: .normal)
            submitItemChanges()
        }
        
        // Toggle fields' editable properties
        for inputObjects in userInputObjectDictionary.values {
            for viewObject in inputObjects {
                viewObject.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func submitItemChanges() {
        // FIXME: Add size and colors and seasons
        let item = WardrobeItem(name: nameTextField.text!, type: typeButton.title(for: .normal)!, size: "Medium", subType: subtypeButton.title(for: .normal), colors: [], seasons: [], brandName: brandNameTextField.text!, price: nil, storeName: "", storeLocation: nil, imageName: "", imageData: imageData, dateOfPurchase: nil)
        delegate?.updateItem(item,  atIndexPath: selectedItemIndexPath!)
    }

    // MARK:- Date Purchased Delegate
    
    func choosePurchaseDate(_ date: Date) {
        selectPurchaseDate(date)
    }

    // MARK:- Image Selector Delegate
  
    func selectedImage(image: UIImage) {
        
        itemImageView.image = image
        imageData = image.jpegData(compressionQuality: 1.0)
    }
}

extension AddItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
}

// MARK:- Image Selector

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
