//
//  Settings.swift
//  EAZIKIT
//
//  Created by APPLE on 12/19/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class Settings: UIViewController, UITextFieldDelegate{
    
    
    var email = String()
    var pinValue = String()
    var passwordView = ChangePassword()
    var allValues = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        email = DEFAULTS.string(forKey: "user_email")!
        // Do any additional setup after loading the view.
    }
    

    @IBAction func changePasswordBtn(_ sender: Any)
    {
        
        
        passwordView =  Bundle.main.loadNibNamed("ChangePassword", owner: self, options: nil)?[0] as! ChangePassword
        
        passwordView.charOne.delegate = self
        passwordView.charTwo.delegate = self
        passwordView.charThree.delegate = self
        passwordView.charFour.delegate = self
        
        passwordView.charOne.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordView.charTwo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordView.charThree.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordView.charFour.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordView.firstDialog.addTarget(self, action: #selector(fisrtClose(_:)), for: .touchUpInside)
        passwordView.sendResetPin.addTarget(self, action: #selector(showSecondView(_:)), for: .touchUpInside)
        passwordView.sendPinBtn.addTarget(self, action: #selector(sendPin(_:)), for: .touchUpInside)
        passwordView.clostBtn.addTarget(self, action: #selector(fisrtClose(_:)), for: .touchUpInside)
        passwordView.thirdCloseBtn.addTarget(self, action: #selector(fisrtClose(_:)), for: .touchUpInside)
        passwordView.lastSaveBtn.addTarget(self, action: #selector(updatePs(_:)), for: .touchUpInside)
        self.view.addSubview(passwordView)
    }
    
    @objc func fisrtClose(_ sender: UIButton!)
    {
        passwordView.removeFromSuperview()
    
    }
    
    @objc func showSecondView(_ sender: UIButton!)
    {
        
        
        sendRequest(userEmail: email)
        
    }
    
    func showSecond()
    {
        passwordView.fisrtView.isHidden = true
        passwordView.secondView.isHidden = false
    }
    
    @objc func sendPin(_ sender: UIButton!)
    {
        let a = passwordView.charOne.text!
        let b = passwordView.charTwo.text!
        let c = passwordView.charThree.text!
        let d = passwordView.charFour.text!
        pinValue = a + b + c + d
        sendPinNumber(pin: pinValue, userEmail: email)
        
        
    }
    
    func showThird()
    {
        passwordView.secondView.isHidden = true
        passwordView.thirdView.isHidden = false
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        allValues = allValues + textField.text!
        
        if allValues.count == 1
        {
            passwordView.charTwo.becomeFirstResponder()
        } else if allValues.count == 2
        {
            passwordView.charThree.becomeFirstResponder()
        } else if allValues.count == 3
        {
            passwordView.charFour.becomeFirstResponder()
        }
    }

    
    
    
    
    @objc func updatePs(_ sender: UIButton!)
    {
        let pass1 = passwordView.newPass1.text!
        let pass2 = passwordView.newPass2.text!
        
        if pass1.isEmpty
        {
            self.popup(msg: "Please Type Password")
        } else if pass2.isEmpty
        {
            self.popup(msg: "Please Type confrim Password")
        } else if pass1 != pass2
        {
            self.popup(msg: "Password does not match")
        } else
        {
            updatePassword(password: pass2)
        }
    }
    
    
    
    
    func sendRequest(userEmail:String)
    {
        if Reach.isConnectedToNetwork()
        {
            SVProgressHUD.show(withStatus: "Sending Pin...")
            let baseurl = URL(string:BASE_URL+"/forgotPassword")!
            
            let parameters: Parameters = ["email":userEmail]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        self.popup(msg: "Please Check your mail")
                        self.showSecond()
                    }
                    else
                    {
                        self.popup(msg: "Could not send pin, please try later")
                    }
                    
                    
                    
                    
                    
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.popup(msg: "Error accoured please try later")
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
    
    
    
    
    func sendPinNumber(pin:String, userEmail:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            
            SVProgressHUD.show(withStatus: "Verifying Pin...")
            let baseurl = URL(string:BASE_URL+"/verifyPin")!
            
            let parameters: Parameters = ["email":userEmail, "pinValue":pin]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        self.popup(msg: "Please Type new Password")
                        self.showThird()
                    }
                    else
                    {
                        self.popup(msg: "Could not send pin, please try later")
                    }
                    
                    print(a)
                    
                    
                    
                    
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.popup(msg: "Error accoured please try later")
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
    
    
    
    func updatePassword(password:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            
            SVProgressHUD.show(withStatus: "updaing Password")
            let baseurl = URL(string:BASE_URL+"/updatePassword")!
            
            let parameters: Parameters = ["newpassword":password, "pinValue":pinValue, "email":email]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        self.popup(msg: "Password Updated")
                        self.passwordView.removeFromSuperview()
                    }
                    else
                    {
                        self.popup(msg: "Could not update password, please try later")
                    }
                    
                    print(a)
                    
                    
                    
                    
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.popup(msg: "Error accoured please try later")
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
    
    
    @IBAction func settingScreen(segue: UIStoryboardSegue) {
        
    }
    
    
    
}
