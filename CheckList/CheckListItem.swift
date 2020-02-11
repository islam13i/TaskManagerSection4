//
//  CheckListItem.swift
//  CheckList
//
//  Created by Islam on 2/5/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

class CheckListItem: NSObject, Codable {
    var text = ""
    var descText = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
