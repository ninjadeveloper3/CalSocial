//
//  NewEventViewController.swift
//  CalSocial
//
//  Created by DevBatch on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import JMMarkSlider

class NewEventViewController: UIViewController {

    //MARK: - Variables
    
    let datePicker = UIDatePicker()
    
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var slider: JMMarkSlider!{
        didSet{
            slider.selectedBarColor = #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
            slider.unselectedBarColor = .lightGray
        }
    }
    
    @IBOutlet weak var eventTitleTextField: BUITextField!{
        didSet {
            eventTitleTextField.setupPadding()
        }
    }
    
    @IBOutlet weak var dateTextField: BUITextField!{
        didSet {
            dateTextField.setupPadding()
        }
    }
    
    @IBOutlet weak var locationTextField: BUITextField!{
        didSet {
            locationTextField.setupPadding()
        }
    }
    
    @IBOutlet weak var notesTextView: UITextView!{
        didSet {
            notesTextView.placeholder = "Any additional comments ..."
            notesTextView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            notesTextView.layer.borderWidth = 1
            notesTextView.layer.cornerRadius = 5.0
            notesTextView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var guestCollectionView: UICollectionView!
    
    @IBOutlet weak var coverCollectionView: UICollectionView!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        self.navigationItem.title = "New Event"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(sender:)) )
        
        let currentDate = Date()
        let oneDay = 24 * 60 * 60
        let oneYear = oneDay * 365
        let maxDate = currentDate.addingTimeInterval(TimeInterval(-18 * oneYear)) // before 18 Years
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        //datePicker.maximumDate = maxDate // prevent furture date
        dateTextField.inputView = datePicker
    }
    
    //MARK: - Private Methods
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day,.weekday,.hour,.minute], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            dateTextField.text = "\(day)-\(month)-\(year)"
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(addGuestViewController(), animated: true)
    }
}

extension NewEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == guestCollectionView {
            if indexPath.row == 0 {
                let addGuestCell = addGuestCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
                return addGuestCell
            }
            let guestCell = GuestCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            return guestCell
            
        } else {
            let coverCell = CoverCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            return coverCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == guestCollectionView {
            return CGSize(width: 76 , height: 104)
        }
        
        return CGSize(width: 56 , height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            let addguestViewController = addGuestViewController()
            addguestViewController.isNewEvent = true
//            addguestViewController.delegate = self
            self.navigationController?.pushViewController(addguestViewController, animated: true)
        }
    }
}
