//
//  TrailScreenOne.swift
//  EAZIKIT
//
//  Created by APPLE on 3/7/19.
//  Copyright © 2019 Jobesk Inc. All rights reserved.
//

import UIKit

class TrailScreenOne: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
   
    

    @IBOutlet weak var teethimageView: UIImageView!
    @IBOutlet weak var toothImage: UIImageView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var schduleText: UITextField!
    
    
    var firstImage = UIImage()
    
    let firstTimePicker = UIPickerView()
     let thepickerData = ["20 Minutes","25 Minutes","30 Minutes","35 Minutes","40 Minutes","45 Minutes","50 Minutes","55 Minutes","60 Minutes","65 Minutes","75 Minutes" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        blackView.isHidden = true
        bar.alpha = 1.0

        let teethImagesArray = [UIImage(named :"teeth5-1"),UIImage(named :"teeth5-2")]
        toothImage.animationImages = teethImagesArray as? [UIImage]
        toothImage.animationDuration = 1
        toothImage.startAnimating()
        
        
        let teethImagesArray2 = [UIImage(named :"small2-1"), UIImage(named: "small2-2")]
        teethimageView.animationImages = teethImagesArray2 as! [UIImage]
        teethimageView.animationDuration = 1
        teethimageView.startAnimating()
        schduleText.inputView = firstTimePicker
        firstTimePicker.dataSource = self
        firstTimePicker.delegate = self
     
        // Do any additional setup after loading the view.
    }
    


    @IBAction func startBtn(_ sender: Any)
    {
        self.blackView.isHidden = false
    }
    
    
    
    @IBAction func captureImage(_ sender: Any)
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
            firstImage = editedImage
            let imageData = UIImageJPEGRepresentation(firstImage, 0.2)
            PRE_SESSION_IMAGE = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
            dismiss(animated: true, completion: nil)
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            firstImage = pickedImage
            let imageData = UIImageJPEGRepresentation(firstImage, 0.2)
            PRE_SESSION_IMAGE = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
            dismiss(animated: true, completion: nil)
        }
        
        PRE_SESSION_TIME = schduleText.text!
        
        if schduleText.text!.isEmpty
        {
            popup(msg: "Please Select time")
        }
        else
        {
                self.performSegue(withIdentifier: "checkScreen", sender: nil)
        }
        
        
        
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
        schduleText.text = thepickerData[row]
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
