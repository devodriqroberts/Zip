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
        
       
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginRegisterSegControl.selectedSegmentIndex = 0
        passDriverSegControl.selectedSegmentIndex = 0
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        setLoginRegisterbuttonTitle(with: loginRegisterSegControl.selectedSegmentIndex)
        
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    //Set login/Register button title
    func setLoginRegisterbuttonTitle(with index: Int) {
        authButton.setTitle(loginRegisterSegControl.titleForSegment(at: index), for: .normal)
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Dismiss login screen
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loginRegisterSegControl(_ sender: UISegmentedControl) {
        setLoginRegisterbuttonTitle(with: sender.selectedSegmentIndex)
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
    
    func showError(ofType error: Error) {
        print(error)
        Alert.showLoginErrorAlert(on: self, error: error as NSError)
    }
    
    func animateAuthButton() {
        authButton.animateButton(shouldLoad: true, withMessage: nil)
        self.view.endEditing(true)
    }
    
    
    @IBAction func authButtonPressed(_ sender: UIButton) {
        
        if emailTextField.text != nil && passwordTextField.text != nil {
            
            guard let email = emailTextField.text else {return}
            guard let password = passwordTextField.text else {return}
            guard let name = nameTextField.text else {return}
            
            var userData = [String:Any]()
            
            //Check if login / register segmented control is on register
            if loginRegisterSegControl.selectedSegmentIndex == 0 && passDriverSegControl.selectedSegmentIndex == 0 {
                
                
                
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        guard let error = error else {return}
                        self.showError(ofType: error)
                        print(error)
                        print("cannot sign in passenger")
                        return
                    }
                    // successfully authenticated user
                    let user = Auth.auth().currentUser
                    if let user = user {
                            let uid = user.uid
                            let email = user.email
                            print(uid, email)
//                            let userData = ["provider":user.additionalUserInfo?.providerID, "name": name] as [String:Any]
//                            self.ds.createFirebaseDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: userData, isDriver: false)
                            self.animateAuthButton()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            } else if loginRegisterSegControl.selectedSegmentIndex == 0 && passDriverSegControl.selectedSegmentIndex == 1 {
                
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        guard let error = error else {return}
                        self.showError(ofType: error)
                        print(error)
                        print("cannot sign in driver")
                        return
                    }
                    // successfully authenticated user
                    let user = Auth.auth().currentUser
                    if let user = user {
                       let uid = user.uid
                        print(uid)
                           // let userData = ["provider":user.additionalUserInfo?.providerID, "userIsDriver": true, "isPickUpModeEnabled": false, "driverIsOnTrip": false, "name": name] as [String:Any]
                            //self.ds.createFirebaseDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: userData, isDriver: true)
                            self.animateAuthButton()
                            self.dismiss(animated: true, completion: nil)
                        
                    }
                }
                print("Auth successful")
                self.dismiss(animated: true, completion: nil)
                
            } else if loginRegisterSegControl.selectedSegmentIndex == 1 && (passDriverSegControl.selectedSegmentIndex == 0 || passDriverSegControl.selectedSegmentIndex == 1) {
                
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        guard let error = error else {return}
                        self.showError(ofType: error)
                        print(error)
                        print("cannot register user")
                        return
                    }
                    let user = Auth.auth().currentUser
                    if let user = user {
                        
                            let changeRequest = user.createProfileChangeRequest()
                            changeRequest.displayName = name
                            changeRequest.commitChanges(completion: { (error) in
                                if let error = error {
                                    print(error)
                                }
                                print(user.displayName!)
                            })
                        
                        if self.passDriverSegControl.selectedSegmentIndex == 0 {
                            userData = ["provider": user.providerID, "name": name] as [String:Any]
                            self.ds.createFirebaseDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: userData, isDriver: false)
                        } else {
                             userData = ["provider":user.providerID, "userIsDriver": true, "isDriverOnline": false, "driverIsOnTrip": false, "name": name] as [String:Any]
                            self.ds.createFirebaseDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: userData, isDriver: true)
                           
                            
                        }
                        self.animateAuthButton()
                    }
                    print("Auth successful")
                    guard let name = userData["name"] as? String else {return}
                    self.dismiss(animated: true, completion: nil)
                    print(name)
                }
            }
            
        }
        
        
        
        
        
        
        
        
        
    }
}
