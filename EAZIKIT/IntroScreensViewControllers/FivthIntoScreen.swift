//
//  FivthIntoScreen.swift
//  EAZIKIT
//
//  Created by APPLE on 12/11/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit

class FivthIntoScreen: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var teethimageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let teethImagesArray = [UIImage(named :"teeth-3"), UIImage(named: "teeth-3-1")]
        teethimageView.animationImages = teethImagesArray as! [UIImage]
        teethimageView.animationDuration = 1
        teethimageView.startAnimating()
        
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        
        bar.alpha = 1.0
        
        
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp))
//        swipeUp.direction = UISwipeGestureRecognizerDirection.up
//        self.view.addGestureRecognizer(swipeUp)
        
        
        
        
        bottomView.layer.cornerRadius = 15
        bottomView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        
    }
    
    @IBAction func trailScreenBtn(_ sender: Any)
    {
        self.performSegue(withIdentifier: "trailScreens", sender: nil)
    }
    @IBAction func nextScreen(_ sender: Any)
    {
        swipeUp()
    }
    
    func swipeUp()
    {
        performSegue(withIdentifier: "next3", sender: nil)
    }
}
