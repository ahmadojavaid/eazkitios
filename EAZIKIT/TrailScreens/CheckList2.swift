//
//  CheckList.swift
//  EAZIKIT
//
//  Created by APPLE on 12/13/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class CheckList2: UIViewController {
    
    @IBOutlet weak var fitrstImageView: UIImageView!
    @IBOutlet weak var secondImagesView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    
    @IBOutlet weak var putGelBtn: UIButton!
    @IBOutlet weak var usbBtn: UIButton!
    @IBOutlet weak var mouthBtn: UIButton!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    
    
    
    var taskOne = "abc"
    var taskTwo = "abc"
    var taskThree = "abc"
    
    var firstSession = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
        firstImage.clipsToBounds = true
        secondImage.clipsToBounds = true
        thirdImage.clipsToBounds = true
        
        
        
        
        
        let teethImagesArray = [UIImage(named :"mouth_tray_1"), UIImage(named :"mouth_tray_2"),UIImage(named :"mouth_tray_3"),UIImage(named :"mouth_tray_4"),UIImage(named :"mouth_tray_5"),UIImage(named :"mouth_tray_6"),UIImage(named :"mouth_tray_7"),UIImage(named :"mouth_tray_8"),UIImage(named :"mouth_tray_9"),UIImage(named :"mouth_tray_9"), UIImage(named :"mouth_tray_8"),UIImage(named :"mouth_tray_7"),UIImage(named :"mouth_tray_6"),UIImage(named :"mouth_tray_5"),UIImage(named :"mouth_tray_4"),UIImage(named :"mouth_tray_3"),UIImage(named :"mouth_tray_2"),UIImage(named :"mouth_tray_1")]
        fitrstImageView.animationImages = teethImagesArray as! [UIImage]
        fitrstImageView.animationDuration = 2
        fitrstImageView.startAnimating()
        
        
        
        
        let secondArray = [UIImage(named :"insert_cable_1"),UIImage(named :"insert_cable_2"),UIImage(named :"insert_cable_3"),UIImage(named :"insert_cable_4"),UIImage(named :"insert_cable_5"), UIImage(named :"insert_cable_5"),UIImage(named :"insert_cable_4"),UIImage(named :"insert_cable_3"),UIImage(named :"insert_cable_2"),UIImage(named :"insert_cable_1")]
        secondImagesView.animationImages = secondArray as! [UIImage]
        secondImagesView.animationDuration = 1
        secondImagesView.startAnimating()
        
        
        //        place_tray_1
        
        
        
        
        let thirdArray = [UIImage(named :"place_tray_1"),UIImage(named :"place_tray_2"),UIImage(named :"place_tray_3"),UIImage(named :"place_tray_4"), UIImage(named :"place_tray_4"),UIImage(named :"place_tray_3"),UIImage(named :"place_tray_2"),UIImage(named :"place_tray_1")]
        thirdImageView.animationImages = thirdArray as! [UIImage]
        thirdImageView.animationDuration = 2
        thirdImageView.startAnimating()
        
        
        
    }
    
    @IBAction func gelBtnPressed(_ sender: Any)
    {
        putGelBtn.setBackgroundImage(UIImage(named: "tick"), for: .normal)
        
        taskOne = "Done"
    }
    
    @IBAction func usbBtnPressed(_ sender: Any)
    {
        usbBtn.setBackgroundImage(UIImage(named: "tick"), for: .normal)
        taskTwo = "Done"
    }
    
    @IBAction func mouthBtnPressed(_ sender: Any)
    {
        mouthBtn.setBackgroundImage(UIImage(named: "tick"), for: .normal)
        taskThree = "Done"
    }
    @IBAction func startBtn(_ sender: Any)
    {
        if taskOne == "abc" || taskTwo == "abc" || taskThree == "abc"
        {
            self.popup(msg: "Please perfrom all check list")
        }
        else
        {
            self.performSegue(withIdentifier: "sessionScreen", sender: nil)
    
        }
    }
    
    
    func popup(msg:String)
    {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
            
            // perform any action here
        })
        myAlert.addAction(OKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    

    
    
    
}

