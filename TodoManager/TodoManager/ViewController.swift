//
//  ViewController.swift
//  TodoManager
//
//  Created by Farkas Marton Imre on 15/06/15.
//  Copyright © 2015 Farkas Marton Imre. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var todos = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Todo")
        
        //3
        
        var fetchedResults : [NSManagedObject]?
        do {
            fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        }
        catch {
            print("Could not fetch \(error)")
        }
        
        if let results = fetchedResults {
            todos  = results
        }
    }


    @IBAction func addItem(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New name",  message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as UITextField!
                self.saveTodo(textField.text)
                self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
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
        todos.append(todoItem)
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        let todoItem = todos[indexPath.row]
        cell.textLabel!.text = todoItem.valueForKey("title") as? String

        return cell
    }
    
    
   }

