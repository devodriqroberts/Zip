//
//  AuthenticateUser.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/19/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import Foundation
import Firebase

let loginVC = LoginViewController()
struct AuthenticateUser {
    
    let authButton = loginVC.authButton
    
    
    
    static func authenticateNewPassenger() {
        guard let email = loginVC.emailTextField.text else {return}
        guard let password = loginVC.passwordTextField.text else {return}
        guard let name = loginVC.nameTextField.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
                print("cannot save user")
                return
            }
            // successfully authenticated user
            loginVC.authButton.animateButton(shouldLoad: true, withMessage: nil)
            loginVC.view.endEditing(true)
            
            let user = ["name": name, "email": email]
            loginVC.ds.createFirebaseDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: user, isDriver: false)
            loginVC.dismiss(animated: true, completion: nil)
        }
    }
    
    static func authenticateNewPDriver() {
        guard let email = loginVC.emailTextField.text else {return}
        guard let password = loginVC.passwordTextField.text else {return}
        guard let name = loginVC.nameTextField.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
                print("cannot save user")
                return
            }
            // successfully authenticated user
            loginVC.authButton.animateButton(shouldLoad: true, withMessage: nil)
            loginVC.view.endEditing(true)
            
            let user = ["name": name, "email": email]
            loginVC.ds.createFirebaseDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: user, isDriver: true)
            loginVC.dismiss(animated: true, completion: nil)
        }
    }
}


