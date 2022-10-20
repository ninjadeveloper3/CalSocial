//
//  RemoveConfirmViewController.swift
//  CalSocial
//
//  Created by Moiz Amjad on 06/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
protocol confirmPopUpSelectionDelegate {
    func didSelectOption(selection: Bool)
}

class RemoveConfirmViewController: UIViewController {
    
    //MARK: - Variables
    
    var delegate : confirmPopUpSelectionDelegate?
    
    var removal : AlertRemove = .RemoveHive
    
    var ignorEvent = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var confirmNo: MBButton!
    
    @IBOutlet weak var confirmYes: MBButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if removal == .LeaveSwarm {
            alertLabel.text = "Are you sure you want to leave this swarm?"
            
        } else if removal == .DeleteSwarm {
            alertLabel.text = "Are you sure you want to delete this swarm?"
            
        }
        else if removal == .CancelEvent {
            alertLabel.text = "Are you sure you want to cancel this event?"
            
        }
        else if ignorEvent {
            alertLabel.text = "Are you sure you want to ignore this event? It will not be recovered later."
            
        }else {
            alertLabel.text = "Are you sure you want to remove this contact from your hive?"
        }
    }

    //MARK: - IBActions
    
    @IBAction func confirmNoTapped(_ sender: Any) {
        delegate?.didSelectOption(selection: false)
    }
    
    @IBAction func confirmYesTapped(_ sender: Any) {
        delegate?.didSelectOption(selection: true)
    }
    
    
}
