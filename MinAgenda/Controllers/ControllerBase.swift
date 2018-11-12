//
//  ControllerBase.swift
//  MinAgenda
//
//  Created by Peter Centellini on 2018-11-12.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import UIKit
import CoreData

class ControllerBase: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadData<T>(with request: NSFetchRequest<T>) -> [T] {
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching data from context. \(error)")
        }
        
        //tableView.reloadData()
        
        return []
    }

    func saveData() {
        do {
            try context.save()
        }
        catch {
            print("Error saving data. \(error)")
        }
        
        tableView.reloadData()
    }
}
