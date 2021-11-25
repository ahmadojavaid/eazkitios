//
//  SessionScreen.swift
//  EAZIKIT
//
//  Created by APPLE on 12/13/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON
import SVProgressHUD
import UserNotificationsUI
import UserNotifications
class SessionScreen: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var notNowBtnOutlet: UIButton!
    @IBOutlet weak var teethimageView: UIImageView!
    @IBOutlet weak var toothimage2: UIImageView!
    @IBOutlet weak var dimssImage: UIImageView!
    var state = Int()
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var startOne: UIButton!
    @IBOutlet weak var startTwo: UIButton!
    @IBOutlet weak var starThree: UIButton!
    @IBOutlet weak var starFour: UIButton!
    @IBOutlet weak var starFive: UIButton!
    @IBOutlet weak var foruthImageView: UIImageView!
    @IBOutlet weak var preBTn: DLRadioButton!

    @IBOutlet weak var newBtn: DLRadioButton!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var nextSessionView: UIView!
    @IBOutlet weak var schduleText: UITextField!
    
    @IBOutlet weak var beforeTeethImage: UIImageView!
    @IBOutlet weak var takeImageView: UIView!
    
    var ImageCode = String()
    
    @IBOutlet weak var dailyTime: UILabel!
    
    @IBOutlet weak var lastView: UIView!
    @IBOutlet weak var afterImage: UIImageView!
    var sessionTime  = String()
    let shapLayer = CAShapeLayer()
    
    var tempMinutes = Int()
    var tempSeconds = 60
    
    var timePicker : UIDatePicker?
    var seconds = Int()
    var timer = Timer()
    var carriedTime = 1
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    // nextEssion
    var oldSessionSelected = "abc"
    
    @IBOutlet weak var newSessionTime: UITextField!
    var sessionRate = String()
    fileprivate func animateToothImages() {
        let teethImagesArray = [UIImage(named :"small2-1"), UIImage(named: "small2-2")]
        teethimageView.animationImages = teethImagesArray as! [UIImage]
        teethimageView.animationDuration = 1
        teethimageView.startAnimating()
        
        
        let secondArray = [UIImage(named :"small5-1"), UIImage(named: "small5-2")]
        toothimage2.animationImages = secondArray as! [UIImage]
        toothimage2.animationDuration = 1
        toothimage2.startAnimating()
        
        
        let fourthArray = [UIImage(named :"fairy1"), UIImage(named: "fairy2"),UIImage(named :"fairy3"),UIImage(named :"fairy4")]
        foruthImageView.animationImages = fourthArray as! [UIImage]
        foruthImageView.animationDuration = 1
        foruthImageView.startAnimating()
        
        dimssImage.animationImages = fourthArray as! [UIImage]
        dimssImage.animationDuration = 1
        dimssImage.startAnimating()
        let fImage = DEFAULTS.string(forKey: "FIRST_IMAGE")!
        let st = IMAGE_BASE_URL+fImage
        let url = URL(string: st)
        beforeTeethImage.kf.setImage(with: url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fTime = DEFAULTS.string(forKey: "FIRST_TIME")!
        let sTime = DEFAULTS.string(forKey: "SECOND_TIME")!
        let tTime = DEFAULTS.string(forKey: "THIRD_TIME")!
        
        if SESSIONS["Result"].count == 0
        {
            sessionTime = "\(fTime.prefix(2))"
        } else if SESSIONS["Result"].count == 1
        {
            sessionTime = "\(sTime.prefix(2))"
        } else if SESSIONS["Result"].count == 2
        {
            sessionTime = "\(tTime.prefix(2))"
        } else if SESSIONS["Result"].count >= 3
        {
            sessionTime = "\(tTime.prefix(2))"
        }
        
            tempMinutes = Int(sessionTime)! - 1
            runTimer()
            timerFunction()
            teethAnimation()
            animate()
            resetAll()
        let dTime = DEFAULTS.string(forKey: "timeDaily")!
        dailyTime.text = dTime
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(self.timeChanged(timerPicker:)), for: .valueChanged)
        schduleText.inputView = timePicker
        animateToothImages()
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func timerFunction()
    {
        seconds = Int(sessionTime)! * 60
   
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(SessionScreen.updateTimer)), userInfo: nil, repeats: true)
    }

     func animate ()
    {
        let aa = Int(sessionTime)! * 11
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = Double(seconds+aa)
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapLayer.add(basicAnimation, forKey: "simpleAnimation")
   
    }
    
    @objc func updateTimer()
    {
        seconds -= 1
        
        tempSeconds -= 1
        
        
        if tempSeconds == 0
        {
            tempSeconds = 59
            tempMinutes -= 1
            carriedTime += 1
        }
        
        
        minutesLabel.text = "\(tempMinutes):\(tempSeconds)"
        if seconds == 0
        {
            timer.invalidate()
            showRateView()
        }
    }
    
    @IBAction func stopBtn(_ sender: Any)
    {
            StopTimerFunction()
    }
    
    
    
    fileprivate func teethAnimation() {
        let teethImagesArray = [UIImage(named :"teeth5-1"),UIImage(named :"teeth5-2")]
        firstImage.animationImages = teethImagesArray as! [UIImage]
        firstImage.animationDuration = 1
        firstImage.startAnimating()
        self.minutesLabel.text = sessionTime
        self.totalLabel.text = "Total time : \(sessionTime) minutes"
        
        let trackLayer = CAShapeLayer()
        let ponint = CGPoint(x: self.animationView.center.x-90, y: self.animationView.center.y-270)
        
        let circularPath = UIBezierPath(arcCenter: ponint, radius: 90, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi*2, clockwise: true)
        
        trackLayer.strokeColor = UIColor.blue.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 18
        trackLayer.lineCap = kCALineCapRound
        trackLayer.path = circularPath.cgPath
        animationView.layer.addSublayer(trackLayer)
        shapLayer.strokeColor = UIColor.yellow.cgColor
        shapLayer.fillColor = UIColor.clear.cgColor
        shapLayer.lineWidth = 20
        shapLayer.lineCap = kCALineCapRound
        shapLayer.strokeEnd = 0
        shapLayer.path = circularPath.cgPath
        animationView.layer.addSublayer(shapLayer)
    }
    
    
    @IBAction func startOneBtn(_ sender: Any)
    {
        resetAll()
        sessionRate = "1"
        notNowBtnOutlet.isHidden = true
        commentsLabel.text = "Bad"
        commentsLabel.textColor = .red
        startOne.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        self.commentsLabel.isHidden = false
        
    }
    @IBAction func startTwoBtn(_ sender: Any)
    {
        resetAll()
        sessionRate = "2"
        notNowBtnOutlet.isHidden = true
        commentsLabel.text = "Fair"
        commentsLabel.textColor = .red
        self.commentsLabel.isHidden = false
        startOne.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        startTwo.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        
    }
    @IBAction func starThreeBtn(_ sender: Any)
    {
        resetAll()
        sessionRate = "3"
        notNowBtnOutlet.isHidden = true
        commentsLabel.text = "Good"
        commentsLabel.textColor = .brown
        self.commentsLabel.isHidden = false
        startOne.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        startTwo.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        starThree.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        
    }
    @IBAction func starFourBtn(_ sender: Any)
    {
        resetAll()
        sessionRate = "4"
        commentsLabel.text = "Satisfactory"
        commentsLabel.textColor = .green
        notNowBtnOutlet.isHidden = true
        self.commentsLabel.isHidden = false
        startOne.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        startTwo.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        starThree.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        starFour.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        
    }
    @IBAction func startFiveBtn(_ sender: Any)
    {
        resetAll()
        self.commentsLabel.isHidden = false
        sessionRate = "5"
        notNowBtnOutlet.isHidden = true
        commentsLabel.text = "Great"
        commentsLabel.textColor = .green
        startOne.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        startTwo.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        starThree.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        starFour.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        starFive.setBackgroundImage(UIImage(named:"filledStar"), for:  .normal)
        
    }
    
    
    func resetAll()
    {
        startOne.setBackgroundImage(UIImage(named:"unFilledStar"), for:  .normal)
        startTwo.setBackgroundImage(UIImage(named:"unFilledStar"), for:  .normal)
        starThree.setBackgroundImage(UIImage(named:"unFilledStar"), for:  .normal)
        starFour.setBackgroundImage(UIImage(named:"unFilledStar"), for:  .normal)
        starFive.setBackgroundImage(UIImage(named:"unFilledStar"), for:  .normal)
    }
    
    @objc func timeChanged(timerPicker:UIDatePicker)
    {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        schduleText.text = formatter.string(from: timerPicker.date)
        
    }
    
    
    func showRateView()
    {
        
        shapLayer.strokeEnd = 0.5
        rateView.isHidden = false
    }
    
    @IBAction func nextSessionScreenBtn(_ sender: Any)
    {
        
        rateView.isHidden = true
        nextSessionView.isHidden = false
    }
    
    @IBAction func schduleBtn(_ sender: Any)
    {
        nextSessionView.isHidden = true
        
    }
    
    @IBAction func notNowBtn(_ sender: Any)
    {
        sessionRate = "null"
        rateView.isHidden = true
        nextSessionView.isHidden = false
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
            afterImage.image = editedImage
            self.afterImage.contentMode = .redraw
            let imageData = UIImageJPEGRepresentation(afterImage.image!, 0.2)
            ImageCode = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
            dismiss(animated: true, completion: nil)
            self.afterImage.clipsToBounds = true
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            afterImage.image = pickedImage
            let imageData = UIImageJPEGRepresentation(afterImage.image!, 0.2)
            ImageCode = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
            dismiss(animated: true, completion: nil)
            self.afterImage.contentMode = .redraw
            self.afterImage.clipsToBounds = true
        }
        
        takeImageView.isHidden = true
        lastView.isHidden = false
    }
    
    
    @IBAction func previousSessionBtn(_ sender: Any)
    {
        newBtn.setTitleColor(.gray, for: .normal)
        preBTn.setTitleColor(.blue, for: .normal)
        oldSessionSelected = "1"
    }
    @IBAction func newSessionTime(_ sender: Any)
    {
        newBtn.setTitleColor(.blue, for: .normal)
        preBTn.setTitleColor(.gray, for: .normal)
        oldSessionSelected = "0"
    }
    
    @IBAction func nextSessionBtn(_ sender: Any)
    {
        
        if oldSessionSelected == "abc"
        {
           self.popup(msg: "Pleaes Choose next session")
        } else if oldSessionSelected == "1"
        {
            let session_time = DEFAULTS.string(forKey: "session_time")!
            let hour = session_time.prefix(1)
            let minutes = session_time[NSRange(location: 2, length: 2)]
            let ampm = session_time.suffix(2)
            oldNotifications(hour: "\(hour)", minutes: "\(minutes)", ampm: String(ampm))
            takeImageView.isHidden = false
        }
        else
        {
            let text = newSessionTime.text!
            if text.isEmpty
            {
                self.popup(msg: "Please Select new Time")
            }
            else
            {
                let range3: Range<String.Index> = text.range(of: ":")!
                let index3: Int = text.distance(from: text.startIndex, to: range3.lowerBound)
                let hour = text.prefix(index3)
                let aa = "\(text)"
                let min = aa[NSRange(location: hour.count+1, length: 2)]
                let ampm = aa.suffix(2)
                oldNotifications(hour: "\(hour)", minutes: "\(min)", ampm: String(ampm))
                updatePreference(date:text)
                nextSessionView.isHidden = true
                takeImageView.isHidden = false
            }
        }
       
    }
    
    
    
    
    @IBAction func cancelBtnPressed(_ sender: Any)
    {
        saveWithoutImage()
    }
    @IBAction func lastBtn(_ sender: Any)
    {
        saveWithImage()
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
    
    func saveWithoutImage()
    {
        if Reach.isConnectedToNetwork()
        {
            SVProgressHUD.show(withStatus: "Saving Session")
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"/session")!
            let parameters: Parameters = ["userId":id, "sessionRating":sessionRate, "timeCarriedOut":"\(carriedTime)", "actualTimeCarriedOut":sessionTime]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let ab = JSON(responseData.result.value)
                    print(ab)
                     UIApplication.shared.isIdleTimerDisabled = false
                    DEFAULTS.set("0", forKey: "missedSessions")
                    self.performSegue(withIdentifier: "homeS", sender: nil)
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.popup(msg: "Could not fetched data please try later")
                    print("There was Erroradsfakjsdfhjal fjklahfkljahdfs lkjhadslkjfhalkjsdhflkajdshflkajflkjahsd flkjadsflkj adslkjfhalskdjf")
                    print("Error is \(responseData.result.error)")
                }
            }
            
            
        }
        else
        {
            self.popup(msg: "could not connect to internet")
        }
    }

    func saveWithImage()
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"/session")!
            SVProgressHUD.show(withStatus: "Saving Session")
            let parameters: Parameters = ["userId":id, "sessionRating":sessionRate, "timeCarriedOut":"\(carriedTime)", "actualTimeCarriedOut":sessionTime, "sessionImage":ImageCode]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let ab = JSON(responseData.result.value)
                    DEFAULTS.set("0", forKey: "missedSessions")
                     UIApplication.shared.isIdleTimerDisabled = false
                    self.performSegue(withIdentifier: "homeS", sender: nil)
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.popup(msg: "Could not fetched data please try later")
                    print("There was Erroradsfakjsdfhjal fjklahfkljahdfs lkjhadslkjfhalkjsdhflkajdshflkajflkjahsd flkjadsflkj adslkjfhalskdjf")
                    print("Error is \(responseData.result.error)")
                }
            }
            
            
        }
        else
        {
            self.popup(msg: "could not connect to internet")
        }
    }
    
   
    
 
    
    
    func oneNotificationDaily(hour:String, minutes:String, ampm:String, day:String, month:String)
    {
        var ghanty = Int()
        UNUserNotificationCenter.current().delegate = self
        let content = UNMutableNotificationContent()
        content.title = "EAZIKIT"
        content.subtitle = "Whiten your teeth kit by Briyte"
        //        content.body = "I am body of notification"
        content.badge = 1
//        content.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")
        content.sound = UNNotificationSound.default()
        let url = Bundle.main.url(forResource: "fairy1", withExtension: "png")!
        if let attchment = try? UNNotificationAttachment(identifier: "myIdentifier", url: url, options: nil)
        {
            
            content.attachments  = [attchment]
        }
        
        if ampm == "pm" || ampm == "PM"
        {
            if Int(hour) == 12
            {
                    ghanty = Int(hour)!
            }
            else
            {
                    ghanty = Int(hour)! + 12
            }
        }
        else
        {
            ghanty = Int(hour)!
        }
        
        
        var dateInfo = DateComponents()
        dateInfo.hour = ghanty
        dateInfo.minute = Int(minutes)
        dateInfo.day = Int(day)
        dateInfo.month = Int(month)
        dateInfo.year = 2018
        
        print(dateInfo)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("Daily once notification is set")
    }
    
    func oldNotifications(hour:String, minutes:String, ampm:String)
    {
        var ghanty = Int()
        UNUserNotificationCenter.current().delegate = self
        let content = UNMutableNotificationContent()
        content.title = "EAZIKIT"
        content.subtitle = "Whiten your teeth kit by Briyte"
        //        content.body = "I am body of notification"
        content.badge = 1
//        content.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")
        content.sound = UNNotificationSound.default()
        let url = Bundle.main.url(forResource: "fairy1", withExtension: "png")!
        if let attchment = try? UNNotificationAttachment(identifier: "myIdentifier", url: url, options: nil)
        {
            
            content.attachments  = [attchment]
        }
        
        if ampm == "pm" || ampm == "PM"
        {
            if Int(hour) == 12
            {
                ghanty = Int(hour)!
            }
            else
            {
                ghanty = Int(hour)! + 12
            }
        }
        else
        {
            ghanty = Int(hour)!
        }
        var dateInfo = DateComponents()
        dateInfo.hour = ghanty
        dateInfo.minute = Int(minutes)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("Daily once notification is set")
    }
    
 
    
    
    func updatePreference(date:String)
    {
        if Reach.isConnectedToNetwork()
        {
            let pref_id = DEFAULTS.string(forKey: "pref_id")!
            let baseurl = URL(string:BASE_URL+"/preference/"+pref_id)!
            let parameters: Parameters = ["session_time":date]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    print("Updaing preferences response is ")
                    let ab = JSON(responseData.result.value)
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.popup(msg: "Could not fetched data please try later")
                    print("There was Erroradsfakjsdfhjal fjklahfkljahdfs lkjhadslkjfhalkjsdhflkajdshflkajflkjahsd flkjadsflkj adslkjfhalskdjf")
                    print("Error is \(responseData.result.error)")
                }
            }
            
            
        }
        else
        {
            self.popup(msg: "could not connect to internet")
        }
        
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        DEFAULTS.set("1", forKey: "missedSessions")
        completionHandler([.alert, .badge, .sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        self.performSegue(withIdentifier: "checkListScreen", sender: nil)
        // Else handle actions for other notification types. . .
    }
    
    
    
    func StopTimerFunction()
    {
        
        let actionSheetController = UIAlertController(title: nil, message: "Are you sure to Stop Timer?", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Yes", style: .cancel) { action -> Void in
            
            self.timer.invalidate()
            self.showRateView()
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Cancel", style: .default) { action -> Void in
            
        }
        actionSheetController.addAction(saveActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    

}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    
    
    
    
    
    
}


