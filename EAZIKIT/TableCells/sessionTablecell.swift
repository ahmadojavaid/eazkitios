//
//  sessionTablecell.swift
//  EAZIKIT
//
//  Created by APPLE on 12/17/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import UIKit
protocol sessionTablecellDelegate{
    func closeFriendsTapped(at index:IndexPath)
}

class sessionTablecell: UITableViewCell {

    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sessionImage: UIImageView!
    @IBOutlet weak var timeCarriedOut: UILabel!
    @IBOutlet weak var actualTimeCarrid: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!
    @IBOutlet weak var counterLabelBackground: UIView!
    
    @IBOutlet weak var small_images: UIImageView!
    var delegate:sessionTablecellDelegate!
    var indexPath:IndexPath!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var rateNowView: UIView!
    
    @IBOutlet weak var rateNoeBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var ratingView: UIView!
    @IBAction func shareBtnPrssed(_ sender: Any)
    {
        self.delegate?.closeFriendsTapped(at: indexPath)
    }
}
