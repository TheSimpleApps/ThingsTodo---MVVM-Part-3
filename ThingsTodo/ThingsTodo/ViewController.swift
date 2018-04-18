//
//  ViewController.swift
//  ThingsTodo
//
//  Created by Karamjeet Singh on 17/04/18.
//  Copyright © 2018 TheSimpleApps@gmail.com. All rights reserved.
//

import UIKit
protocol TodoViewUpdate: class {
    func itemInserted() -> ()
    func itemRemoved( at Index: Int) -> ()
}
class ViewController: UIViewController {
    
    @IBOutlet weak var tbl_ToDoList: UITableView!
    @IBOutlet weak var txt_ToDoText: UITextField!
    
    var viewModel: TodoViewModel?
    
    let identifier = "TodoItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      //  let nib = UINib(nibName: "TodoItemCell", bundle: nil)
       // tbl_ToDoList.register(nib, forCellReuseIdentifier: identifier)
        
        viewModel = TodoViewModel(view: self) // NOTE: view as self because we have created a extension of ToDoViewController and used TodoViewUpdate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action_Add(_ sender: Any) {
        
        
        guard  let newToDOItem = txt_ToDoText.text, !newToDOItem.isEmpty else {
            
            print("No todo value entered")
            return
        }
        
        // viewModel?.onToDoItemAdded(newValue: newToDOItem)
        viewModel?.newTodoValue = newToDOItem
        viewModel?.onToDoItemAdded()
    }
    
}

// UITableView datasource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.items.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TodoItemCell
        let itemViewModel = viewModel?.items[indexPath.row]
        
        
        cell?.configure(withVieModel: itemViewModel!)
        return cell!
    }
    
    
    
    
}

// UITableView delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemViewModel = viewModel?.items[indexPath.row]
        (itemViewModel as? TodoItemViewDelegate)?.onItemSelected()
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let itemViewModel = viewModel?.items[indexPath.row]
            viewModel?.onToDoItemDelete(itemId: (itemViewModel?.id)!)
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
}

// Refresh the UITableview after item added and clear the UITextfield
// Refresh the UITableview after item deleted
extension ViewController : TodoViewUpdate {
    func itemInserted() {
        
        //check if there is item then update else give error and return
        guard let items = viewModel?.items else {
            print("Items object is empty")
            return
        }
        
        txt_ToDoText.text = ""
        self.view.endEditing(true)
        self.tbl_ToDoList.beginUpdates()
        self.tbl_ToDoList.insertRows(at: [IndexPath(row:items.count-1, section: 0)], with: .automatic)
        self.tbl_ToDoList.endUpdates()
    }
    
    func itemRemoved(at Index: Int) {
        self.tbl_ToDoList.beginUpdates()
        self.tbl_ToDoList.deleteRows(at: [IndexPath(row:Index, section: 0)], with: .automatic)
        self.tbl_ToDoList.endUpdates()
    }
    
}
