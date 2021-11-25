//
//  HomeScreen.swift
//  EAZIKIT
//
//  Created by APPLE on 12/11/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Kingfisher
import Social
import FacebookShare
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import UserNotificationsUI
import UserNotifications

class HomeScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, sessionTablecellDelegate, UNUserNotificationCenterDelegate{
    
    
    @IBOutlet weak var extraaaView: UIView!
    //    let id = DEFAULTS.string(forKey: "user_id")!
    
    
    @IBOutlet weak var sessionTimeLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var picCons: NSLayoutConstraint!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var btnTop: NSLayoutConstraint!
    @IBOutlet weak var sessionsBtnCons: NSLayoutConstraint!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var anlytics: NSLayoutConstraint!
    var imgs = [UIImage]()
    var sessionRow = Int()
    var index = IndexPath()
    var nibView = ShareBtnsView()
    @IBOutlet weak var tableView: UITableView!
    var sessionRating = String()
    
    var tag = Int()
    
    var sessions = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 450
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clear
        
        bottomConst.constant = self.view.frame.height
        
        picCons.constant = -250
        btnTop.constant = -500
        sessionsBtnCons.constant = -1000
        anlytics.constant = -1000
        
        
        let imageAddress = DEFAULTS.string(forKey: "user_image")!
                let url = URL(string: IMAGE_BASE_URL+imageAddress)
                userProfileImage.kf.setImage(with: url)
        userProfileImage.clipsToBounds = true
        userProfileImage.layer.cornerRadius = 75.0
        userNameLabel.text = DEFAULTS.string(forKey: "user_name")!
        let aa = DEFAULTS.string(forKey: "missedSessions")
        
            if aa == nil
            {
                print("User is using app for firstTime")
            } else
            {
                let bb = DEFAULTS.string(forKey: "missedSessions")!
                print("Vaualkjdhfaljsdhflkjas flkjah flkjahf lkja flkjahdfljasflkj asdlfkjh")
                print(bb)
                if bb == "1"
                {
                    
                   self.performSegue(withIdentifier: "checkListScreen", sender: nil)
                }
                else
                {
                    print("User is using app for more than once")
                        // stay on this screen
                }
            }
        let pref = DEFAULTS.string(forKey: "pref")
        if pref == "1"
        {
            
            getPrefrences()
            getSessions()
        }
        else
        {
            // go to pref screen
            self.performSegue(withIdentifier: "preff", sender: nil)
        }
        let firstTime = DEFAULTS.string(forKey: "FIRST_TIME")
        if firstTime != nil
        {
//           getPrefrences()
        }
        else
        {
//            getPrefrences()
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func menuBtnPressed(_ sender: Any)
    {
        
        bottomConst.constant = 0.0
        picCons.constant = 50
        btnTop.constant = 50.0
        anlytics.constant = 8.0
        sessionsBtnCons.constant = 20.0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            
        }
        
        //setupMenuScreen()
    }
    
