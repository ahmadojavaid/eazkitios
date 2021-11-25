//
//  FirstIntroScreen.swift
//  EAZIKIT
//
//  Created by APPLE on 12/11/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class FirstIntroScreen: UIViewController {
    var imageAddress = String()
    let nibView = ShareBtnsView()
    @IBOutlet weak var teethImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        let teethImagesArray = [UIImage(named :"teeth1-1"), UIImage(named: "teeth1-2")]
        teethImageView.animationImages = teethImagesArray as! [UIImage]
        teethImageView.animationDuration = 1
        teethImageView.startAnimating()
        
    }
    

    @objc func swipeUp()
    {
        performSegue(withIdentifier: "next", sender: nil)
    }
    

    
}
