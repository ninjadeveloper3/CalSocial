//
//  UIFont+LC.swift
//  Labour Choice
//
//  Created by Usama on 19/06/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    class func appThemeFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "Mark Pro", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

    class func appThemeBoldFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "MarkPro-Bold", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }
    
    class func appThemeFont(_ fontSize: CGFloat) -> UIFont {
        
        if let font = UIFont(name: "Avenir-Bool", size: fontSize) {
            return font
        }
        
        return UIFont.systemFont(ofSize: fontSize)
    }

    class func appThemeSemiBoldFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "MarkPro-Book", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

    class func sevenSegmentFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "Mark Pro Semi Bold", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }
    
    class func  montserratMedium(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "Montserrat-Medium", size: fontSize) {
            return font
        }
        
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    class func  montserratRegular(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "Montserrat-Regular", size: fontSize) {
            return font
        }
        
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    class func  muliBold(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "Muli-Bold", size: fontSize) {
            return font
        }
        
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    class func  muliRegular(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "Muli-Regular", size: fontSize) {
            return font
        }
        
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    
//    Muli-SemiBold
    
    class func  montserratSemiBold(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "Montserrat-SemiBold", size: fontSize) {
            return font
        }
        
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    class func  montserratBold(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "Montserrat-Bold", size: fontSize) {
            return font
        }
        
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
}
