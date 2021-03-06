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
    
    var selectedTodoIndex: Int?
    var selectedCategoryIndex: Int?
    
    
    
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
        
        /*
        if let categoryIndex = selectedCategoryIndex {
            let managedCategory = managedCategories[categoryIndex]
            todoItem.setValue(managedCategory, forKey: "category")
            
        }*/
        
        if let managedCategory = managedCategoryForName(todo.todoCategory?.categoryName) {
             todoItem.setValue(managedCategory, forKey: "category")
        }
        
        
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
            todoItems = converter.convertNSManagedsObjectToTodoItems(managedTodos)
        }
    }
    
    func updateTodo(todo: TodoItem) {

        deleteTodo(selectedTodoIndex!)
        
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
        todoItems = converter.convertNSManagedsObjectToTodoItems(managedTodos)
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
            todoCategories = converter.convertNSManagedObjectsToTodoCategories(managedCategories)
        }
    }
    
    func updateCategory(category: TodoCategory) {
        
        deleteCategory(selectedCategoryIndex!)
        
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
        todoCategories = converter.convertNSManagedObjectsToTodoCategories(managedCategories)
    }
    
    func categoryForName(categoryName: String) -> TodoCategory? {
        
        for category in todoCategories {
            if category.categoryName == categoryName {
                return category
            }
        }
        
        return nil
    }
    
    func managedCategoryForName(categoryName: String?) -> NSManagedObject? {
        
        for category in managedCategories {
            let catNameString = category.valueForKey("CategoryName")as! String
            if  catNameString == categoryName {
                return category
            }
        }
        
        return nil
    }


}