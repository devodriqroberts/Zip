//
//  ViewController.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/16/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit
import RevealingSplashView
import Firebase
import CoreLocation
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var actionButton: RoundedShadowButton!
    @IBOutlet weak var userImageView: RoundImageView!
    
    
    var manager: CLLocationManager?
    
    weak var delegate: CenterVCDelegate?
    //let loginVC = LoginViewController()
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor(displayP3Red: 0/255, green: 143/255, blue: 0/255, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthStatus()
        

       self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()

        revealingSplashView.heartAttack = true
        
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager?.delegate = self
            manager?.desiredAccuracy = kCLLocationAccuracyBest
            manager?.stopUpdatingLocation()
        } else {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            userImageView.image = UIImage(named: "noProfilePhoto")
        }
    }

    @IBAction func actionButtonPressed(_ sender: Any) {
        actionButton.animateButton(shouldLoad: true, withMessage: nil)
    }

    @IBAction func menuButtonPressed(_ sender: UIButton) {
        delegate?.toggleLeftDrawer()
    }
}
