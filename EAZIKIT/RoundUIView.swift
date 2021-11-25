//
//  RoundUIView.swift
//  EAZIKIT
//
//  Created by Jobesk Inc on 11/19/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
@IBDesignable
class RoundUIView: UIView {

    @IBInspectable  var cornerRadius: CGFloat = 0 {
        
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            
        }
        
    }
    

}
