//
//  ControllerBase.swift
//  MinAgenda
//
//  Created by Peter Centellini on 2018-11-12.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import UIKit
import RealmSwift

class ControllerBase: UITableViewController {
    let realm = try! Realm()

    func saveData(data: Object) {
        do {
            try realm.write {
                realm.add(data)
            }
        }
        catch {
            print("Error saving data. \(error)")
        }

        tableView.reloadData()
    }
}
