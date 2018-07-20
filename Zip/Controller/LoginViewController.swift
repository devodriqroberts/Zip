//
//  LoginViewController.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/17/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit
import  Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passDriverSegControl: UISegmentedControl!
    @IBOutlet weak var authButton: RoundedShadowButton!
    @IBOutlet weak var loginRegisterSegControl: UISegmentedControl!
    
    let ds = DataService()
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginRegisterSegControl.selectedSegmentIndex = 0
        passDriverSegControl.selectedSegmentIndex = 0
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        

        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

// Dismiss login screen
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loginRegisterSegControl(_ sender: UISegmentedControl) {
        self.nameTextFieldHeightAnchor?.isActive = false
        if sender.tag == 1 {
            
            if sender.selectedSegmentIndex == 0 {
                nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 0)
                nameTextFieldHeightAnchor?.isActive = true
            } else {
                nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 40)
                nameTextFieldHeightAnchor?.isActive = true
            }
        }
    }
    
    
    @IBAction func authButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let name = nameTextField.text else {return}
   
        
        if emailTextField.text != nil && passwordTextField.text != nil {
            
            //Check if login / register segmented control is on register
            if loginRegisterSegControl.selectedSegmentIndex == 1 && passDriverSegControl.selectedSegmentIndex == 0 {
                
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        print(error)
                        print("cannot save user")
                        return
                    }
                    // successfully authenticated user
                    self.authButton.animateButton(shouldLoad: true, withMessage: nil)
                    self.view.endEditing(true)
                    
                    let user = ["name": name, "email": email]
                    self.ds.createFirebaseDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: user, isDriver: false)
                    self.dismiss(animated: true, completion: nil)
                }
 
            } else if loginRegisterSegControl.selectedSegmentIndex == 1 && passDriverSegControl.selectedSegmentIndex == 1 {
                
                
                
                
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        print(error)
                        print("cannot save user")
                        return
                    }
                    // successfully authenticated user
                    self.authButton.animateButton(shouldLoad: true, withMessage: nil)
                    self.view.endEditing(true)
                    
                    let user = ["name": name, "email": email]
                    self.ds.createFirebaseDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: user, isDriver: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }

        
            } else {

            Alert.showIncompleteFormAlert(on: self)
        }
        
}


   


















}
