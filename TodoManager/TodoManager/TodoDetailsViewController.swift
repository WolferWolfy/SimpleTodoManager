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
    var isNew = false
    
    let coreDataManager = CoreDataManager.sharedInstance
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let index = coreDataManager.selectedIndex {
            todoItem = coreDataManager.todoItems[index]
            // Do any additional setup after loading the view.
            titleTextField.text = todoItem?.title
            descriptionTextField.text = todoItem?.itemDescription
            if let dueDate = todoItem?.dueDate {
                 dueDatePicker.date = dueDate
            }
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
            
            coreDataManager.updateTodo(todo)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    }
  
    @IBAction func selectCategoryPressed(sender: UIButton) {
        
    }
}
