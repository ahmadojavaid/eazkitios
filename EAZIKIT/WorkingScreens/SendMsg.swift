//
//  SendMsg.swift
//  EAZIKIT
//
//  Created by APPLE on 12/20/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SendMsg: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
 
    @IBOutlet weak var topic: UITextField!
    @IBOutlet weak var suggesstion: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateToothImage()
        
        
        
        
    }
    

    fileprivate func animateToothImage() {
        // Do any additional setup after loading the view.
        
        let teethImagesArray = [UIImage(named :"teeth1-1"), UIImage(named: "teeth1-2")]
        imageView.animationImages = teethImagesArray as! [UIImage]
        imageView.animationDuration = 1
        imageView.startAnimating()
    }
    
    
    @IBAction func sendDataServer(_ sender: Any)
    {
        let top = topic.text!
        let sug = suggesstion.text!
        
        if top.isEmpty
        {
            self.popup(msg: "Please Type a topic")
        } else if sug.isEmpty
        {
            self.popup(msg: "Please make a suggestion")
        } else
        {
            sendData(topic: top, sugesst: sug)
        }
        
        
        
    }
    func sendData(topic:String, sugesst:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Humbly accepting your message")
            let baseurl = URL(string:BASE_URL+"/customer_support")!
            var parameters = Parameters()
            parameters = ["userId":id, "heading":topic, "suggestion":sugesst]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                        self.popup(msg: "Its geat to hear from you, we will take great consideration of your message")
                    }
                    else
                    {
                        self.popup(msg: "oh. please try later")
                    }
                    
                    
                    
                    
                    print(a)
                }
                else
                {
                    SVProgressHUD.dismiss()
                    print("There was Error")
                    print("Error is \(responseData.result.error)")
                }
            }// Alamofire ends here
            
        }
        else
        {
            self.popup(msg: "could not connect to internet")
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
