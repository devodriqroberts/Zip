//
//  ContainerViewController.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/16/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case collapsed
    case leftDrawerExpanded
}

enum ShowWhichVC {
    case homeViewController
}

var showViewController: ShowWhichVC = .homeViewController

class ContainerViewController: UIViewController {
    
    var homeViewController: HomeViewController!
    var currentState: SlideOutState = .collapsed {
        didSet {
            let showShadow = (currentState != .collapsed)
            
            showShadowForCenterViewController(status: showShadow)
        }
    }
    var drawerVC: PanelDrawerViewController!
    var isHidden = false
    var centerController: UIViewController!
    var centerPanelExpandedOffset: CGFloat {
        let viewWidth = UIStoryboard.homeViewController()?.view.frame.width
            return viewWidth! * 0.42
    }


    var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCenter(screen: showViewController)
        
    }
    
    func initCenter(screen: ShowWhichVC) {
        var presentingController: UIViewController
        
        showViewController = screen
        
        if homeViewController == nil {
            homeViewController = UIStoryboard.homeViewController()
            homeViewController.delegate = self
        }
        presentingController = homeViewController
        if let controller = centerController {
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
        centerController = presentingController
        
        view.addSubview(centerController.view)
        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
    
}

private extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func panelViewController() -> PanelDrawerViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "PanelDrawerViewController") as? PanelDrawerViewController
    }
    
    class func homeViewController() -> HomeViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }
}

extension ContainerViewController: CenterVCDelegate {
    
    // Check if panel drawer is anything other than expanded
    func toggleLeftDrawer() {
        let notExpanded = (currentState != .leftDrawerExpanded)
        if notExpanded {
            addLeftPanelDrawerVC()
        }
        animateLeftPanelDrawer(shouldExpand: notExpanded)
    }
    
    
    func addLeftPanelDrawerVC() {
        if(drawerVC == nil) {
            drawerVC = UIStoryboard.panelViewController()
            addChildSidePanelViewController(drawerVC!)
        }
    }
    
    func addChildSidePanelViewController(_ panelDrawerController: PanelDrawerViewController) {
        view.insertSubview(panelDrawerController.view, at: 0)
        addChildViewController(panelDrawerController)
        panelDrawerController.didMove(toParentViewController: self)
    }
    
    
    @objc func animateLeftPanelDrawer(shouldExpand: Bool) {
        if shouldExpand {
            isHidden = !isHidden
            animateStatusBar()
            
            setupCoverView()
            currentState = .leftDrawerExpanded
            
            animateCenterPanelXPosition(targetPosition: centerController.view.frame.width - centerPanelExpandedOffset)
        } else {
            isHidden = !isHidden
            animateStatusBar()
            
            hideCoverView()
            animateCenterPanelXPosition(targetPosition: 0) { (finished) in
                if finished == true {
                    self.currentState = .collapsed
                    self.drawerVC = nil
                }
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    //MARK:- Animate status bar
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    //MARK:- Setup up cover view for sliding animation
    func setupCoverView() {
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        coverView.alpha = 0.0
        coverView.backgroundColor = UIColor(displayP3Red: 0/255, green: 143/255, blue: 0/255, alpha: 1)
        coverView.tag = 20
        
        self.centerController.view.addSubview(coverView)
        coverView.fadeTo(alpha: 0.75, withDuration: 0.2)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(animateLeftPanelDrawer(shouldExpand:)))
        tap.numberOfTapsRequired = 1
        
        self.centerController.view.addGestureRecognizer(tap)
    }
    
    //MARK:- Hide cover view for sliding animation
    func hideCoverView() {
        centerController.view.removeGestureRecognizer(tap)
        for subview in self.centerController.view.subviews {
            if subview.tag == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    subview.alpha = 0.0
                }) { (finished) in
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    //Setup shadow for cover view
    func showShadowForCenterViewController(status: Bool) {
        if status {
            centerController.view.layer.shadowOpacity = 0.6
        } else {
            centerController.view.layer.shadowOpacity = 0.0
        }
    }
}
















