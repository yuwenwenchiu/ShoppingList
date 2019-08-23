//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by Yuwen Chiu on 2019/8/20.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UITableViewController {
    
    var shoppingItems = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadList()
    }
    
    func saveList() {
        
        let shoppingItemsDic = shoppingItems.map { (Item) -> [String: Any] in

            return ["itemName": Item.itemName , "done": Item.done]
        }
        
        UserDefaults.standard.set(shoppingItemsDic, forKey: "list")
        
    }
    
    func loadList() {
        
        if let okList = UserDefaults.standard.array(forKey: "list") as? [[String: Any]] {
            
            shoppingItems = []
            
            for okItem in okList {
                
                let itemName = okItem["itemName"] as? String ?? ""
                let done = okItem["done"] as? Bool ?? false
                
                shoppingItems.append(Item(itemName: itemName, done: done))
                
            }
            
        }
        
    }
    
    func popUpAlert(itemText: String?, indexPath: IndexPath?) {
        
        let alertTitle: String
        
        if itemText == nil {
            alertTitle = "Add New Item"
        } else {
            alertTitle = "Edit Item"
        }
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (inputTextField: UITextField) in
            inputTextField.placeholder = "Add a new item here"
            inputTextField.text = itemText
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default) {
            // 按下 OK 之後要執行的動作
            (okAction: UIAlertAction) in
            
            // 如果可以取得 textField 的值
            if let inputText = alert.textFields?[0].text {
                
                // 新增的情況
                if itemText == nil {
                    
                    self.shoppingItems.append(Item(itemName: inputText, done: false))
                    self.tableView.insertRows(at: [IndexPath(row: self.shoppingItems.count - 1, section: 0)], with: .automatic)
                    self.saveList()
                
                // 修改的情況
                } else {
                    
                    self.shoppingItems[indexPath!.row].itemName = inputText
                    self.saveList()
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        popUpAlert(itemText: nil, indexPath: nil)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return shoppingItems.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = shoppingItems[indexPath.row].itemName
        
        if shoppingItems[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") {
            // 按下 Edit 之後要執行的動作
            (editAction: UITableViewRowAction, indexPath: IndexPath) in
            self.popUpAlert(itemText: self.shoppingItems[indexPath.row].itemName, indexPath: indexPath)
        }
        editAction.backgroundColor = .gray
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {
            // 按下 Delete 之後要執行的動作
            (deleteAction: UITableViewRowAction, indexPath: IndexPath) in
            self.shoppingItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveList()
        }
        deleteAction.backgroundColor = .red
        
        return [deleteAction, editAction]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        
        if shoppingItems[indexPath.row].done == false {
            
            cell.accessoryType = .checkmark
            shoppingItems[indexPath.row].done = true
            
        } else {
            
            cell.accessoryType = .none
            shoppingItems[indexPath.row].done = false
            
        }
        
        saveList()
        tableView.reloadData()
        
    }
 
}
