//
//  CoreDataConverter.swift
//  TodoManager
//
//  Created by Farkas Marton Imre on 07/08/15.
//  Copyright © 2015 Farkas Marton Imre. All rights reserved.
//

import Foundation
import CoreData

class CoreDataConverter {
    static let sharedInstance = CoreDataConverter()

    //MARK: Converters
    
    func convertNSManagedsObjectToTodoItems(managedObjects: [NSManagedObject]) -> [TodoItem] {
        // TODO: try block
        
        var todoItems = [TodoItem]()
        for managedTodo in managedObjects {
            let todo = TodoItem()
            if let title = managedTodo.valueForKey("title") as? String {
                todo.title = title
            }
            if let description = managedTodo.valueForKey("itemDescription") as? String {
                todo.itemDescription = description
            }
            if let dueDate = managedTodo.valueForKey("dueDate") as? NSDate {
                todo.dueDate = dueDate
            }
            if let category = managedTodo.valueForKey("category") as? NSManagedObject {
                 todo.todoCategory = convertNSManagedObjectToTodoCategory(category)
            }
            
            todoItems.append(todo)
        }
        return todoItems
    
    }
    
    func convertNSManagedObjectsToTodoCategories(managedObjects: [NSManagedObject]) -> [TodoCategory] {
        // TODO: try block
        
        var todoCategories = [TodoCategory]()
        for managedCategory in managedObjects {
            todoCategories.append(convertNSManagedObjectToTodoCategory(managedCategory))
        }
        return todoCategories
    }
    
    func convertNSManagedObjectToTodoCategory(managedCategory: NSManagedObject) -> TodoCategory {
        
        let category = TodoCategory()
        if let name = managedCategory.valueForKey("categoryName") as? String {
            category.categoryName = name
        }
        if let description = managedCategory.valueForKey("categoryDescription") as? String {
            category.categoryDescription = description
        }
        if let todos = managedCategory.valueForKey("todos") as? NSMutableArray {
            print(todos)
            //category.todos
        }
        
        return category
    }
}