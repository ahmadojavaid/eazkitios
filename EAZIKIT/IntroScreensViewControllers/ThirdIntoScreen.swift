//
//  ThirdIntoScreen.swift
//  EAZIKIT
//
//  Created by APPLE on 12/11/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit

class ThirdIntoScreen: UIViewController {

    @IBOutlet weak var teethimageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        
         let teethImagesArray = [UIImage(named :"teeth-2"), UIImage(named: "teeth-2-1")]
        teethimageView.animationImages = teethImagesArray as! [UIImage]
        teethimageView.animationDuration = 1
        teethimageView.startAnimating()
    }
    
    
    @objc func swipeUp()
    {
        performSegue(withIdentifier: "next2", sender: nil)
    }

}
