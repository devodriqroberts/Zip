//
//  LoginAlerts.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/19/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import Foundation
import  UIKit

let loginVc = LoginViewController()


struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        let message = "Incomplete text field. Please enter email and/or valid password."
        
        if loginVc.emailTextField.text != nil && loginVc.passwordTextField.text != nil {
            return
        } else {
            
            showBasicAlert(on: vc, with: "Incomplete Text Field", message: message)
        }
    }
}












