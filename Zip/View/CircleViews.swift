//
//  CircleViews.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/16/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class CircleViews: UIView {
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = borderColor?.cgColor
    }

}
