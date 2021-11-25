//
//  SecondIntroScreen.swift
//  EAZIKIT
//
//  Created by APPLE on 12/11/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit

class SecondIntroScreen: UIViewController {

    @IBOutlet weak var fairyTeethView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        
        
        
        let teethImagesArray = [UIImage(named :"fairy1"),UIImage(named :"fairy2"),UIImage(named :"fairy3"),UIImage(named :"fairy4"),UIImage(named :"fairy5"),UIImage(named :"fairy6"),UIImage(named :"fairy7"),UIImage(named :"fairy8")]
        fairyTeethView.animationImages = teethImagesArray as! [UIImage]
        fairyTeethView.animationDuration = 2
        fairyTeethView.startAnimating()
        
        
    }
    
    
    @objc func swipeUp()
    {
        performSegue(withIdentifier: "next1", sender: nil)
    }

}
