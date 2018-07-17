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
    var currentState: SlideOutState = .collapsed
    var drawerVC: PanelDrawerViewController!
    var isHidden = false
    var centerController: UIViewController!
    let centerPanelExpandedOffset: CGFloat = 160

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
    
    
    func animateLeftPanelDrawer(shouldExpand: Bool) {
        if shouldExpand {
            isHidden = !isHidden
            animateStatusBar()
            
            setupWhiteCoverView()
            currentState = .leftDrawerExpanded
            
        } else {
            isHidden = !isHidden
            animateStatusBar()
            
            hideWhiteCoverView()
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: (Bool) -> Void)! = nil) {
    //MARK:- Stopped at min 41 of video 5
    }
}


