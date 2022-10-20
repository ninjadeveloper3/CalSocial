//
//  HiveEmptyView.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class HiveEmptyView: UIView {

    
    class func instanceFromNib() -> HiveEmptyView {
        return UINib(nibName: "HiveEmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HiveEmptyView
    }
}
