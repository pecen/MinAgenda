//
//  CategoryViewController.swift
//  MinAgenda
//
//  Created by Peter Centellini on 2018-11-12.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: ControllerBase {
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))  //.first?.appendingPathComponent("Items.plist")
        
        loadCategories()
     }

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Ingen Kategori är tillagd"
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }


    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Lägg till en ny Kategori", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Lägg till", style: .default) { (action) in
            let newCategory = Category()
            
            newCategory.name = textField.text == "" ?  "Ny Kategori" : textField.text!            

            self.saveData(data: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Skapa ny kategori"
            textField = alertTextField
            print(textField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    //MARK: - Data Manipulation Methods
    
}
