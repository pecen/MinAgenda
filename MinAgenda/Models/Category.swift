//
//  Category.swift
//  MinAgenda
//
//  Created by Peter Centellini on 2018-11-12.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

