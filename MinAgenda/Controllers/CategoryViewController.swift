//
//  CategoryViewController.swift
//  MinAgenda
//
//  Created by Peter Centellini on 2018-11-12.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: ControllerBase {

    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))  //.first?.appendingPathComponent("Items.plist")
        
        loadCategories()
     }

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)

        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }


    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Lägg till en ny Kategori", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Lägg till", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text == "" ?  "Ny Kategori" : textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Skapa ny kategori"
            textField = alertTextField
            print(textField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context. \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Data Manipulation Methods
    
}
