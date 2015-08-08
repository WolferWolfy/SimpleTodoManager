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
    
    let converter = CoreDataConverter.sharedInstance
    
    var managedTodos = [NSManagedObject]()
    var todoItems = [TodoItem]()
    
    var managedCategories = [NSManagedObject]()
    var todoCategories = [TodoCategory]()
    
    var selectedIndex: Int?
    
    
    
    // MARK: - Business Logic
    
    // MARK: Todo Methods
    
    func saveTodo(todo: TodoItem) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Todo", inManagedObjectContext: managedContext)
        
        let todoItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        //3
        todoItem.setValue(todo.title, forKey: "title")
        todoItem.setValue(todo.itemDescription, forKey:"itemDescription")
        todoItem.setValue(todo.dueDate, forKey: "dueDate")
        
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

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName:"Todo")
        
        var fetchedResults : [NSManagedObject]?
        do {
            fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        }
        catch {
            print("Could not fetch \(error)")
        }
        
        if let results = fetchedResults {
            managedTodos  = results
            todoItems = converter.convertNSManagedObjectToTodoItems(managedTodos)
        }
    }
    
    func updateTodo(todo: TodoItem) {

        deleteTodo(selectedIndex!)
        
        saveTodo(todo)
    }
    
    func deleteTodo(index: Int) {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  managedTodos[index]
        
        managedContext.deleteObject(entity)
        
        do {
            try managedContext.save()
        }
        catch {
            print("Could not save \(error)")
        }
        //5
        managedTodos.removeAtIndex(index)
        todoItems = converter.convertNSManagedObjectToTodoItems(managedTodos)
    }
    
    //MARK: Category methods
    
    func saveCategory(category: TodoCategory) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Category", inManagedObjectContext: managedContext)
        
        let categoryItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        //3
        categoryItem.setValue(category.categoryName, forKey: "categoryName")
        categoryItem.setValue(category.categoryDescription, forKey: "categoryDescription")
        
     //   categoryItem.setValue(category.todos, forKey: "todos")
        
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
    
    
    func fetchCategories() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Category")
        
        var fetchedResults : [NSManagedObject]?
        do {
            fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        }
        catch {
            print("Could not fetch \(error)")
        }
        
        if let results = fetchedResults {
            managedCategories  = results
            todoCategories = converter.convertNSManagedObjectToTodoCategories(managedCategories)
        }
    }
    
    func updateCategory(category: TodoCategory) {
        
        deleteTodo(selectedIndex!)
        
        saveCategory(category)
    }
    
    func deleteCategory(index: Int) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  managedCategories[index]
        
        managedContext.deleteObject(entity)
        
        do {
            try managedContext.save()
        }
        catch {
            print("Could not save \(error)")
        }
        //5
        managedCategories.removeAtIndex(index)
        todoCategories = converter.convertNSManagedObjectToTodoCategories(managedCategories)
    }


}