//
//  AddItemTableViewController.swift
//  CheckList
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import RealmSwift

protocol ItemDetailVDelegate: class {
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem)
}
class ItemDetailViewController: UITableViewController {
    
    weak var delegate:  ItemDetailVDelegate?
    var todoList: Results<CheckListItem>?
    weak var itemToEdit: CheckListItem?
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.ItemDetailViewControllerDidCancel(self)
    }
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit, let text = textField.text, let descText = descriptionTextField.text{
            item.text = text
            item.descText = descText
            delegate?.ItemDetailViewController(self, didFinishEditing: item)
        }else{
                let item = CheckListItem()
                
                if let textFieldtext = textField.text, let descText = descriptionTextField.text{
                    item.text = textFieldtext
                    item.descText = descText
                }
                item.checked = false
                delegate?.ItemDetailViewController(self, didFinishAdding: item)
            
        }
    }
    override func viewDidLoad() {
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
            descriptionTextField.text = item.descText
            addBarButton.isEnabled = true
        }
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
extension ItemDetailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText)else{
            return false
        }
        let newText = oldText.replacingCharacters(in: stringRange, with : string)
        if newText.isEmpty{
            addBarButton.isEnabled = false
        }else{
            addBarButton.isEnabled = true
        }
        return true
    }
}
