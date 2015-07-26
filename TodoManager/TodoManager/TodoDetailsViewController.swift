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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    var isNew = false
    
    let coreDataManager = CoreDataManager.sharedInstance
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let index = coreDataManager.selectedIndex {
            todoItem = coreDataManager.todoItems[index]
            // Do any additional setup after loading the view.
            titleTextField.text = todoItem?.title
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
        

        if isNew {
            coreDataManager.saveTodo(titleTextField.text)
            cancelButtonPressed(self)
        }
        else {
            //&
            print("update")
            guard let todo = todoItem else {
                print("we fail")
                return
            }
            guard let todoTitle = titleTextField.text else {
                print("we fail")
                return
            }
            
            todo.title = todoTitle
            
            coreDataManager.updateTodo(todoTitle)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    }
  
}
