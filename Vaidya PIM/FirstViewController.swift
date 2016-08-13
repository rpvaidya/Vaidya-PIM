//
//  FirstViewController.swift
//  Vaidya PIM
//
//  Created by Vaidya, Raghavendra (GE Global Research) on 6/23/16.
//  Copyright © 2016 Vaidya, Raghavendra (GE Global Research). All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var genericPicker: UIPickerView!
    
    
    
    var currentSelectedItem = 0
    
    var currentData = [""]
    var categoryData = [""]
    var belongsToData = ["Vaidya,Anita,Aaditya,Amogh"]
    var itemData = [""]
    var webAddress  = ""
    var uid  = ""
    var pwd  = ""
    var act: Account = Account()
    
    @IBOutlet weak var catField: UITextField!
    @IBOutlet weak var belongsToField: UITextField!
    @IBOutlet weak var itemDataField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var acctDetails: UITextView!
    
    @IBAction func updateAccount(sender: AnyObject) {
        let sync : DBSync = DBSync()
        sync.syncDataBAse()
    }
    
    
    func loadCategoriesFromDB ()
    {
        
        
    }
    
    
    @IBAction func itemExit(sender: AnyObject) {
        
        genericPicker.hidden = true
        act = ModelManager.getTagProperties(itemDataField.text!)
        
        var acctDetailsString: String = ""
        
        if act.Name != "" {
            acctDetailsString += "Name : "
            acctDetailsString += act.Name + "\n"
        }
        if act.Address != "" {
            acctDetailsString += "Address : "
            acctDetailsString += act.Address + "\n"
            
        }
        if act.Description != "" {
            acctDetailsString += "Description : "
            acctDetailsString += act.Description + "\n"
        }
        if act.Number != "" {
            acctDetailsString += "Number : "
            acctDetailsString += act.Number + "\n"
        }
        if act.Valid_From != "" {
            acctDetailsString += "Valid From : "
            acctDetailsString += act.Valid_From + "\n"
            
        }
        if act.Valid_To != "" {
            acctDetailsString += "Valid To : "
            acctDetailsString += act.Valid_To + "\n"
            
        }
        if act.web_address != "" {
            acctDetailsString += "Web Address : "
            acctDetailsString += act.web_address + "\n"
        }
        if act.UID != "" {
            acctDetailsString += "User ID : "
            acctDetailsString += act.UID + "\n"
        }
        if act.PWD != "" {
            acctDetailsString += "Password : "
            acctDetailsString += act.PWD + "\n"
        }
        
        acctDetails.text = acctDetailsString
        acctDetails.font = UIFont(name: "Arial", size: 17)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genericPicker.hidden = true
        categoryData = ModelManager.getCategories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func catEdit(sender: AnyObject) {
        currentData = categoryData
        genericPicker.hidden = false
        genericPicker.reloadAllComponents()
        currentSelectedItem = 1
    }
    
    @IBAction func itemEdit(sender: AnyObject) {
        itemData = ModelManager.getTagsForCat(catField.text!)
        currentData = itemData
        genericPicker.hidden = false
        genericPicker.reloadAllComponents()
        currentSelectedItem = 2
    }
    @IBAction func belongsToEdit(sender: AnyObject) {
        currentData = belongsToData
        genericPicker.hidden = false
        genericPicker.reloadAllComponents()
        currentSelectedItem = 3
    }
    @IBAction func catFieldExit(sender: AnyObject) {
        
        genericPicker.hidden = true
        
    }
    @IBAction func catFieldLeft(sender: AnyObject) {
        
        genericPicker.hidden = true
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let value = currentData[genericPicker.selectedRowInComponent(0)]
        switch currentSelectedItem {
        case 1:
            catField.text = value
//            ModelManager.getTagsForCat(catField.text!)
        case 2:
            itemDataField.text = value
        case 3:
            belongsToField.text = value
        default:
            catField.text = ""
            
        }
        
    }
    
}

