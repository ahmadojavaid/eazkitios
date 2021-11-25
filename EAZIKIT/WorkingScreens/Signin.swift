//
//  Signin.swift
//  EAZIKIT
//
//  Created by APPLE on 12/11/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit

import Alamofire
import SVProgressHUD
import SwiftyJSON
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import Nuke


class Signin: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var teethimageView: UIImageView!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var password: UITextField!
    var provider = String()
    let profileImage  = UIImageView()
    var imageCode = "abc"
    
    var userName = String()
    var social = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let teethImagesArray = [UIImage(named :"small2-1"), UIImage(named: "small2-2")]
        teethimageView.animationImages = teethImagesArray as! [UIImage]
        teethimageView.animationDuration = 1
        teethimageView.startAnimating()
        fbBtn.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
        
   
            GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
            GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func googleBtnPressed(_ sender: Any)
    {
         GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func signinBtn(_ sender: Any)
    {
        let em = userEmail.text!
        if social == 0
        {
           
            let ps = password.text!
            
            if em.isEmpty
            {
                self.popup(msg: "Please type a valid email Address")
            } else if ps.isEmpty
            {
                self.popup(msg: "Please type Password")
            } else if CHECK_EMAIL(testStr: em)
            {
                
                signin(userEmail: em, userPassword: ps)
                
            }
            else
            {
                self.popup(msg: "Please type a valid email address")
            }
            
        }
        else
        {
            socailLogin(userEmail: em, userPassword: "socialLoginPassword123456789")
        }
        
        
        
        
        
    }
    
 
    
    
    
    func signin(userEmail:String, userPassword:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            
            SVProgressHUD.show(withStatus: "Logging in.... ")
            let baseurl = URL(string:BASE_URL+"/userLogin")!
            
            let parameters: Parameters = ["email":userEmail, "password":userPassword]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        let user_id = "\(a["Result"]["id"])"
                        let profileImage = "\(a["Result"]["profileImage"])"
                        let userName = "\(a["Result"]["username"])"
                        DEFAULTS.set(userEmail, forKey: "user_email")
                        DEFAULTS.set(profileImage, forKey: "user_image")
                        DEFAULTS.set(userPassword, forKey: "user_password")
                        DEFAULTS.set(userEmail, forKey: "user_email")
                        DEFAULTS.set(user_id, forKey: "user_id")
                        DEFAULTS.set(userName, forKey: "user_name")
                        
                        
                        let prefStatus = "\(a["Result"]["prefStatus"])"
                        let age = "\(a["Result"]["age"])"
                       
                        if age == "null"
                        {
                            self.performSegue(withIdentifier: "profileStep1", sender: nil)
                        }
                        else if prefStatus == "0"
                        {
                           self.performSegue(withIdentifier: "prefrencesScreen", sender: nil)
                        }
                        else
                        {
                         
                            DEFAULTS.set("1", forKey: "pref")
                            DEFAULTS.set("logged", forKey: "logged")
                            self.performSegue(withIdentifier: "homeScreen", sender: nil)
                        }
    
                    }
                    else
                    {
                        self.popup(msg: "invalid email or password")
                    }
                    
                    print(a)
                    
                    
                    
                }
                else
                {
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
    

    
    
    func socailLogin(userEmail:String, userPassword:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            
            SVProgressHUD.show(withStatus: "Logging in.... ")
            let baseurl = URL(string:BASE_URL+"/userLogin")!
            
            let parameters: Parameters = ["email":userEmail, "password":userPassword]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        let user_id = "\(a["Result"]["id"])"
                        let profileImage = "\(a["Result"]["profileImage"])"
                        let userName = "\(a["Result"]["username"])"
                        DEFAULTS.set(userEmail, forKey: "user_email")
                        DEFAULTS.set(profileImage, forKey: "user_image")
                        DEFAULTS.set(userPassword, forKey: "user_password")
                        DEFAULTS.set(userEmail, forKey: "user_email")
                        DEFAULTS.set(user_id, forKey: "user_id")
                        DEFAULTS.set(userName, forKey: "user_name")
                        
                        
                        let prefStatus = "\(a["Result"]["prefStatus"])"
                        let age = "\(a["Result"]["age"])"
                        
                        if age == "null"
                        {
                            self.performSegue(withIdentifier: "profileStep1", sender: nil)
                        }
                        else if prefStatus == "0"
                        {
                            self.performSegue(withIdentifier: "prefrencesScreen", sender: nil)
                        }
                        else
                        {
                            
                            DEFAULTS.set("1", forKey: "pref")
                            DEFAULTS.set("logged", forKey: "logged")
                            self.performSegue(withIdentifier: "homeScreen", sender: nil)
                        }
                        
                    }
                    else
                    {
                        self.popup(msg: "invalid email or password")
                    }
                    
                    print(a)
                    
                    
                    
                }
                else
                {
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
    
//    homeScreen
    
    
    @objc func handleCustomFBLogin() {
        
        print("I am clicked")
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err)
                return
            }
            
            self.showEmailAddress()
        }
    }
    
    
    
    func showEmailAddress() {
        
        
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err)
                return
            }
            let myjson = JSON(result!)
            let mail = "\(myjson["email"])"
            
            self.userEmail.text = mail
            self.social = 1
            self.password.isUserInteractionEnabled = false
            
            print("Email is \(mail)")
            
            let user_id = "\(myjson["id"])"
            let name = "\(myjson["name"])"
            self.userName = name
            self.provider = "facebook"
            let userPic = "http://graph.facebook.com/\(user_id)/picture?type=large"
            let url = URL(string: userPic)
            
            let task = ImagePipeline.shared.loadImage(
                with: url!,
                progress: { _, completed, total in
                    print("progress updated")
            },
                completion: { response, error in
                    
                    self.profileImage.image = response!.image
                    self.profileImage.clipsToBounds = true
                    self.profileImage.layer.cornerRadius = 50
                    
                    self.socialSignup()
            }
            )
            
            
           
     
        }
        
        
        
        
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"email"]).start { (connection, result, err) in
//
//            if err != nil {
//                print("Failed to start graph request:", err)
//                return
//            }
//            print("I am here")
//            let myjson = JSON(result!)
//            let mail = "\(myjson["email"])"
//            print(mail)
//
//        }
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        
        
        if let error = error
        {
            print(error.localizedDescription)
            return
        }
        let gmail = user.profile.email!
        self.userEmail.text = gmail
        self.userName = user.profile.name!
        self.social = 1
        self.password.isUserInteractionEnabled = false
        print("I am called......")
        print(gmail)
        self.provider = "google"
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                          accessToken: (authentication?.accessToken)!)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            print("User Signed Into Firebase")
            
        }
        
        let url = user.profile.imageURL(withDimension: 320)
        
        
        let task = ImagePipeline.shared.loadImage(
            with: url!,
            progress: { _, completed, total in
                print("progress updated")
        },
            completion: { response, error in
                
                self.profileImage.image = response!.image
                self.profileImage.clipsToBounds = true
                self.profileImage.layer.cornerRadius = 50
                
                self.socialSignup()
        }
        )
        
        
        self.socailLogin(userEmail: gmail, userPassword: "socialLoginPassword123456789")
    }
    

    
    func socialSignup()
    {
        
        let name = self.userName
        let em = self.userEmail.text!
        
        
        let imageData = UIImageJPEGRepresentation(profileImage.image!, 0.2)
        imageCode = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
        
        if Reach.isConnectedToNetwork()
        {
            SVProgressHUD.show(withStatus: "Please Wait.....")
            let baseurl = URL(string:BASE_URL+"/External_Login")!
            
            let parameters: Parameters = ["username":name, "email":em, "password":"socialLoginPassword123456789", "profileImage":self.imageCode, "provider":self.provider, "fullName":name]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        let user_id = "\(a["Result"]["id"])"
                        let profileImage = "\(a["Result"]["profileImage"])"
                        let userName = "\(a["Result"]["username"])"
                        DEFAULTS.set(em, forKey: "user_email")
                        DEFAULTS.set(profileImage, forKey: "user_image")
//                        DEFAULTS.set(userPassword, forKey: "user_password")
//                        DEFAULTS.set(userEmail, forKey: "user_email")
                        DEFAULTS.set(user_id, forKey: "user_id")
                        DEFAULTS.set(userName, forKey: "user_name")
                        
                        
                        let prefStatus = "\(a["Result"]["prefStatus"])"
                        let age = "\(a["Result"]["age"])"
                        
                        if age == "null"
                        {
                            self.performSegue(withIdentifier: "profileStep1", sender: nil)
                        }
                        else if prefStatus == "0"
                        {
                            self.performSegue(withIdentifier: "prefrencesScreen", sender: nil)
                        }
                        else
                        {
                            
                            DEFAULTS.set("1", forKey: "pref")
                            DEFAULTS.set("logged", forKey: "logged")
                            self.performSegue(withIdentifier: "homeScreen", sender: nil)
                        }
                        
                    }
                    else
                    {
                        self.popup(msg: "invalid email or password")
                    }
                    
                    
                    
                    
                    
                    
                    //                    if statusCode == "200"
                    //                    {
                    //                        let user_id = "\(a["Result"]["id"])"
                    //                        let profileImage = "\(a["Result"]["profileImage"])"
                    //                        let email = "\(a["Result"]["email"])"
                    //                        DEFAULTS.set(profileImage, forKey: "user_image")
                    //                        DEFAULTS.set(user_id, forKey: "user_id")
                    //                        DEFAULTS.set(email, forKey: "user_email")
                    //                        self.nextScreen(msg: "account Created")
                    //                    }
                    //                    else
                    //                    {
                    //                        self.popup(msg: "Account could not created please try later")
                    //                    }
                    print(a)
                    
                    
                    
                    
                    
                }
                else
                {
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

    
}
