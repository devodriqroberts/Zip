//
//  PanelDrawerViewController.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/16/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class PanelDrawerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    @IBAction func signupLoginButtonPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        
        present(loginVC!, animated: true, completion: nil)
    }
    
}
