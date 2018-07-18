//
//  UIViewExtension.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/17/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeTo(alpha: CGFloat, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
    }
}






