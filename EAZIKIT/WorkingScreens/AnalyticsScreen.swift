//
//  AnalyticsScreen.swift
//  EAZIKIT
//
//  Created by APPLE on 12/20/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
import Kingfisher

class AnalyticsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var seconView: UIView!
    @IBOutlet weak var beforeTeethImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let fImage = DEFAULTS.string(forKey: "FIRST_IMAGE")!
        let st = IMAGE_BASE_URL+fImage
        let url = URL(string: st)
        beforeTeethImage.kf.setImage(with: url)
        
        beforeTeethImage.clipsToBounds = true
        beforeTeethImage.layer.cornerRadius = 20
        beforeTeethImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = seconView.frame.height-50
    
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SESSIONS["Result"].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "analytics") as! AnalyticsCell
        cell.backgroundView?.backgroundColor = .clear
        cell.daysLabel.text = "Day \(indexPath.row+1) Picture"
       
        cell.daysLabel.isHidden = false
        let imgUrl = "\(SESSIONS["Result"][indexPath.row]["sessionImage"])"
        let url = URL(string: IMAGE_BASE_URL+imgUrl)
        cell.toothImage.kf.setImage(with: url)
        
        
        cell.toothImage.clipsToBounds = true
        cell.toothImage.layer.cornerRadius = 20
        cell.toothImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        return cell
    }
    
  
    
    
    
    
    
    
    
 

}
