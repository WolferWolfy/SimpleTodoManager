//
//  TodoDetailsViewController.swift
//  TodoManager
//
//  Created by Marton Imre Farkas on 12/07/15.
//  Copyright © 2015 Farkas Marton Imre. All rights reserved.
//

import UIKit
import CoreData

class TodoDetailsViewController: UIViewController {
    
    var todoItem: TodoItem?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var isNew = false
    
    let coreDataManager = CoreDataManager.sharedInstance
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    //    self.navigationItem.hidesBackButton = true
   //     let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPressed")
    //    self.navigationItem.leftBarButtonItem = newBackButton;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        categoryLabel.text = ""
        
        if isNew == true {
            if (todoItem == nil) {
                todoItem = TodoItem()
            }
        }
        
        else {
            if let index = coreDataManager.selectedTodoIndex {
                todoItem = coreDataManager.todoItems[index]
                // Do any additional setup after loading the view.
                titleTextField.text = todoItem?.title
                descriptionTextField.text = todoItem?.itemDescription
                if let dueDate = todoItem?.dueDate {
                    dueDatePicker.date = dueDate
                }
            }
        }
        
        if let category = todoItem?.todoCategory {
            categoryLabel.text = category.categoryName
            print("didSelect, title: \(category.categoryName)")
        }
    }
    


    func addCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelButtonPressed:")
        self.navigationItem.leftBarButtonItem = cancelButton
        isNew = true
        
    }

    func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func backButtonPressed() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        print("done pressed")
        
        guard let todoTitle = titleTextField.text else {
            print("we fail")
            return
        }
        guard let todoDescription = descriptionTextField.text else {
            print("we fail")
            return
        }

        if isNew {
            let todo =  TodoItem()
            todo.title = todoTitle
            todo.itemDescription = todoDescription;
            todo.dueDate = dueDatePicker.date
            
            coreDataManager.saveTodo(todo)
            
            todoItem = todo;
            
            cancelButtonPressed(self)
        }
        else {
            //&
            print("update")
            guard let todo = todoItem else {
                print("we fail")
                return
            }

            todo.title = todoTitle
            todo.itemDescription = todoDescription;
            todo.dueDate = dueDatePicker.date
           // todo.todoCategory = TODO: cannot update/find category for a todo
            
            coreDataManager.updateTodo(todo)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    }
  
    @IBAction func selectCategoryPressed(sender: UIButton) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      //  let todoCategoryVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! TodoCategoryListViewController
       let todoCategoryVC = segue.destinationViewController as! TodoCategoryListViewController
        
        todoCategoryVC.todoDetailsVC = self
    }
    @IBAction func textFieldResign(sender: AnyObject) {
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
}
