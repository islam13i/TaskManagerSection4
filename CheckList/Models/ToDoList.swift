//
//  ToDoList.swift
//  CheckList
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

class ToDoList{
    static let defaults = UserDefaults.standard
    var todos: [CheckListItem] = []
    init() {

    }
    
    func newItem() -> CheckListItem{
        let item = CheckListItem()
        item.text = randomName()
        item.checked = true
        todos.append(item)
        ToDoList.saveData(list: todos)
        return item
    }

    func moveItem(item: CheckListItem, index: Int) {
        guard let currentIndex = todos.firstIndex(of: item) else {
            return
        }
        todos.remove(at: currentIndex)
        todos.insert(item, at: index)
        ToDoList.saveData(list: todos)
    }
    
    func removeItems(items: [CheckListItem]) {
        for item in items {
            if let index = todos.firstIndex(of: item) {
                todos.remove(at: index )
            }
        }
        ToDoList.saveData(list: todos)
    }
    static func saveData(list: [CheckListItem]!){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(list), forKey: "LastList")
    }
    static func get() -> [CheckListItem]! {
        var userData: [CheckListItem]!
        if let data = UserDefaults.standard.value(forKey: "LastList") as? Data {
            userData = try? PropertyListDecoder().decode([CheckListItem].self, from: data)
            if let uData = userData{
                return uData
            }else{
                let uData: [CheckListItem] = []
                return uData
            }
        } else {
            return userData
        }
    }
    private func randomName() -> String{
        let names = ["New item","Generic item","fill me all","something","Do it all"]
        let randomNumber = Int.random(in: 0...names.count - 1)
        return names[randomNumber]
    }
}