    @IBAction func cancelBtn(_ sender: Any)
    {
        
        closeMenuScreen()
    
    }
    
 
    func closeMenuScreen()
    {
        bottomConst.constant = self.view.frame.height
        picCons.constant = -250
        btnTop.constant = -500
        anlytics.constant = -1000
        sessionsBtnCons.constant = -1000
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func anylticsBtnPressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "analytics") as! AnalyticsScreen
        //        vc.newsObj = newsObj
        navigationController?.pushViewController(vc,
                                                animated: true)
    }
    
    @IBAction func settingBtns(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settings") as! Settings
        //        vc.newsObj = newsObj
        navigationController!.pushViewController(vc,
                                                animated: true)
    }
    
    
    

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sessions["Result"].count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessions") as!  sessionTablecell
        cell.backgroundColor = .clear
        cell.counterLabel.text = "\(indexPath.row+1)"
        let date  = Date()
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
        let todaysDate = dateFormatter.string(from: date)

        let serverDate = "\(self.sessions["Result"][indexPath.row]["updated_at"])"
        
            let dateOnly = serverDate.prefix(10)
        
            if todaysDate == dateOnly
            {
                cell.dayLabel.text = "Today"
            }
            else
            {
                cell.dayLabel.text = "\(dateOnly)"
            }
        
        let imgUrl = "\(self.sessions["Result"][indexPath.row]["sessionImage"])"
        let url = URL(string: IMAGE_BASE_URL+imgUrl)
        cell.sessionImage.clipsToBounds = true
        cell.sessionImage.kf.setImage(with: url)
        let timeCarridOut = "\(self.sessions["Result"][indexPath.row]["timeCarriedOut"])"
        if "\(timeCarridOut) minutes" == "1"
        {
            cell.timeCarriedOut.text = "\(timeCarridOut) minute"
        }
        else
        {
            cell.timeCarriedOut.text = "\(timeCarridOut) minutes"
        }
        
        let actualTimeCarriedOut = "\(self.sessions["Result"][indexPath.row]["actualTimeCarriedOut"])"
        
        cell.actualTimeCarrid.text = "\(actualTimeCarriedOut) minutes"
        
        let rating = "\(self.sessions["Result"][indexPath.row]["sessionRating"])"
        
        if rating == "null"
        {
            
            cell.ratingView.isHidden = true
            cell.rateNowView.isHidden = false
            
            let teethImagesArray = [UIImage(named :"small2-1"), UIImage(named: "small2-2")]
            cell.small_images.animationImages = teethImagesArray as! [UIImage]
            cell.small_images.animationDuration = 1
            cell.small_images.startAnimating()
            
            
        }
        else
        {
            cell.rateNowView.isHidden = true
            cell.ratingView.isHidden = false
            let rr = Int(rating)!
            
            if rr < 3
            {
                cell.counterLabelBackground.backgroundColor = .red
            }
            else
            {
                cell.counterLabelBackground.backgroundColor = .green
            }
            
            
            
            cell.ratingView.isUserInteractionEnabled = false
            
            if rating == "1"
            {
                
                cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.twoStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                cell.threeStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                cell.fourStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                cell.fiveStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                
                cell.resultLabel.text = "Bad"
                cell.resultLabel.textColor = .red
            } else if rating == "2"
            {
                cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.twoStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.threeStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                cell.fourStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                cell.fiveStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                
                cell.resultLabel.text = "Not Bad"
                cell.resultLabel.textColor = .red
            } else if rating == "3"
            {
                cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.twoStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.threeStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.fourStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                cell.fiveStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                
                cell.resultLabel.text = "Better"
                cell.resultLabel.textColor = .brown
            } else if rating == "4"
            {
                cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.twoStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.threeStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.fourStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.fiveStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
                cell.resultLabel.text = "Satisfactory"
                cell.resultLabel.textColor = .green
            } else if rating == "5"
            {
                cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.twoStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.threeStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.fourStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.fiveStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
                cell.resultLabel.text = "Great"
                cell.resultLabel.textColor = .green
            }
        }
        
        
        
        cell.rateNoeBtn.tag = indexPath.row
        
        cell.rateNoeBtn.addTarget(self, action: #selector(shareBtnPressed(_:)), for: .touchUpInside)
        
        
        let timsss = serverDate.suffix(8)
        cell.timeLabel.text = "\(timsss)"
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        
        
        if tag == indexPath.row
        {
            cell.rateNowView.isHidden = true
            cell.ratingView.isHidden = false

        }
        
        return cell
    }
    
    @objc func shareBtnPressed(_ sender: UIButton!)
    {
        
        tag = sender.tag
        
        index = IndexPath(row: tag, section: 0)
        let cell = tableView.cellForRow(at: index) as! sessionTablecell
        
            cell.rateNowView.isHidden = true
            cell.ratingView.isHidden = false
            cell.oneStar.addTarget(self, action: #selector(oneStarBtn(_:)), for: .touchUpInside)
            cell.twoStar.addTarget(self, action: #selector(twoStarBtn(_:)), for: .touchUpInside)
            cell.threeStar.addTarget(self, action: #selector(threeStarBtn(_:)), for: .touchUpInside)
            cell.fourStar.addTarget(self, action: #selector(fourStarBtn(_:)), for: .touchUpInside)
            cell.fiveStar.addTarget(self, action: #selector(fiveStarBtn(_:)), for: .touchUpInside)
    }
    
    @objc func oneStarBtn(_ sender: UIButton!)
    {
        let cell = tableView.cellForRow(at: index) as! sessionTablecell
        
        cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.twoStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        cell.threeStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        cell.fourStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        cell.fiveStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        
        cell.resultLabel.text = "Bad"
        cell.resultLabel.textColor = .red
        sessionRating = "1"
        showSheet()
        
        
    }
    @objc func twoStarBtn(_ sender: UIButton!)
    {
        let cell = tableView.cellForRow(at: index) as! sessionTablecell
        cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.twoStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.threeStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        cell.fourStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        cell.fiveStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        
        cell.resultLabel.text = "Not Bad"
        cell.resultLabel.textColor = .red
        sessionRating = "2"
        
        print("\(self.sessions["Result"][tag]["id"])")
        
        showSheet()
    }
    @objc func threeStarBtn(_ sender: UIButton!)
    {
        let cell = tableView.cellForRow(at: index) as! sessionTablecell
        cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.twoStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.threeStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.fourStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        cell.fiveStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        
        cell.resultLabel.text = "Better"
        cell.resultLabel.textColor = .brown
        sessionRating = "3"
        showSheet()
    }
    @objc func fourStarBtn(_ sender: UIButton!)
    {
        let cell = tableView.cellForRow(at: index) as! sessionTablecell
        cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.twoStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.threeStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.fourStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.fiveStar.setBackgroundImage(UIImage(named: "unFilledStar"), for: .normal)
        cell.resultLabel.text = "Satisfactory"
        cell.resultLabel.textColor = .green
        sessionRating = "4"
        showSheet()
    }
    
    @objc func fiveStarBtn(_ sender: UIButton!)
    {
        let cell = tableView.cellForRow(at: index) as! sessionTablecell
        cell.oneStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.twoStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.threeStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.fourStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.fiveStar.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        cell.resultLabel.text = "Great"
        cell.resultLabel.textColor = .green
        sessionRating = "5"
        showSheet()
    }
    
    

    
    func rateSession()
    {
        if Reach.isConnectedToNetwork()
        {
            let sessionId = "\(self.sessions["Result"][tag]["id"])"
            let baseurl = URL(string:BASE_URL+"/session/"+sessionId)!
            print(baseurl)
            SVProgressHUD.show(withStatus: "Posting Rate........")
            let parameters: Parameters = ["sessionRating":sessionRating]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    
                    self.getSessions()
                    
//                    self.sessions = JSON(responseData.result.value)
//                    SESSIONS = self.sessions
//                    if self.sessions["Result"].count == 0
//                    {
////                        self.performSegue(withIdentifier: "checkListScreen", sender: nil)
//                    }
//                    else
//                    {
//
//                    }
//                    self.tableView.reloadData()
//                    print("sessions Data is \(self.sessions)")
                }
                else
                {
                    print("There was Error")
                    print("Error is \(responseData.result.error)")
                }
            }
        }
        else
        {
            self.popup(msg: "could not connect to internet")
        }
    }
    
    
    
    
    func showSheet()
    {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Post Rating", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Saved")
            
            self.rateSession()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
    
  
    
    
    
    func getSessions()
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"/session?userId="+id)!
            print(baseurl)
            SVProgressHUD.show(withStatus: "Getting Sessions")
            let parameters: Parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    self.sessions = JSON(responseData.result.value)
                    SESSIONS = self.sessions
                    if self.sessions["Result"].count == 0
                    {
                       self.performSegue(withIdentifier: "checkListScreen", sender: nil)
                    }
                    else
                    {
                        self.tableView.reloadData()
                    }
                    print("sessions Data is \(self.sessions)")
                }
                else
                {
                    print("There was Error")
                    print("Error is \(responseData.result.error)")
                }
            }
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "checkListScreen"
        {
           let vc = segue.destination as! CheckList
            
            
                if sessions["Result"].count == 0
                {
                    let FIRST_TIME = DEFAULTS.string(forKey: "FIRST_TIME")!
                    vc.firstSession = FIRST_TIME
                } else if sessions["Result"].count == 1
                {
                    let SECOND_TIME = DEFAULTS.string(forKey: "SECOND_TIME")!
                    vc.firstSession = SECOND_TIME
                } else if sessions["Result"].count == 2
                {
                    let THIRD_TIME = DEFAULTS.string(forKey: "THIRD_TIME")!
                    vc.firstSession = THIRD_TIME
                } else if sessions["Result"].count > 2
                {
                    let THIRD_TIME = DEFAULTS.string(forKey: "THIRD_TIME")!
                    vc.firstSession = THIRD_TIME
                }
            
            
        }
        
    }
    
    func getPrefrences()
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"/preference?userId=\(id)")!
            let parameters: Parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let ab = JSON(responseData.result.value)
                    DEFAULTS.set("\(ab["Result"]["firstTime"])", forKey: "FIRST_TIME")
                    DEFAULTS.set("\(ab["Result"]["secondTime"])", forKey: "SECOND_TIME")
                    DEFAULTS.set("\(ab["Result"]["thirdTime"])", forKey: "THIRD_TIME")
                    DEFAULTS.set("\(ab["Result"]["toothfieImage"])", forKey: "FIRST_IMAGE")
                    let dailyTime = "\(ab["Result"]["session_time"])"
                    self.sessionTimeLabel.text = "Next Session time is \(dailyTime)"
