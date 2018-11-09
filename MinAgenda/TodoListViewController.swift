//
//  ViewController.swift
//  MinAgenda
//
//  Created by Peter Centellini on 2018-11-07.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [String] = [] // = ["Find Mike", "Buy Eggos", "Create somethint"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
    }
    
    //MARK - TableView DAtasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Lägg till en ny Att Göra punkt", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Lägg till", style: .default) { (action) in
            textField.text == ""
                ? self.itemArray.append("New Item")
                : self.itemArray.append(textField.text!)
            
            // Saves to UserDefaults db on the phone
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Skapa ny rad"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

