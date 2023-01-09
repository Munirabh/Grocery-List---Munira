//
//  FamilyList.swift
//  Grocery List - Munira
//
//  Created by Munira on 08/01/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FamilyList: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    func setUpView(){
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            navigationItem.backBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "log Out", style: .plain, target: self, action: #selector(logOut))
    }
    
    @objc func logOut(){
        let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginAndSignUp") as? LoginAndSignUp {
                 
                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.modalPresentationStyle = .fullScreen
                }
            }
            catch let signOutError as NSError {
                print(signOutError.localizedDescription)
                    }
    }

  

}
