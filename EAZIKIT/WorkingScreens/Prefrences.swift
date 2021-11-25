//
//  Prefrences.swift
//  EAZIKIT
//
//  Created by APPLE on 12/12/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class Prefrences: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var teethimageView: UIImageView!
    
    @IBOutlet weak var smallTeethView: UIImageView!
    @IBOutlet weak var DailyTimePicker: UITextField!
    @IBOutlet weak var toothImage: UIImageView!
    @IBOutlet weak var countDown: UISwitch!
    
    @IBOutlet weak var firstTime: UITextField!
    @IBOutlet weak var secondTime: UITextField!
    @IBOutlet weak var thirdTime: UITextField!
    @IBOutlet weak var fouthTime: UITextField!
    @IBOutlet weak var counterIntervalTime: UITextField!
    
    
    var imageCode = "abc"
    var timePicker : UIDatePicker?
    var firstQuestions = "abc"
    var secondQuestions = "abc"
    
        let firstTimePicker = UIPickerView()
        let secondTimePicker = UIPickerView()
        let thirdTimePicker = UIPickerView()
    
    
    let thepickerData = ["20 Minutes","25 Minutes","30 Minutes","35 Minutes","40 Minutes","45 Minutes","50 Minutes","55 Minutes","60 Minutes","65 Minutes","75 Minutes" ]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fouthTime.isUserInteractionEnabled = false
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(Prefrences.timeChanged(timerPicker:)), for: .valueChanged)
        DailyTimePicker.inputView = timePicker
    
        thirdTime.delegate = self
        firstTimePicker.dataSource = self
        firstTimePicker.delegate = self
        firstTime.inputView = firstTimePicker
        
        secondTimePicker.delegate = self
        secondTimePicker.dataSource = self
        secondTime.inputView = secondTimePicker
        
        thirdTimePicker.delegate = self
        thirdTimePicker.dataSource = self
        thirdTime.inputView = thirdTimePicker
        
        
        let teethImagesArray = [UIImage(named :"Tooth8"), UIImage(named: "teeth-3-1")]
        teethimageView.animationImages = teethImagesArray as! [UIImage]
        teethimageView.animationDuration = 1
        teethimageView.startAnimating()
        
        
        
        let smallArray = [UIImage(named :"small4-1"), UIImage(named: "small4-2")]
        smallTeethView.animationImages = smallArray as! [UIImage]
        smallTeethView.animationDuration = 1
        smallTeethView.startAnimating()
        
        
        countDown.isOn = false
    
    
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == thirdTime
        {
            fouthTime.text = thirdTime.text
        }
    }

    @IBAction func groupOne(_ sender: Any)
    {
        let tag = (sender as AnyObject).tag
        
        if tag == 0
        {
            firstQuestions = "Once a day"
        } else if tag == 1
        {
            firstQuestions = "Twice a day"
        } else if tag == 2
        {
            firstQuestions = "Once every two days"
        } else if tag == 3
        {
            firstQuestions = "Other"
        }
        
        print(firstQuestions)
        
        
    }
    
    @IBAction func secondQuestionBtns(_ sender: Any)
    {
        let tag = (sender as AnyObject).tag
        
        if tag == 0
        {
            secondQuestions = "Image Alert on screen"
        } else if tag == 1
        {
            secondQuestions = "Sound Alert"
        } else if tag == 2
        {
            secondQuestions = ""
        }
        
    }
    
    
    @objc func timeChanged(timerPicker:UIDatePicker)
    {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        DailyTimePicker.text = formatter.string(from: timerPicker.date)
        
    }
    
    @IBAction func takePhotoBtn(_ sender: Any)
    {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        teethimageView.stopAnimating()
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            toothImage.image = editedImage
            toothImage.contentMode = .scaleAspectFill
            let imageData = UIImageJPEGRepresentation(toothImage.image!, 0.2)
            imageCode = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
            dismiss(animated: true, completion: nil)
            self.toothImage.contentMode = .scaleAspectFill
            self.toothImage.clipsToBounds = true
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            toothImage.image = pickedImage
            let imageData = UIImageJPEGRepresentation(toothImage.image!, 0.2)
            imageCode = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
            dismiss(animated: true, completion: nil)
            self.toothImage.contentMode = .scaleAspectFill
            self.toothImage.clipsToBounds = true
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveAndFinishBtnPressed(_ sender: Any)
    {
        let dailyTime = DailyTimePicker.text!
        let fTime = firstTime.text!
        let sTime = secondTime.text!
        let tTime = thirdTime.text!
        var countInterval  = "45"
        if countDown.isOn
        {
            countInterval = "1"
        }
        else
        {
            countInterval = "0"
        }
        
        
        if firstQuestions == "abc"
        {
            self.popup(msg: "Please select how whould you like to whiten")
        } else if secondQuestions == "abc"
        {
            self.popup(msg: "Please Select alert type")
        } else if dailyTime.isEmpty
        {
            self.popup(msg: "Please Select Daily Time")
        } else if fTime.isEmpty
        {
            self.popup(msg: "Please type minues in First time")
        } else if sTime.isEmpty
        {
            self.popup(msg: "Please type minues in Second time")
        } else if tTime.isEmpty
        {
            self.popup(msg: "Please type minues in Third time")
        } else if countInterval.isEmpty
        {
            self.popup(msg: "Please Type counter interval")
        } else if imageCode == "abc"
        {
            self.popup(msg: "Please take a picture")
        } else
        {
            savePrefrences(dailyTime: dailyTime, firstTime: fTime, secondTime: sTime, thirdTime: tTime, fourthTime: tTime, countdown: countInterval)
        }
        
        
        
    }
    
 
    func savePrefrences(dailyTime:String, firstTime:String, secondTime:String, thirdTime:String,fourthTime:String,  countdown:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "Saving Prefrences.... ")
            let baseurl = URL(string:BASE_URL+"/preference")!
            let userId = DEFAULTS.string(forKey: "user_id")!
            let parameters: Parameters = ["userId":userId, "whiten_days":firstQuestions, "session_time":dailyTime, "notification":secondQuestions, "toothfieImage":self.imageCode, "firstTime":firstTime, "secondTime":secondTime, "thirdTime":thirdTime, "fourthTime":fourthTime, "countdown":countdown]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        DEFAULTS.set("1", forKey: "pref")
                        DEFAULTS.set("logged", forKey: "logged")
                        self.performSegue(withIdentifier: "Home", sender: nil)
                        
                    }
                    else
                    {
                        self.popup(msg: "Could not store please try later")
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
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return thepickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
                return thepickerData[row]
 
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == firstTimePicker
        {
            firstTime.text = thepickerData[row]
        } else if pickerView == secondTimePicker
        {
            secondTime.text = thepickerData[row]
        } else if pickerView == thirdTimePicker
        {
            thirdTime.text = thepickerData[row]
            fouthTime.text = thepickerData[row]
        }
    }
    
    
    
}
