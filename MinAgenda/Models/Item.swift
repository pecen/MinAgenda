//
//  Item.swift
//  MinAgenda
//
//  Created by Peter Centellini on 2018-11-09.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object { // Codable {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var color: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
