//
//  SwarmEmptyView.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol SwarmEmptyViewDelegate {
    func didFinishTask()
}

class SwarmEmptyView: UIView {

    //MARK: - IBOutlets
    
    @IBOutlet weak var swarmLabel: UILabel! {
        didSet {
            swarmLabel.font = UIFont.muliRegular(16.0)
        }
    }
    
    @IBOutlet weak var createSwarmButton: MBButton! {
        didSet {
            createSwarmButton.titleLabel?.font = UIFont.montserratBold(16.0)
        }
    }


    var delegate : SwarmEmptyViewDelegate?

    //MARK: - IBAction Methods
    
    @IBAction func newSwarmTapped(_ sender: Any) {
        
        delegate?.didFinishTask()
    }
    
    class func instanceFromNib() -> SwarmEmptyView {
        return UINib(nibName: "SwarmEmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SwarmEmptyView
    }
}
