//
//  UINavigationController+LC.swift
//  Labour Choice
//
//  Created by Usama on 6/19/17.
//  Copyright © 2017 Usama. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

    func transparentNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
    }

    func setAttributedTitle() {
        let attributes = [NSAttributedString.Key.font: UIFont.appThemeFontWithSize(19.0), NSAttributedString.Key.foregroundColor: UIColor.white] //change size as per your need here.
        self.navigationBar.titleTextAttributes = attributes
    }

    func setupAppThemeNavigationBar() {
        navigationBar.isTranslucent = false
        navigationBar.tintColor = #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1), NSAttributedString.Key.font: UIFont.montserratRegular(20.0)]
        
        navigationBar.layer.masksToBounds = false
        navigationBar.layer.shadowColor = #colorLiteral(red: 0.04789039481, green: 0.04789039481, blue: 0.04789039481, alpha: 0.1277508803)
        navigationBar.layer.shadowOpacity = 0.8
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationBar.layer.shadowRadius = 2
        navigationBar.layer.borderColor = UIColor.clear.cgColor
        navigationBar.setBackgroundImage(UIImage.imageWithColor(color: .clear), for: .default)
        navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
        navigationBar.backgroundColor = .white
        self.modalPresentationStyle = .fullScreen
    }
    
    func setupAppThemeNavigation() {
        self.modalPresentationStyle = .fullScreen
        navigationBar.isTranslucent = false
        navigationBar.tintColor = #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1.0), NSAttributedString.Key.font: UIFont.montserratRegular(20.0)]
        navigationBar.layer.masksToBounds = false
        navigationBar.layer.shadowColor = #colorLiteral(red: 0.04789039481, green: 0.04789039481, blue: 0.04789039481, alpha: 0.1277508803)
        navigationBar.layer.shadowOpacity = 0.8
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationBar.layer.shadowRadius = 2
        navigationBar.layer.borderColor = UIColor.clear.cgColor
        navigationBar.setBackgroundImage(UIImage.imageWithColor(color: .clear), for: .default)
        navigationBar.backgroundColor = .white
        navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
