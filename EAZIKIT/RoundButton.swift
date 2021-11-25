//
//  RoundButton.swift
//  EAZIKIT
//
//  Created by Jobesk Inc on 12/4/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            
        }
        
    }
}
