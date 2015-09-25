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

    var sectionTitles = ["Todos"]
    var dataSource: [TodoItem]?
    
    let coreDataManager = CoreDataManager.sharedInstance
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        coreDataManager.fetchTodos()
        coreDataManager.fetchCategories()
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return coreDataManager.todoItems.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("TodoTableViewCell") as! TodoTableViewCell

        let todoItem = coreDataManager.todoItems[indexPath.row]
        cell.titleLabel.text = todoItem.title
        
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            coreDataManager.deleteTodo(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        coreDataManager.selectedTodoIndex = indexPath.row
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
          if  segue.identifier == "addTodo" {
            coreDataManager.selectedTodoIndex = nil
            let todoDetailsVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! TodoDetailsViewController
            todoDetailsVC.addCancelButton()
            return
        }

    }
    
}
