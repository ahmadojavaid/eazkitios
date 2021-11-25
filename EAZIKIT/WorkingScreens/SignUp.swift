//
//  SignUp.swift
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
import Kingfisher

var check = SignUp()


class SignUp: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,  GIDSignInUIDelegate, GIDSignInDelegate{
  
    @IBOutlet weak var teethimageView: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var passs1: UITextField!
    @IBOutlet weak var pass2: UITextField!
    var imageCode =  "abc"
    
    var provider = String()
    
    var social = 0
    
    var imageAddrsss = String()
     let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        let teethImagesArray = [UIImage(named :"small2-1"), UIImage(named: "small2-2")]
        teethimageView.animationImages = teethImagesArray as! [UIImage]
        teethimageView.animationDuration = 1
        teethimageView.startAnimating()
        
        
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        

        
    }
    
    
    
    @IBAction func facebookBtn(_ sender: Any)
    {
         handleCustomFBLogin()
    }
    
    
    
    
 
    
    @IBAction func SignUpBtn(_ sender: Any)
    {
        
        let imageData = UIImageJPEGRepresentation(profileImage.image!, 0.2)
        imageCode = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
        
        if social == 0
        {
            let userN = userName.text!
            let ps1 = passs1.text!
            let ps2 = pass2.text!
            let em = userEmail.text!
            
            if isValidEmail(testStr: em)
            {
                if imageCode == "abc"
                {
                    self.popup(msg: "Please Select Image")
                } else if userN.isEmpty
                {
                    self.popup(msg: "Please Type a name")
                } else if ps1.isEmpty
                {
                    self.popup(msg: "Please Type Password")
                } else if ps2.isEmpty
                {
                    self.popup(msg: "Please Type Confirm Password")
                } else if ps1 != ps2
                {
                    self.popup(msg: "Password Does not Match")
                }
                else
                {
                    signUpSerCall(userName: userN, userEmail: em, userPassword: ps1)
                }
            }
            else
            {
                self.popup(msg: "Please Provide a valid Email")
            }
        }
        else
        {
            socialSignup()
        }
        
        

        
        
       
    }
    func signUpSerCall(userName: String, userEmail:String, userPassword:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            
            SVProgressHUD.show(withStatus: "Creating Account")
            let baseurl = URL(string:BASE_URL+"/usersignup")!
            
            let parameters: Parameters = ["username":userName, "email":userEmail, "password":userPassword, "profileImage":self.imageCode]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    
                    let statusCode = "\(a["statusCode"])"

                    if statusCode == "200"
                    {
                        let user_id = "\(a["Result"]["id"])"
                        let profileImage = "\(a["Result"]["profileImage"])"
                        let email = "\(a["Result"]["email"])"
                        DEFAULTS.set(profileImage, forKey: "user_image")
                        DEFAULTS.set(user_id, forKey: "user_id")
                        DEFAULTS.set(email, forKey: "user_email")
                        self.nextScreen(msg: "account Created")
                    }
                    else
                    {
                        self.popup(msg: "Account could not created please try later")
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
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
//        let vc = segue.destination as! StepOneScreen
//            vc.imageAddress = self.imageAddrsss
        
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
    
    func nextScreen(msg:String)
    {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
            
            self.performSegue(withIdentifier: "step1", sender: nil)
        })
        myAlert.addAction(OKAction)
        self.present(myAlert, animated: true, completion: nil)
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func addImageBtnPressed(_ sender: Any)
    {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        //        profileImage.contentMode = .scaleAspectFit
        profileImage.image = pickedImage
        let imageData = UIImageJPEGRepresentation(profileImage.image!, 0.2)
        imageCode = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
        dismiss(animated: true, completion: nil)
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = 50
        print("adadfasdfasdfasdfadsfa adsf asfasdf")
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    @IBAction func loginBtn(_ sender: Any)
    {
        self.performSegue(withIdentifier: "login", sender: nil)
    }
    
    
    
    @objc func handleCustomFBLogin() {
        

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
            
            print("Email is \(mail)")
            
            self.userEmail.text = mail
            let user_id = "\(myjson["id"])"
            let name = "\(myjson["name"])"
            self.userName.text = name
            let userPic = "http://graph.facebook.com/\(user_id)/picture?type=large"
            let url = URL(string: userPic)
//            self.profileImage.kf.setImage(with: url)
            
            
            
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
            
            
            
            self.social = 1
            self.pass2.isUserInteractionEnabled = false
            self.passs1.isUserInteractionEnabled = false
            self.provider = "facebook"
            
        }
    }
    
    
    
    @IBAction func googleBtn(_ sender: Any)
    {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let gmail = user.profile.email!
        let name = user.profile.name!
        self.userName.text = name
        let pic = user.profile.imageURL(withDimension: 320)!
        print("address of pic is \(pic)")
        print("I am called......")
        print(gmail)
        self.userEmail.text = gmail
        let url = URL(string: "\(pic)")
//        self.profileImage.kf.setImage(with: url)
        
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
        
        
        
        
        self.social = 1
        
        self.pass2.isUserInteractionEnabled = false
        self.passs1.isUserInteractionEnabled = false
        self.provider = "google"
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                       accessToken: (authentication?.accessToken)!)

        Auth.auth().signIn(with: credential) { (user, error) in
            print("User Signed Into Firebase")
            
        }
    }
    
    
    
    
    func socialSignup()
    {
        
        let name = self.userName.text!
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
                        DEFAULTS.set(self.userEmail.text!, forKey: "user_email")
                        DEFAULTS.set(profileImage, forKey: "user_image")
//                        DEFAULTS.set(self.userPassword, forKey: "user_password")
                        DEFAULTS.set(user_id, forKey: "user_id")
                        DEFAULTS.set(userName, forKey: "user_name")
                        
                        
                        let prefStatus = "\(a["Result"]["prefStatus"])"
                        let age = "\(a["Result"]["age"])"
                        
                        if age == "null"
                        {
                            self.performSegue(withIdentifier: "step2", sender: nil)
                        }
                        else if prefStatus == "0"
                        {
                            self.performSegue(withIdentifier: "prefScreen", sender: nil)
                        }
                        else
                        {
                            
                            DEFAULTS.set("1", forKey: "pref")
                            DEFAULTS.set("logged", forKey: "logged")
                            self.performSegue(withIdentifier: "hooooome", sender: nil)
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
