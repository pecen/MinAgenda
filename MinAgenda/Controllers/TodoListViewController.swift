//
//  ViewController.swift
//  MinAgenda
//
//  Created by Peter Centellini on 2018-11-07.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: ControllerBase {

    //var itemArray: [String] = [] // = ["Find Mike", "Buy Eggos", "Create somethint"]
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    //let defaults = UserDefaults.standard
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)  //.first?.appendingPathComponent("Items.plist")
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let newItem = Item()
//        newItem.title = "Handla"
//        itemArray.append(newItem)
//        
//        let newItem2 = Item()
//        newItem2.title = "Byta däck"
//        itemArray.append(newItem2)
//        
//        let newItem3 = Item()
//        newItem3.title = "Tanka bilen"
//        itemArray.append(newItem3)
        
        //if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
        //    itemArray = items
        //}
        
//        loadItems()
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
//        The following 2 rows deletes a row from the list
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Lägg till en ny Att Göra punkt", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Lägg till", style: .default) { (action) in
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text == "" ?  "Ny Actionpunkt" : textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            // Saves to UserDefaults db on the phone
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Skapa ny rad"
            textField = alertTextField
            print(textField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

//    func saveItems() {
//        // Used when using NSCoder for persisting data
//        //let encoder = PropertyListEncoder()
//
//        do {
////            let data = try encoder.encode(itemArray)
////            try data.write(to: dataFilePath!)
//
//            try context.save()
//        }
//        catch {
//            print("Error encoding item array, \(error)")
//        }
//
//        tableView.reloadData()
//    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding item array, \(error)")
//            }
//        }
        
        // The following is used to utilize CoreData
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context. \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request, predicate: request.predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            searchBarSearchButtonClicked(searchBar)
        }
    }
    
}
