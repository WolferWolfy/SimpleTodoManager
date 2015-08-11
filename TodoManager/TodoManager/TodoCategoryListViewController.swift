//
//  TodoCategoryListViewController.swift
//  TodoManager
//
//  Created by Farkas Marton Imre on 07/08/15.
//  Copyright © 2015 Farkas Marton Imre. All rights reserved.
//

import UIKit

class TodoCategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var todoDetailsVC: TodoDetailsViewController!
    
    let coreDataManager = CoreDataManager.sharedInstance
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
          tableView.registerClass(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        coreDataManager.fetchCategories()
        tableView.reloadData()
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return coreDataManager.todoCategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        let todoCategory = coreDataManager.todoCategories[indexPath.row]
        cell.textLabel!.text = todoCategory.categoryName
        if let todos = todoCategory.todos {
           cell.detailTextLabel!.text = String(todos.count)
        } else {
            cell.detailTextLabel?.text = "0";
        }
       // cell.detailTextLabel!.text = String(todoCategory.todos?.count)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            coreDataManager.deleteCategory(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        coreDataManager.selectedCategoryIndex = indexPath.row
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let todoItem = todoDetailsVC.todoItem {
            todoItem.todoCategory = coreDataManager.todoCategories[indexPath.row];
            print("didSelect, title: \(todoItem.todoCategory?.categoryName)")
 //           coreDataManager.updateTodo(todoItem)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        todoDetailsVC.navigationController?.popViewControllerAnimated(true)
        //self.navigationController?.popToRootViewControllerAnimated(true)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if  segue.identifier == "addCategory" {
            coreDataManager.selectedCategoryIndex = nil
            let todoCategoryDetailsVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! TodoCategoryDetailsViewController
            todoCategoryDetailsVC.addCancelButton()
            todoCategoryDetailsVC.title = "Add Category"
            return
        }
        
    }
    
    
    @IBAction func Grr(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
