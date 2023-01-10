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
    var family = [Users]()
    var items = [Items]() ///
    var itemsArr = [String]()
    var currentUser : Users?
    var ref = DatabaseReference.init()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpVew()
    }
    
    //MARK: - setUpVew
    func setUpVew(){
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
      
    }
    @objc func familyUsers(_ sender: UIBarButtonItem){

        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FamilyList") as? FamilyList {
         
            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
        }
    }
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
    
    func handleAddItems(_ textField: UITextField){
        guard let userItems = UserData.currentUser else { return }
        let ref = Database.database().reference().child("items").childByAutoId()
        let itemObject = [
            "addedByUser": [
                "uid" : userItems.id,
                "email": userItems.email],
            "name" : textField.text!] as [String : Any]
        ref.setValue(itemObject, withCompletionBlock: { error, reference in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
                print("\(String(describing: error))")
            } else {
                
            }
        })
     

    }
    func fetchUsersAndItems(){

    }
    
  


}
//MARK: - table view data source
extension GroceryList : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryListCell", for: indexPath) as! GroceryListCell
        cell.set(item: items[indexPath.row])
        cell.layer.cornerRadius = 10
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           items.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .fade)
           tableView.endUpdates()
           self.tableView.reloadData()
       }
   }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return itemsArr.count
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = view.backgroundColor
//
//        return headerView
//    }
}

