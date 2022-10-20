//
//  CurvedTabBarController.swift
//  CalSocial
//
//  Created by DevBatch on 27/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import UIKit

open class CurvedTabBarController : UITabBarController {
    
    
    let customTabBar = CustomizedTabBar()
    override open func loadView() {
        super.loadView()
        let tabBar = { () -> CustomizedTabBar in
            
            let tabBar = CustomizedTabBar()
            tabBar.isUserInteractionEnabled = true
            return tabBar
        }()
        
        self.setValue(tabBar, forKey: "tabBar")
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        
//    }
//    

}
