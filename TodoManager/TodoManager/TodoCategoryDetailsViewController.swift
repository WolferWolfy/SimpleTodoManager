//
//  TodoCategoryDetailsViewController.swift
//  TodoManager
//
//  Created by Farkas Marton Imre on 08/08/15.
//  Copyright © 2015 Farkas Marton Imre. All rights reserved.
//

import UIKit
import CoreData

class TodoCategoryDetailsViewController: UIViewController {
    
    var todoCategory: TodoCategory?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var isNew = false
    
    let coreDataManager = CoreDataManager.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = coreDataManager.selectedCategoryIndex {
            todoCategory = coreDataManager.todoCategories[index]
            // Do any additional setup after loading the view.
            nameTextField.text = todoCategory?.categoryName
            descriptionTextField.text = todoCategory?.categoryDescription
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func addCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelButtonPressed:")
        self.navigationItem.leftBarButtonItem = cancelButton
        isNew = true
        
    }
    
    func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        print("done pressed")
        
        guard let categoryName = nameTextField.text else {
            print("we fail")
            return
        }
        guard let categoryDescription = descriptionTextField.text else {
            print("we fail")
            return
        }
        
        if isNew {
            let category = TodoCategory()
            category.categoryName = categoryName
            category.categoryDescription = categoryDescription
            
            coreDataManager.saveCategory(category)
            
            todoCategory = category;
            
            cancelButtonPressed(self)
        }
        else {
            //&
            print("update")
            guard let category = todoCategory else {
                print("we fail")
                return
            }
            
            category.categoryName = categoryName
            category.categoryDescription = categoryDescription
            
            coreDataManager.updateCategory(category)
            
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    @IBAction func selectCategoryPressed(sender: UIButton) {
        
    }
}
