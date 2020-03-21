//
//  ViewController.swift
//  CheckList
//
//  Created by Islam on 2/5/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import RealmSwift

class CheckListViewController: UITableViewController {
    
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    var todoList: Results<CheckListItem>!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSearchBar()
    }
    
    private func configureSearchBar(){
        
      
        definesPresentationContext = true
    }
    private func configureView(){
        if self.revealViewController() != nil {
             menuButton.target = self.revealViewController()
             menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
             self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItems?.append(editButtonItem)
        deleteBtn.isEnabled = false
        tableView.allowsMultipleSelectionDuringEditing = true
        if let todo: Results<CheckListItem> = DBManager.sharedInstance.database.objects(CheckListItem.self){
            todoList = todo
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        if !tableView.isEditing{
            deleteBtn.isEnabled = true
        }else{
            deleteBtn.isEnabled = false
        }
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath)
        let item: CheckListItem
            item = todoList[indexPath.row]
        
         
        configureText(cell: cell, item: item)
        configureCheckMark(cell: cell, item: item)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath){
            let item: CheckListItem
                item = todoList[indexPath.row]
            
            try! DBManager.sharedInstance.database.write{
                item.toggleChecked()
            }
            configureCheckMark(cell: cell, item: item)
            tableView.deselectRow(at : indexPath, animated: true)
         //   ToDoList.saveData(list: todoList)
        } 
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //DBManager.deleteFromDb()
      //  todoList.(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    func configureText(cell: UITableViewCell, item: CheckListItem){
        if let cellText = cell as? CheckListTableViewCell{
            cellText.cellTextLabel.text = item.text
            cellText.descTextLabel.text = item.descText
        }
    }
    func configureCheckMark(cell: UITableViewCell, item: CheckListItem){
        guard let checkmark = cell as? CheckListTableViewCell
        else {
            return
        }
        if item.checked{
            checkmark.checkMarkLabel.text = "√"
        }else{
            checkmark.checkMarkLabel.text = ""
        }
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selecteRows = tableView.indexPathsForSelectedRows{
            let items = List<CheckListItem>()
            for indexPath in selecteRows {
                items.append(todoList[indexPath.row])
            }
            try! DBManager.sharedInstance.database.write{
                DBManager.sharedInstance.database.delete(items)
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selecteRows, with: .automatic)
            tableView.endUpdates()
        }
        setEditing(false, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue"{
            if let itemDetailViewController = segue.destination as? ItemDetailViewController{
                itemDetailViewController.delegate = self
                itemDetailViewController.todoList = todoList
            }
        }else if segue.identifier == "EditItemSegue"{
            if let itemDetailViewController = segue.destination as? ItemDetailViewController{
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
                        itemDetailViewController.itemToEdit = todoList[indexPath.row]
                     
                    itemDetailViewController.delegate = self
                }
            }
        }
    }
}

extension CheckListViewController: ItemDetailVDelegate{
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem) {
        navigationController?.popViewController(animated: true)
        try! DBManager.sharedInstance.database.write{
            DBManager.sharedInstance.database.add(item)
        }
        let rowIndex = todoList.count - 1
        let indexPath = IndexPath.init(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        self.tableView.insertRows(at: indexPaths, with: .automatic )
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem) {
        
        if let index = todoList.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(cell: cell, item: item)
            }
        }
        navigationController?.popViewController(animated: true )
        tableView.reloadData()
    }
    
}


