//
//  ViewController.swift
//  CheckList
//
//  Created by Islam on 2/5/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController {
    
    
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    var todoList: ToDoList
    var tableData: [[CheckListItem?]?]!
    required init?(coder: NSCoder) {
        todoList = ToDoList()
        super .init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
       // navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 1, green: 0.9188480985, blue: 0.4893374072, alpha: 1)
        deleteBtn.isEnabled = false
        tableView.allowsMultipleSelectionDuringEditing = true
//        tableView.backgroundView = nil;
//        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.9188480985, blue: 0.4893374072, alpha: 1)
        if let todo: [CheckListItem] = ToDoList.get(){
            todoList.todos = todo
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
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        todoList.moveItem(item: todoList.todos[sourceIndexPath.row], index: destinationIndexPath.row)
        ToDoList.saveData(list: todoList.todos)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath)
        let item = todoList.todos[indexPath.row]
        configureText(cell: cell, item: item)
        configureCheckMark(cell: cell, item: item)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath){
            let item = todoList.todos[indexPath.row]
            item.toggleChecked() 
            configureCheckMark(cell: cell, item: item)
            tableView.deselectRow(at : indexPath, animated: true)
            ToDoList.saveData(list: todoList.todos)
        } 
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoList.todos.remove(at: indexPath.row)
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
    
    @IBAction func AddItem(_ sender: Any) {
        let newRowIndex = todoList.todos.count
        _ = todoList.newItem()
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic )
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selecteRows = tableView.indexPathsForSelectedRows{
            var items = [CheckListItem]()
            for indexPath in selecteRows {
                items.append(todoList.todos[indexPath.row])
            }
            todoList.removeItems(items: items)
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
                    let item = todoList.todos[indexPath.row]
                    itemDetailViewController.itemToEdit = item
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
        let rowIndex = todoList.todos.count - 1
        let indexPath = IndexPath.init(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic )
        ToDoList.saveData(list: todoList.todos)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem) {
        if let index = todoList.todos.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(cell: cell, item: item)
            }
        }
        navigationController?.popViewController(animated: true )
        ToDoList.saveData(list: todoList.todos)
        tableView.reloadData()
    }
    
}
