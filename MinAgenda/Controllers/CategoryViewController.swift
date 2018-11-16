//
//  CategoryViewController.swift
//  MinAgenda
//
//  Created by Peter Centellini on 2018-11-12.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
//    @IBOutlet weak var imageView: UIImageView!
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))  //.first?.appendingPathComponent("Items.plist")
        
        loadCategories()
        
        tableView.separatorStyle = .none

        // The imageView IBOutlet above together with the following lines and the method func imageTapped below
        // is used if a tapable/clickable ImageView is to be used, where an ImageView is placed on the Storyboard
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        
        // add it to the image view;
        //imageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        //imageView.isUserInteractionEnabled = true

    }
    
    
//    @objc func imageTapped(gesture: UIGestureRecognizer) {
//        // if the tapped view is a UIImageView then set it to imageview
//        if (gesture.view as? UIImageView) != nil {
//            print("Image Tapped")
//            //Here you can initiate your new ViewController
//            guard let url = URL(string: "http://www.redesajn.com") else {
//                return //be safe
//            }
//
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
//    }


    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Ingen Kategori är tillagd"
        
        if let category = categories?[indexPath.row] {
        
            guard let categoryColor = UIColor(hexString: category.color) else {
                fatalError()
            }
            
            cell.backgroundColor = categoryColor //UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        
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
    
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error deleting Category, \(error)")
            }
        }

    }


    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Lägg till en ny Kategori", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Lägg till", style: .default) { (action) in
            let newCategory = Category()
            
            newCategory.name = textField.text == "" ?  "Ny Kategori" : textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()

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

