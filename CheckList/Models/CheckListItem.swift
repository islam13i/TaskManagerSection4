//
//  CheckListItem.swift
//  CheckList
//
//  Created by Islam on 2/5/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation
import RealmSwift

class CheckListItem: Object, Codable {
    @objc dynamic var text = ""
    @objc dynamic var descText = ""
    @objc dynamic var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
