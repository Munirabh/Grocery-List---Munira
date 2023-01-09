//
//  ViewController.swift
//  Grocery List - Munira
//
//  Created by Munira on 08/01/2023.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginAndSignUp: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var vegImage: UIImageView!
    @IBOutlet weak var errorMessege: UILabel!
    @IBOutlet weak var healthyImg: UIImageView!
    @IBOutlet weak var farmerImg: UIImageView!
    @IBOutlet weak var epStack: UIStackView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var buttonStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    //MARK: - set up view
    func setUpView(){
        constraints()
        self.errorMessege.isHidden = true
        let textFieldStyle = NSMutableParagraphStyle()
        textFieldStyle.alignment = .center
        emailTextField.layer.cornerRadius = 10
        emailTextField.placeholder = "Email"
        emailTextField.textAlignment = .center
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.placeholder = "Password"
        passwordTextField.textAlignment = .center
        passwordTextField.isSecureTextEntry = true
        
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    
    
    //MARK: - login button
    @IBAction func logInButton(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            if error != nil {
                self.errorMessege.isHidden = false
            } else {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroceryList") as? GroceryList {
                 
                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.modalPresentationStyle = .fullScreen
                }
            }
        })
    }
    
    //MARK: - Sign up button
    @IBAction func signUpButton(_ sender: UIButton) {
        FirebaseAuth.Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
            if error != nil {
                self.errorMessege.isHidden = false
                self.errorMessege.text = "⚠ \(error!.localizedDescription)"
            } else {
                let newUser = Users( email: self.emailTextField.text!, password: self.passwordTextField.text!, id: "\(result!.user.uid)")
                var referance : DatabaseReference!
                referance = Database.database().reference()
                referance.child("users").child(newUser.id).setValue(["email" : newUser.email, "password" : newUser.password])
                print("user createrd")
            }
        }
    }
}

    //MARK: - constriants
extension LoginAndSignUp {
    
    func constraints(){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true

        epStack.translatesAutoresizingMaskIntoConstraints = false
        epStack.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        epStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        epStack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        epStack.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        buttonStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 320).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: 100).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        vegImage.translatesAutoresizingMaskIntoConstraints = false
        vegImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 550).isActive = true
        vegImage.widthAnchor.constraint(equalToConstant: 170).isActive = true
        vegImage.heightAnchor.constraint(equalToConstant: 85).isActive = true
        vegImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        
        healthyImg.translatesAutoresizingMaskIntoConstraints = false
        healthyImg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -150).isActive = true
        healthyImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 550).isActive = true
        healthyImg.widthAnchor.constraint(equalToConstant: 170).isActive = true
        healthyImg.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        farmerImg.translatesAutoresizingMaskIntoConstraints = false
        farmerImg.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        farmerImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 500).isActive = true
        farmerImg.widthAnchor.constraint(equalToConstant: 130).isActive = true
        farmerImg.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
}
