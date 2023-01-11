//
//  GroceryList.swift
//  Grocery List - Munira
//
//  Created by Munira on 08/01/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase

class GroceryList: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - var
//    var family = [Users]()
    var items = [Items]() ///
    var itemsArr = [String]()
//    var currentUser : Users?
//    var spaceBetweenCells = 100.0
    var ref = DatabaseReference.init()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpVew()
    }
    
    //MARK: - setUpVew
    func setUpVew(){
        //hide back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        tableView.dataSource = self
        tableView.delegate = self
        self.ref = Database.database().reference()
        // add title
        self.title = "Groceries to Buy"
        
        // add right button in navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        // add left button in navigation bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon"), style: .done, target: self, action: #selector(self.familyUsers(_:)))
        observeItems()
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
  
    //MARK: = push to family online users screen
    @objc func familyUsers(_ sender: UIBarButtonItem){

        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FamilyList") as? FamilyList {
         
            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
        }
    }
    //MARK: - add item alert
    @objc func addItem(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField! ) -> Void in
            textField.placeholder = "Enter your item"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [self] alert -> Void in
            let itemTextField = alertController.textFields![0] as UITextField
            let itemName = itemTextField.text
            handleAddItems(itemTextField)
            self.itemsArr.append(itemName!)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    //MARK: - for add new item
    func handleAddItems(_ textField: UITextField){
        guard let userItems = UserData.currentUser else { return }
        let ref = Database.database().reference().child("items").child(userItems.id)
        let itemObject = [
            "addedByUser": [
                "uid" : userItems.id,
                "email": userItems.email],
            "name" : textField.text!, "uid" : userItems.id] as [String : Any]
        ref.setValue(itemObject, withCompletionBlock: { error, reference in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
                print("\(String(describing: error))")
            } else {
                
            }
        })
    }
    //MARK: - function for edit items
    func editItems(id: String, name: String){
        let itemObject = [
            "uid" : id,
            "name" : name ]
        let ref = Database.database().reference().child("items").child(id)
//            ref.setValue(itemObject)
        ref.updateChildValues(itemObject)
    }
    
    //MARK: - observe items
    func observeItems(){
        let itemRef = Database.database().reference().child("items")
        itemRef.observe(.value, with: { snapshot in
            var tempItems = [Items]()
            for child in snapshot.children {
                if let childsnapshot = child as? DataSnapshot,
                   let dict = childsnapshot.value as? [String: Any],
                   let addedByUser = dict["addedByUser"] as? [String:Any],
                   let uid = addedByUser["uid"] as? String,
                   let email = addedByUser["email"] as? String,
                   let name = dict["name"] as? String{
                    let userItem = Users(email: email, password: "", id: uid)
                    let items = Items(id: childsnapshot.key, name: name, addedByUser: userItem)
                    tempItems.append(items)
                }
            }
            DispatchQueue.main.async {
                self.items = tempItems
                self.tableView.reloadData()
            }
        })
    }
}
//MARK: - table view data source and delegate
extension GroceryList : UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //MARK: - Cell for row

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryListCell", for: indexPath) as! GroceryListCell
        cell.set(item: items[indexPath.row])
        cell.layer.cornerRadius = 30
        return cell
    }
    //MARK: - Height for row

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    //MARK: - Edit items
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deleteItem = self.items[indexPath.row]
        
        if let itemId = deleteItem.id {
            Database.database().reference().child("items").child(itemId).removeValue { error , ref in
                if error != nil {
                    print("failed to delete", error!)
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
   }
    //MARK: - delete item
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = items[indexPath.row]
        let alertController = UIAlertController(title: "Edit item", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField! ) -> Void in
        }
        let updateAction = UIAlertAction(title: "Update", style: .default, handler: { [self] alert -> Void in
            let id = items.id
            let itemTextField = alertController.textFields![0] as UITextField
            let itemName = itemTextField.text
            editItems(id: id!, name: itemName!)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(updateAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }


}

