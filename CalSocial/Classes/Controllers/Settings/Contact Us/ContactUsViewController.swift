//
//  ContactUsViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 08/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    //MARK: - Variables
    
    //MARK: - IBOutlets

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViewController()

    }
    
    //MARK: - UIViewController Methods
    
    func setUpViewController() {
        
        self.title = "Contact Us"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reportProblem(_ sender: Any) {
        if let url = URL(string: "mailto:cynthiaahr@gmail.com") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    @IBAction func sourceLib(_ sender: Any) {
        
    }
    
}
