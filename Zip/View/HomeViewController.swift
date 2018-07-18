//
//  ViewController.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/16/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit
import RevealingSplashView

class HomeViewController: UIViewController {

    @IBOutlet weak var actionButton: RoundedShadowButton!
    
    weak var delegate: CenterVCDelegate?
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor(displayP3Red: 0/255, green: 143/255, blue: 0/255, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        
        revealingSplashView.heartAttack = true
    }

    @IBAction func actionButtonPressed(_ sender: Any) {
        actionButton.animateButton(shouldLoad: true, withMessage: nil)
    }

    @IBAction func menuButtonPressed(_ sender: UIButton) {
        delegate?.toggleLeftDrawer()
    }
}
