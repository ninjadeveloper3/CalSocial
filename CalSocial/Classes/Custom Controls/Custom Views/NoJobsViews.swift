//
//  NoJobsViews.swift
//  Labour Choice
//
//  Created by Usama on 07/07/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import UIKit

class NoJobsViews: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var bannerLabel: UILabel!
    @IBOutlet var bannerView: UIView!
    
    class func instanceFromNib() -> NoJobsViews {
        return UINib(nibName: "NoJobsViews", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoJobsViews
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
