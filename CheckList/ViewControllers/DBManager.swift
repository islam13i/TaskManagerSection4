//
//  DBManager.swift
//  CheckList
//
//  Created by Islam on 3/21/20.
//  Copyright © 2020 Islam. All rights reserved.
//
import UIKit
import RealmSwift

class DBManager {
     var   database:Realm
    static let  sharedInstance = DBManager()
     init() {
       database = try! Realm()
    }
    func getDataFromDB() ->   Results<CheckListItem> {
      let results: Results<CheckListItem> = database.objects(CheckListItem.self)
      return results
     }
     func addData(object: CheckListItem)   {
          try! database.write {
            database.add(object, update: .all)
             print("Added new object")
          }
     }
      func deleteAllFromDatabase()  {
           try!   database.write {
               database.deleteAll()
           }
      }
      func deleteFromDb(object: CheckListItem)   {
          try!   database.write {
             database.delete(object)
          }
      }
}
