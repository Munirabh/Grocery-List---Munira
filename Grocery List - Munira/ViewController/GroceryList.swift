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
    var items = [Items]()
    var currentUser : Users?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpVew()
    }
    
    //MARK: - setUpVew
    func setUpVew(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        tableView.dataSource = self
        fetchData()
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
//            items.append(itemName)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    func handleAddItems(_ textField: UITextField){
        guard let thisUser = UserData.currentUser else { return}
        let ref = Database.database().reference().child("items").childByAutoId()
        let itemObject = [
//                "id": thisUser.id,
//                "email":thisUser.email  ,
            "text" : textField.text! ] 
        
        ref.setValue(itemObject, withCompletionBlock: { error, reference in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                
            }
        })
    }
   
    //MARK: - fetch data
    func fetchData(){
            var ref:DatabaseReference!
            ref = Database.database().reference()
                ref.child("GroceryLists").observe(.value) { result, error in
                 let currentUser = Auth.auth().currentUser?.uid
//                 let users = result.value as! NSDictionary
           
//                     for person in users{
//                         let personID = "\(person.key)"
//
//                         if personID != currentUser {
//                            let thrPerson = person.value as! NSDictionary
//
////                             let newUser = User( email: thrPerson["email"] as! String, password: thrPerson["password"] as! String, id: "\(person.key)")
//
////                            self.family.append(newUser)
//                        }

//                     }
                 
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
   
                 
        }
     }
    


}
//MARK: - table view data source
extension GroceryList : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryListCell", for: indexPath) as! GroceryListCell
        cell.set(item: items[indexPath.row])
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
//           sportsArr.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .fade)
           tableView.endUpdates()
           self.tableView.reloadData()
       }
   }
}
extension GroceryList : UITableViewDelegate {

}
