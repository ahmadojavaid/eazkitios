//
//  StepOneScreen.swift
//  EAZIKIT
//
//  Created by APPLE on 12/11/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON
import SVProgressHUD

class EditProfile: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var teethimageView: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFirstName: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userAddress: UITextField!
    @IBOutlet weak var userCountry: UITextField!
    @IBOutlet weak var userCity: UITextField!
    @IBOutlet weak var postCode: UITextField!
    @IBOutlet weak var addressLine: UITextField!
    @IBOutlet weak var userAge: UITextField!
    
    var imageCode = "abc"
    var imageAddrsss = String()
    let imagePicker = UIImagePickerController()
    var countriesList = JSON()
    
    
    var thepicker = UIPickerView()
    var countryCode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getCountryList()
        imagePicker.delegate = self
        let imageAddress = DEFAULTS.string(forKey: "user_image")!
        let url = URL(string: IMAGE_BASE_URL+imageAddress)
        profileImage.kf.setImage(with: url)
        thepicker.delegate = self
        thepicker.dataSource = self
        userCountry.inputView = thepicker
        
        let mail = DEFAULTS.string(forKey: "user_email")!
        let name = DEFAULTS.string(forKey: "user_name")!
        userFirstName.text = name
        userEmail.text = mail
        userEmail.isUserInteractionEnabled = false
        
        let teethImagesArray = [UIImage(named :"small3-1"), UIImage(named: "small3-2")]
        teethimageView.animationImages = teethImagesArray as! [UIImage]
        teethimageView.animationDuration = 1
        teethimageView.startAnimating()
        
        
        
        
    }
    @IBAction func continueBtnPressed(_ sender: Any)
    {
        let fName = userFirstName.text!
        let lNmae = userLastName.text!
        let em = userEmail.text!
        let shiftingaddress = userAddress.text!
        let country = userCountry.text!
        let city = userCity.text!
        let code  = postCode.text!
        let address = addressLine.text!
        let age = userAge.text!
        
        
        let ageInt = Int(age)
        
        if fName.isEmpty
        {
            self.popup(msg: "Please Type First Name")
        } else if lNmae.isEmpty
        {
            self.popup(msg: "Please type Last Name")
        } else if em.isEmpty
        {
            self.popup(msg: "Please Type Email")
        } else if shiftingaddress.isEmpty
        {
            self.popup(msg: "Please type a delivery Address")
        } else if country.isEmpty
        {
            self.popup(msg: "Please type your country")
        } else if city.isEmpty
        {
            self.popup(msg: "Please type your city")
        } else if code.isEmpty
        {
            self.popup(msg: "Please type post code")
        } else if address.isEmpty
        {
            self.popup(msg: "Please type your Address")
        } else if age.isEmpty
        {
            self.popup(msg: "Please type your Age")
        } else if ageInt! > 99
        {
            self.popup(msg: "Please provide a valid age")
        } else
        {
            updateState1(city: city, country: country, age: age, lastName: lNmae, firstName: fName, address: address, postCode: code)
        }
        
        
        
        
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
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    func updateState1(city:String, country:String, age:String, lastName :String, firstName:String, address:String, postCode:String)
    {
        if Reach.isConnectedToNetwork()
        {
            let userID = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Updating Profile ")
            let baseurl = URL(string:BASE_URL+"/update/"+userID)!
            var parameters = Parameters()
            if imageCode == "abc"
            {
                parameters = ["city":city, "country":country, "age":age, "lastName":lastName, "address":address, "postCode":postCode, "firstName":firstName]
            }
            else
            {
                
                parameters = ["city":city, "country":country, "age":age, "lastName":lastName, "address":address, "postCode":postCode, "firstName":firstName,"profileImage":self.imageCode]
                
                
            }
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        DEFAULTS.set("logged", forKey: "logged")
                        self.performSegue(withIdentifier: "homee", sender: nil)
                    }
                    else
                    {
                        self.popup(msg: "Could not save data please try later")
                    }
                    
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
    
    //    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    //    {
    //        let vc = segue.destination as! StepOneScreen
    //        vc.imageAddress = self.imageAddrsss
    //
    //    }
    //
    
    
    
    
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
    
    
    func getCountryList()
    {
        if Reach.isConnectedToNetwork()
        {
            
            
            let baseurl = URL(string:"http://www.manageilm.com/countries.json")!
            
            let parameters: Parameters = [:]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    self.countriesList = JSON(responseData.result.value)
                    self.thepicker.reloadAllComponents()
                    
                    
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
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.countriesList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  "\(self.countriesList[row]["name"])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userCountry.text = "\(self.countriesList[row]["name"])"
        countryCode = "\(self.countriesList[row]["code"])"
        
    }
    
    
    
    
    
    
    
}
