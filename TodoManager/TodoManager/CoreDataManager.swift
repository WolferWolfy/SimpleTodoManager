//
//  CoreDataManager.swift
//  TodoManager
//
//  Created by Marton Imre Farkas on 26/07/15.
//  Copyright © 2015 Farkas Marton Imre. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    static let sharedInstance = CoreDataManager()
    
    var todos = [NSManagedObject]()
    
    var todoItems = [TodoItem]()
    var selectedIndex: Int?
    
    // MARK: Business Logic
    
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
      //      tableView.reloadData()
        }
    }
    
    func updateTodo(newTitle: String) {

        deleteTodo(selectedIndex!)
        
        saveTodo(newTitle)
        
        
        
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
     //   tableView.reloadData()
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