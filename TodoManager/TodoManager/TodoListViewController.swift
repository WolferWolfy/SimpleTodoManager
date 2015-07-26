//
//  TodoListViewController.swift
//  TodoManager
//
//  Created by Farkas Marton Imre on 15/06/15.
//  Copyright © 2015 Farkas Marton Imre. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var todos = [NSManagedObject]()
    var todoItems = [TodoItem]()
    var selectedIndex: Int?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
      //  tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTodos()
        
    }

    
    // MARK: Business Logic
    
    func fetchTodos() {
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
            self.convertNSManagedObjectToTodoItem(todos)
            tableView.reloadData()
        }
    }
    func deleteTodo(index: Int) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  todos[index]
        
        managedContext.deleteObject(entity)
        
        do {
            try managedContext.save()
        }
        catch {
            print("Could not save \(error)")
        }
        //5
        todos.removeAtIndex(index)
        self.convertNSManagedObjectToTodoItem(todos)
        tableView.reloadData()
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoTableViewCell") as! TodoTableViewCell
        
        let todoItem = todoItems[indexPath.row]
        cell.textLabel!.text = todoItem.title

        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteTodo(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
          if  segue.identifier == "addTodo" {
            let todoDetailsVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! TodoDetailsViewController
            todoDetailsVC.addCancelButton()
            return
        }

        guard let todoDetailsVC =  segue.destinationViewController as? TodoDetailsViewController else {
            // pech
            return
        }
            
        // Do stuff with x
        todoDetailsVC.todoItem = todoItems[selectedIndex!]

    }
    
    
    //MARK: Converters
    
    func convertNSManagedObjectToTodoItem(managedObjects: [NSManagedObject]) {
        todoItems = [TodoItem]()
        for managedTodo in managedObjects {
            let todo = TodoItem()
            todo.title = managedTodo.valueForKey("title") as! String
            todoItems.append(todo)
        }
    }
}

