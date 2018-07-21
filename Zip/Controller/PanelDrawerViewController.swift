//
//  PanelDrawerViewController.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/16/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit
import Firebase

class PanelDrawerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginLogoutButton: UIButton!
    @IBOutlet weak var userGreetingLabel: UILabel!
    @IBOutlet weak var onlineModeSwitch: UISwitch!
    @IBOutlet weak var onlineModeEnabledLabel: UILabel!
    @IBOutlet weak var userProfileImageView: RoundImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAccountTypeLabel: UILabel!
    
    let loginVC = LoginViewController()
    let user = Auth.auth().currentUser
    let currentUserID = Auth.auth().currentUser?.uid
    let appDelegate = AppDelegate.getAppDelegate()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        
        onlineModeSwitch.isOn = false
        onlineModeEnabledLabel.text = "OFFLINE"
        onlineModeEnabledLabel.isHidden = true
        onlineModeSwitch.isHidden = true
        observeUserType()
       
        
        if user == nil {
            userGreetingLabel.text = ""
            userAccountTypeLabel.text = ""
            userEmailLabel.text = ""
            userProfileImageView.isHidden = true
            loginLogoutButton.setTitle("Sign Up / Login", for: .normal)
        } else {
            userEmailLabel.text = user?.email
            guard let name = user?.displayName else {return}
            userGreetingLabel.text = "Hello, \(name)!"
            userAccountTypeLabel.text = ""
            userProfileImageView.isHidden = false
            loginLogoutButton.setTitle("Logout", for: .normal)
            
        }
    }
    
    func observeUserType() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLabel.text = "PASSENGER"
                        self.onlineModeEnabledLabel.heightAnchor.constraint(equalToConstant: 0)
                        
                    }
                }
            }
        }
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLabel.text = "DRIVER"
                        self.onlineModeSwitch.isHidden = false
                        
                        let switchStatus = snap.childSnapshot(forPath: "isDriverOnline").value as! Bool
                        self.onlineModeSwitch.isOn = switchStatus
                        self.onlineModeEnabledLabel.isHidden = false
                        
                       
                        
                    }
                }
            }
        }
    }
  
    func showError(ofType error: Error) {
        print(error)
        Alert.showLoginErrorAlert(on: self, error: error as NSError)
    }
    
    
   
    @IBAction func signupLoginButtonPressed(_ sender: UIButton) {
        
        if user == nil {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        
            present(loginVC!, animated: true, completion: nil)
        } else {
            do {
            try Auth.auth().signOut()
                resetView()
            } catch (let error) {
                self.showError(ofType: error)
                print(error)
            }
        }
    }
    @IBAction func switchWasToggled(_ sender: UISwitch) {
        if onlineModeSwitch.isOn {
            
            let alert = UIAlertController(title: "Enable Drive Mode?", message: "You are switching your staus to ONLINE. Do you want to continue?", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.appDelegate.MenuContainerVC.toggleLeftDrawer()
                self.onlineModeEnabledLabel.text = "ONLINE"
                DataService.instance.REF_DRIVERS.child(self.currentUserID!).updateChildValues(["isDriverOnline": true])
            }
            let actionNo = UIAlertAction(title: "No", style: .cancel) { (action) in
                self.onlineModeSwitch.isOn = false
                self.appDelegate.MenuContainerVC.toggleLeftDrawer()
                self.onlineModeEnabledLabel.text = "OFFLINE"
                DataService.instance.REF_DRIVERS.child(self.currentUserID!).updateChildValues(["isDriverOnline":false])
            }
            alert.addAction(actionYes)
            alert.addAction(actionNo)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            
            appDelegate.MenuContainerVC.toggleLeftDrawer()
            onlineModeEnabledLabel.text = "OFFLINE"
            DataService.instance.REF_DRIVERS.child(currentUserID!).updateChildValues(["isDriverOnline":false])
        }
    }
}

extension PanelDrawerViewController {
    
    func resetView() {
        userEmailLabel.text = ""
        userAccountTypeLabel.text = ""
        userProfileImageView.isHidden = true
        onlineModeEnabledLabel.text = ""
        onlineModeSwitch.isHidden = true
        onlineModeSwitch.isOn = false
        userGreetingLabel.text = "Hello, User!"
        loginLogoutButton.setTitle("Sign Up / Login", for: .normal)
       
        
    }
    
}