//                    if dailyTime == "null"
//                    {
//                        let text = "\(ab["Result"]["scheduled"])"
//                        let range: Range<String.Index> = text.range(of: ",")!
//                        let index: Int = text.distance(from: text.startIndex, to: range.lowerBound)
//                        let dateonly = text.prefix(index)
//                        let range2: Range<String.Index> = text.range(of: "/")!
//                        let index2: Int = text.distance(from: text.startIndex, to: range2.lowerBound)
//                        let day = text.prefix(index2)
//                        let month = text[NSRange(location: index2+1, length: 2)]
//                        let rem = text.count - (dateonly.count + 2)
//                        let timeonly = text[NSRange(location: dateonly.count+2, length: rem)]
//                        let range3: Range<String.Index> = text.range(of: ":")!
//                        let index3: Int = text.distance(from: timeonly.startIndex, to: range3.lowerBound)
//                        let hour = timeonly.prefix(index3)
//                        let aa = "\(timeonly)"
//                        DEFAULTS.set(aa, forKey: "timeDaily")
//                        let min = aa[NSRange(location: hour.count+1, length: 2)]
//                        let ampm = aa.suffix(2)
//                        self.oneNotificationDaily(hour: "\(hour)", minutes: "\(min)", ampm: "\(ampm)", day: "\(day)", month: "\(month)")
//                    }
//                    else
//                    {
                        DEFAULTS.set("\(ab["Result"]["session_time"])", forKey: "timeDaily")
                        let timeonly = "\(ab["Result"]["session_time"])"
                        let range3: Range<String.Index> = timeonly.range(of: ":")!
                        let index3: Int = timeonly.distance(from: timeonly.startIndex, to: range3.lowerBound)
                        let hour = timeonly.prefix(index3)
                        let aa = "\(timeonly)"
                        DEFAULTS.set(aa, forKey: "timeDaily")
                        let min = aa[NSRange(location: hour.count+1, length: 2)]
                        let ampm = aa.suffix(2)
                        
                        DEFAULTS.set("\(ab["Result"]["whiten_days"])", forKey: "whiten_days")
                        DEFAULTS.set("\(ab["Result"]["session_time"])", forKey: "session_time")
                        DEFAULTS.set("\(ab["Result"]["id"])", forKey: "pref_id")
                        self.setupNotifications(hour: "\(hour)", min: "\(min)", ampm: "\(ampm)")
                        
