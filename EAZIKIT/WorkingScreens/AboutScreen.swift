//
//  AboutScreen.swift
//  EAZIKIT
//
//  Created by APPLE on 12/20/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AboutScreen: UIViewController {

    
    
    @IBOutlet weak var aboutUsTextFiled: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getUpdates()
        // Do any additional setup after loading the view.
    }

    
    func getUpdates()
    {
        if Reach.isConnectedToNetwork()
        {
            SVProgressHUD.show(withStatus: "Getting sweets words.....")
            let baseurl = URL(string:BASE_URL+"/aboutUs")!
            var parameters = Parameters()
                parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    
                    let a = JSON(responseData.result.value)
                    
                    let string = "\(a["Result"]["aboutUs"])"
                    
                    self.aboutUsTextFiled.text = string

                    SVProgressHUD.dismiss()
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
