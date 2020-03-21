//
//  DBManager.swift
//  CheckList
//
//  Created by Islam on 3/21/20.
//  Copyright © 2020 Islam. All rights reserved.
//
import UIKit
import RealmSwift

class DBManager{
    private var database:Realm
    static let sharedInstance = DBManager()
    private init() {
       database = try! Realm()
    }
//    func getDataFromDB() -> [CheckListItem] {
//      let results: [CheckListItem] =   database.objects(CheckListItem.self)
//      return results
//     }
//     func addData(object: Item)   {
//          try! database.write {
//             database.add(object, update: true)
//             print("Added new object")
//          }
//     }
//      func deleteAllFromDatabase()  {
//           try!   database.write {
//               database.deleteAll()
//           }
//      }
//      func deleteFromDb(object: Item)   {
//          try!   database.write {
//             database.delete(object)
//          }
//      }
}