//                    }
                    
                    
                    
                    print("Prefrences are............")
                    print(ab)
                    
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
  
    func closeFriendsTapped(at index: IndexPath)
    {
        sessionRow = index.row
        nibView =  Bundle.main.loadNibNamed("ShareBtnsView", owner: self, options: nil)?[0] as! ShareBtnsView
        nibView.myBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        nibView.twitterShare.addTarget(self, action: #selector(twiterShare(_:)), for: .touchUpInside)
        nibView.facebookShare.addTarget(self, action: #selector(facebookShare(_:)), for: .touchUpInside)
        nibView.googlePlus.addTarget(self, action: #selector(googlePlusShare(_:)), for: .touchUpInside)
        nibView.emailBtn.addTarget(self, action: #selector(emailShare(_:)), for: .touchUpInside)
        nibView.frame = self.view.frame
        self.view.addSubview(nibView)
    }
    @objc func twiterShare(_ sender: UIButton!)
    {
        
        shareDialog()
  
    }
    @objc func facebookShare(_ sender: UIButton!)
    {
        
        shareDialog()
        
    }
    @objc func googlePlusShare(_ sender: UIButton!)
    {
        shareDialog()
    }
    @objc func emailShare(_ sender: UIButton!)
    {
        shareDialog()
    }
    
    @objc func buttonTapped(_ sender: UIButton!)
    {
        nibView.removeFromSuperview()
    }
    
    
    func shareDialog()
    {
        let imageURL = "\(IMAGE_BASE_URL)"+"\(self.sessions["Result"][sessionRow]["sessionImage"])"
        let urlToShare = URL(string:imageURL)
        let title = "I am a quite progress with EAZIKIT"
        let activityViewController = UIActivityViewController(
            activityItems: [title,urlToShare!],
            applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.extraaaView
        //so that ipads won't crash
        present(activityViewController,animated: true,completion: nil)
    }
    
    
    
    
    func setupNotifications(hour:String, min:String, ampm:String)
    {
        let whitenDays = DEFAULTS.string(forKey: "whiten_days")!
        if whitenDays == "Once a day"
        {
                oneNotificationDaily(hour: "\(hour)", minutes: "\(min)", ampm: "\(ampm)")
        } else if whitenDays == "Twice a day"
        {
            twoNotificationDaily(hour: "\(hour)", minutes: "\(min)", ampm: "\(ampm)")
        } else
        {
            thirdDayNotification()
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
        
        
        if response.notification.request.content.categoryIdentifier == "TIMER_EXPIRED" {
            // Handle the actions for the expired timer.
            if response.actionIdentifier == "IamFistOne" {
                // Invalidate the old timer and create a new one. . .
                
                print("adhflakjshdflkajhsflkajshfldh")
            }
            else if response.actionIdentifier == "STOP_ACTION" {
                // Invalidate the timer. . .
            }
        }
        
        // Else handle actions for other notification types. . .
    }

    
    
    
    
    
    
    @IBAction func logoutBtnPressed(_ sender: Any)
    {
        self.logout()
    }
    
    @IBAction func homeScreen(segue: UIStoryboardSegue)
    {
        getPrefrences()
       getSessions()
    }
    
    
    
    func oneNotificationDaily(hour:String, minutes:String, ampm:String)
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
            if hour == "12"
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
        
        print(dateInfo)
        // if notifticaion with time UNTimeIntervalNotificationTrigger(timeInterval: 4.0, repeats: false)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("Daily once notification is set........................")
    }
    
    func twoNotificationDaily(hour:String, minutes:String, ampm:String)
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
            ghanty = Int(hour)! + 12
        }
        else
        {
            ghanty = Int(hour)!
        }
        
        var dateInfo = DateComponents()
        dateInfo.hour = ghanty
        dateInfo.minute = Int(minutes)
        // if notifticaion with time UNTimeIntervalNotificationTrigger(timeInterval: 4.0, repeats: false)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        // second notification
        
        UNUserNotificationCenter.current().delegate = self
        let content2 = UNMutableNotificationContent()
        content2.title = "EAZIKIT"
        content2.subtitle = "Its time for cleanig Kit"
        //        content.body = "I am body of notification"
        content2.badge = 1
//        content2.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")
        content2.sound = UNNotificationSound.default()
        let url2 = Bundle.main.url(forResource: "fairy1", withExtension: "png")!
        if let attchment2 = try? UNNotificationAttachment(identifier: "myIdentifier2", url: url2, options: nil)
        {
            
            content.attachments  = [attchment2]
        }
        if ampm == "pm" || ampm == "PM"
        {
            ghanty = Int(hour)!
        }
        else
        {
            ghanty = Int(hour)! + 12
        }
        var dateInfo2 = DateComponents()
        dateInfo2.hour = ghanty
        dateInfo2.minute = Int(minutes)
        // if notifticaion with time UNTimeIntervalNotificationTrigger(timeInterval: 4.0, repeats: false)
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateInfo2, repeats: true)
        let request2 = UNNotificationRequest(identifier: "notification2", content: content, trigger: trigger2)
        UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
        
        print("Two notifications are set")
        
    }
    
    func thirdDayNotification()
    {
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
        

        // if notifticaion with time UNTimeIntervalNotificationTrigger(timeInterval: 4.0, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (48 * 60 * 60), repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("Third Day notifications is set")
    }
    


    
    @objc func logoutBtn(_ sender: UIButton!)
    {
        logout()
    }
    

    func logout()
    {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        self.performSegue(withIdentifier: "loginScreenss", sender: nil)
    }
 
    @IBAction func homeScreenWithOutReload(segue: UIStoryboardSegue) {
        
        closeMenuScreen()
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
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @IBAction func addSessionBtn(_ sender: Any)
    {
        performSegue(withIdentifier: "checkListScreen", sender: nil)
    }
    
}
