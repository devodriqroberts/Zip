//
//  ViewController.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/16/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var actionButton: RoundedShadowButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionButtonPressed(_ sender: Any) {
        actionButton.animateButton(shouldLoad: true, withMessage: nil)
    }

}
