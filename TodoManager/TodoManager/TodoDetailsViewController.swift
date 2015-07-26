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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.text = todoItem?.title
        
      //  self.addCancelButton()
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
            self.saveTodo(titleTextField.text)
            cancelButtonPressed(self)
        }
        else {
            print("update")
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func saveTodo(title: String?) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Todo", inManagedObjectContext: managedContext)
        
        let todoItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        //3
        todoItem.setValue(title, forKey: "title")
        
        //4
        do {
            try managedContext.save()
        }
        catch {
            print("Could not save \(error)")
        }
        //5
        // todos.append(todoItem)
       
    }
  
}
