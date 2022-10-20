//
//  UIViewController+LC.swift
//  Labour Choice
//
//  Created by Usama on 21/06/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func addCustomBackButton(isFindLabour: Bool = false) {
//        let backButton: UIButton = UIButton (type: UIButton.ButtonType.custom)
//        backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: UIControl.State.normal)
//
//        if isFindLabour {
//            backButton.addTarget(self, action: #selector(self.backButtonTapped(button:)), for: UIControl.Event.touchUpInside)
//
//        } else {
//            backButton.addTarget(self, action: #selector(self.backButtonPressed(button:)), for: UIControl.Event.touchUpInside)
//        }
//
//        backButton.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
//        let barButton = UIBarButtonItem(customView: backButton)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButton(sender:)))
    }

    func addCustomCrossButton() {
        let crossButton: UIButton = UIButton (type: UIButton.ButtonType.custom)
        crossButton.setImage(UIImage(named: "cancel"), for: UIControl.State.normal)

        crossButton.addTarget(self, action: #selector(self.barCancelButtonTapped(button:)), for: UIControl.Event.touchUpInside)

        crossButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: crossButton)

        navigationItem.rightBarButtonItem = barButton
    }

    @objc func backButtonPressed(button : UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func backButton(sender : UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    

    @objc func barCancelButtonTapped(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func backButtonTapped(button: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationChangeBarButton), object: nil)
        navigationController?.popViewController(animated: true)
    }

}
