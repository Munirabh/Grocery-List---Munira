//
//  ViewController.swift
//  Grocery List - Munira
//
//  Created by Munira on 08/01/2023.
//

import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit

class LoginAndSignUp: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var vegImage: UIImageView!
    @IBOutlet weak var errorMessege: UILabel! // show error while log in and sign up
    @IBOutlet weak var healthyImg: UIImageView!
    @IBOutlet weak var farmerImg: UIImageView!
    @IBOutlet weak var epStack: UIStackView! // email and password stack view
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var buttonStack: UIStackView! // log in and sign up stack view
    
    var ref = DatabaseReference.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
 
    //MARK: - set up view
    func setUpView(){
        self.ref = Database.database().reference()

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
        facebookLogIn()
        self.navigationItem.setHidesBackButton(true, animated: true)
      
    }
    // MARK: - anchors for facebook log in button
    func viewAnchors(_ loginButton: UIButton) {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 400),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
        ])
    }
    // MARK: - facebook log in button
    func facebookLogIn(){
        
        let loginButton = FBLoginButton()
        self.view.addSubview(loginButton)
        self.viewAnchors(loginButton)
        self.view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            // Print out access token
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
    }
    @IBAction func googleButton(_ sender: UIButton) {
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
        handleSignup()
    }
    
    //MARK: - save email in firebase
    func saveEmail(email: String, completion: @escaping ((_ success: Bool)->())){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("Users/\(uid)")
        let userObject = [ "email" : email ] as [String:Any]
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil )
        }
    }
    //MARK: - sign up func
    func handleSignup(){
        FirebaseAuth.Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
            if error != nil {
                self.errorMessege.isHidden = false
                self.errorMessege.text = "⚠ \(error!.localizedDescription)"
                self.saveEmail(email: self.emailTextField.text!) { success in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                let newUser = Users( email: self.emailTextField.text!, password: self.passwordTextField.text!, id: "\(result!.user.uid)")
                var referance : DatabaseReference!
                referance = Database.database().reference()
                referance.child("users").child(newUser.id).setValue(["email" : newUser.email, "password" : newUser.password])
                print("user createrd")
                self.errorMessege.isHidden = true

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
        vegImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 600).isActive = true
        vegImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        vegImage.heightAnchor.constraint(equalToConstant: 65).isActive = true
        vegImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
        
        healthyImg.translatesAutoresizingMaskIntoConstraints = false
        healthyImg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -170).isActive = true
        healthyImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 600).isActive = true
        healthyImg.widthAnchor.constraint(equalToConstant: 150).isActive = true
        healthyImg.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        farmerImg.translatesAutoresizingMaskIntoConstraints = false
        farmerImg.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        farmerImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 550).isActive = true
        farmerImg.widthAnchor.constraint(equalToConstant: 110).isActive = true
        farmerImg.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
}
