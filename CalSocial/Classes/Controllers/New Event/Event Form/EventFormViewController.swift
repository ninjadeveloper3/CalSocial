//
//  EventFormViewController.swift
//  CalSocial
//
//  Created by Moiz Amjad on 05/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import GooglePlaces

protocol  EventFormViewControllerDelegate {
    func didEditEvent()
}

class EventFormViewController: UIViewController {
    
    //MARK: - Variables
    
    
    var colorDataSource = [ColorModel]()
    
    var editDataSource = Mapper<EventDetailsModel>().map(JSON: [:])!
    
    var userContactDataSource = Mapper<BizeeUserModel>().map(JSON: [:])!
    
    var memberDatasource = [EventMember]()
    
    var duplicateMembersDatasource =  [EventMember]()
    
    var dataSource = [EventData]()
    
    var settingsDatasource = Mapper<Settings>().map(JSON: [:])!
    
    var pickerController = UIImagePickerController()
    
    var imageHolder = [UIImage]()
    
    var selectedDate = ""
    
    var userId = 0
    
    var guestIds = [Int]()
    
    var selectedStartTime = ""
    
    var selectedEndTime = ""
    
    var dateObject = Date()
    
    var stringDate = ""
    
    var stringStartTime = ""
    
    var stringEndTime = ""
    
    var isScoreUpdate = false
    
    var backgroundColor = ""
    
    var score : Float = 0.0
    
    var selectedTime = ""
    
    var titleHolder = ""
    
    var isOneToOneEvent = false
    
    var withNonHive = false
    
    var isLoadData = false
    
    var isEventEdit = false
    
    var titleReload = false
    
    var inMyHive = false
    
    var scoreForNonBizee = true
    
    var eventId = 0
    
    var delegate : EventFormViewControllerDelegate?
    
    var swarmTitle = ""
    
    var isSwarm = false
    
    var emptyEventForm = false
    
    var myFirstName = ""
    
    var myLastName = ""
    
    var myProfilePic = ""
    
    var suggestedScore = [Guests]()
    
    
    
    fileprivate var coverHeightMin: NSLayoutConstraint?
    fileprivate var coverHeightMax: NSLayoutConstraint?
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var guestCollectionView: UICollectionView!
    
    @IBOutlet weak var dateView: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var scoreImageView: UIImageView!
    
    @IBOutlet weak var backgroudImageView: UIImageView!
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    @IBOutlet weak var cameraImage2: UIImageView!
    
    @IBOutlet weak var addCoverLabel: UILabel!
    
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentsTextView: UITextView!{
        didSet{
            commentsTextView.layer.borderColor = #colorLiteral(red: 0.04789039481, green: 0.04789039481, blue: 0.04789039481, alpha: 0)
            commentsTextView.layer.borderWidth = 0
            commentsTextView.layer.cornerRadius = 5.0
            commentsTextView.layer.masksToBounds = true
        }
    }
    
    
    //MARK : - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
        
        bgImageHeightConstraint.constant = 20
        cameraImage2.isHidden = true
        uploadImageView.isHidden = false
        addCoverLabel.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timeTextField.isUserInteractionEnabled = false
        
        if isScoreUpdate {
            isScoreUpdate = false
            formatEvent()
            showScores()
            for (index,score) in suggestedScore.enumerated(){
                for member in self.memberDatasource {
                    if score.guestId != userId {
                        if score.guestId == member.Id {
                            self.memberDatasource[index].score = score.score
                        }
                    } 
                }
            }
            self.guestCollectionView.reloadData()
            
        } else if isEventEdit {
            if titleHolder != "" {
                titleTextField.text = titleHolder
            }
            else{
                titleTextField.text = editDataSource.eventDetails.title
            }
            selectedDate = editDataSource.eventDetails.eventDate
            selectedStartTime = editDataSource.eventDetails.startTime
            selectedEndTime = editDataSource.eventDetails.endTime
            if locationLabel.text == "" ||  locationLabel.text == "Add Location"{
                locationLabel.text = editDataSource.eventDetails.location
            }
            
            if editDataSource.eventDetails.coverPicture != "" {
                cameraImage2.isHidden = false
                uploadImageView.isHidden = true
                addCoverLabel.isHidden = true
                bgImageHeightConstraint.constant = 128
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(editDataSource.eventDetails.coverPicture)") {
                    backgroudImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "loading-placeholder"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            else{
                cameraImage2.isHidden = true
                uploadImageView.isHidden = false
                addCoverLabel.isHidden = false
            }
            
            self.getMembers()
            formatEvent()
            
        } else {
            if titleReload{
                self.getMembers()
            }
            if emptyEventForm {
                self.emptyFormDateTimeSet()
            }
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        self.navigationItem.title = "Event Form"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        self.navigationItem.leftBarButtonItem?.setFontStyle()
        commentsTextView.delegate = self
        guestCollectionView.delegate = self
        guestCollectionView.dataSource = self
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.userId = UserDefaults.standard.object(forKey: kUserId) as! Int
        }
        scoreImageView.image = #imageLiteral(resourceName: "score-gray")
        
        let uploadGesture = UITapGestureRecognizer(target: self, action: #selector(uploadCover(sender:)))
        uploadImageView.addGestureRecognizer(uploadGesture)
        
        let uploadImageGesture = UITapGestureRecognizer(target: self, action: #selector(uploadCover(sender:)))
        cameraImage2.addGestureRecognizer(uploadImageGesture)
        
        
        if let firstName = UserDefaults.standard.object(forKey: kUserFirstName) as? String {
            myFirstName = firstName
        }
        if let lastName = UserDefaults.standard.object(forKey: kUserLastName) as? String {
            myLastName = lastName
        }
        if let profilePic = UserDefaults.standard.object(forKey: kUserProfileImageUrl) as? String {
            myProfilePic = profilePic
        }
        
        memberDatasource.removeAll()
        
        
    }
    
    func emptyFormDateTimeSet(){
        titleTextField.text = myFirstName
        
        //Call settings API for the available social hours
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getAllSettings(){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                
                if let data = Mapper<Settings>().map(JSONObject: result) {
                    self.settingsDatasource = data
                    if self.settingsDatasource.socialHours.count > 0 {
                        self.doGetTimeWithSocialHours()
                    }
                    else{
                        let dateTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                        print(dateTomorrow)
                        
                        let date = Date()
                        let format = DateFormatter()
                        let EndDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                        let StartTime = Calendar.current.date(byAdding: .hour, value: 1, to: date)!
                        let EndTime = Calendar.current.date(byAdding: .hour, value: 2, to: date)!
                        
                        format.dateFormat = "yyyy-MM-dd"
                        let formattedStartDate = format.string(from: EndDate)
                        print("Date-->",formattedStartDate)
                        
                        self.selectedDate = formattedStartDate
                        
                        format.dateFormat = "HH:00:00"
                        let formattedStartTime = format.string(from: StartTime)
                        
                        self.selectedStartTime = formattedStartTime
                        
                        format.dateFormat = "HH:00:00"
                        let formattedEndTime = format.string(from: EndTime)
                        self.selectedEndTime = formattedEndTime
                        
                        self.formatEvent()
                    }
                }
            }
        }
        
        
    }
    
    func doGetTimeWithSocialHours(){
        //        slot 1: 8:00AM to 9:00AM
        //        slot 2: 12:00PM to 1:00PM
        //        slot 3: 4:00PM to 5:00PM
        //        slot 4: 8:00PM to 9:00PM
        let date = Date()
        let format = DateFormatter()
        let dateTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let EndDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        
        var StartTime = Calendar.current.date(byAdding: .hour, value: 1, to: date)!
        var EndTime = Calendar.current.date(byAdding: .hour, value: 2, to: date)!
        
        print(dateTomorrow)
        
        
        if self.settingsDatasource.socialHours[0].slot == 1 {
            
            StartTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: date) ?? Date()
            EndTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: date) ?? Date()
            
        }
        if self.settingsDatasource.socialHours[0].slot == 2 {
            StartTime = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? Date()
            EndTime = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: date) ?? Date()
            
        }
        if self.settingsDatasource.socialHours[0].slot == 3 {
            StartTime = Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: date) ?? Date()
            EndTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: date) ?? Date()
            
        }
        if self.settingsDatasource.socialHours[0].slot == 4 {
            StartTime = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: date) ?? Date()
            EndTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: date) ?? Date()
            
        }
        
        
        format.dateFormat = "yyyy-MM-dd"
        let formattedStartDate = format.string(from: EndDate)
        print("Date-->",formattedStartDate)
        
        self.selectedDate = formattedStartDate
        
        format.dateFormat = "HH:00:00"
        let formattedStartTime = format.string(from: StartTime)
        
        self.selectedStartTime = formattedStartTime
        
        format.dateFormat = "HH:00:00"
        let formattedEndTime = format.string(from: EndTime)
        self.selectedEndTime = formattedEndTime
        
        self.formatEvent()
    }
    
    @objc func uploadCover(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController.init(title: "Select your preferred image source",message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action) in
            self.pickerController.delegate = self
            self.pickerController.allowsEditing = false
            self.pickerController.sourceType = .camera
            self.present(self.pickerController, animated: true, completion: nil)
            
        }
        
        let gelleryAction = UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default) { (action) in
            self.pickerController.delegate = self
            self.pickerController.allowsEditing = false
            self.pickerController.sourceType = .photoLibrary
            self.present(self.pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(gelleryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func startTimeTapped(sender: UITapGestureRecognizer){
        //        let dateTimeViewController = DateTimeViewController()
        //        dateTimeViewController.eventSchedual = .StartTime
        //        dateTimeViewController.delegate = self
        //        self.navigationController?.pushViewController(dateTimeViewController, animated: true)
    }
    
    @objc func endTimeTapped(sender: UITapGestureRecognizer){
        //        let dateTimeViewController = DateTimeViewController()
        //        dateTimeViewController.eventSchedual = .EndTime
        //        dateTimeViewController.delegate = self
        //        self.navigationController?.pushViewController(dateTimeViewController, animated: true)
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func dateViewTapped(_ sender: Any) {
        
        
        if selectedDate == "" {
            let date = Date()
            let format = DateFormatter()
            let EndTime = Calendar.current.date(byAdding: .hour, value: 1, to: date)!
            
            
            format.dateFormat = "yyyy-MM-dd"
            let formattedStartDate = format.string(from: date)
            
            selectedDate = formattedStartDate
            
            
            
            format.dateFormat = "HH:00:00"
            let formattedStartTime = format.string(from: date)
            
            selectedStartTime = formattedStartTime
            
            format.dateFormat = "HH:00:00"
            let formattedEndTime = format.string(from: EndTime)
            
            selectedEndTime = formattedEndTime
        }
        
        
        let dateTimeViewController = DateTimeViewController()
        titleReload = false
        emptyEventForm = false
        dateTimeViewController.eventSchedual = .Date
        dateTimeViewController.isEditEvent = selectedDate != "" ? true : false
        dateTimeViewController.selectedDate = selectedDate
        dateTimeViewController.selectedStartTime = selectedStartTime
        dateTimeViewController.selectedEndTime = selectedEndTime
        dateTimeViewController.userContactDataSource = self.userContactDataSource
        dateTimeViewController.memberDatasource = self.memberDatasource
        dateTimeViewController.inMyHive = self.inMyHive
        self.navigationController?.pushViewController(dateTimeViewController, animated: true)
        
    }
    
    @IBAction func timeViewTapped(_ sender: Any) {
        let dateTimeViewController = DateTimeViewController()
        titleReload = false
        dateTimeViewController.eventSchedual = .Date
        dateTimeViewController.isEditEvent = selectedDate != "" ? true : false
        dateTimeViewController.selectedDate = selectedDate
        dateTimeViewController.selectedStartTime = selectedStartTime
        dateTimeViewController.selectedEndTime = selectedEndTime
        dateTimeViewController.userContactDataSource = self.userContactDataSource
        dateTimeViewController.memberDatasource = self.memberDatasource
        dateTimeViewController.inMyHive = self.inMyHive
        self.navigationController?.pushViewController(dateTimeViewController, animated: true)
        
        
    }
    
    
    @IBAction func confrimSendButtonTapped(_ sender: Any) {
        
        if isEventEdit {
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.editEvent(eventId: eventId, date: "\(stringDate)", startTime: selectedStartTime, endTime: selectedEndTime, title: titleTextField.text!, location: locationLabel.text!, hostNotes: commentsTextView.text!, userModel: userContactDataSource, backgroudColor: backgroundColor) { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self)
                    
                } else {
                    
                    if self.imageHolder.count > 0 {
                        self.doUploadEventCover(eventId: self.editDataSource.eventDetails.id)
                    }
                    else{
                        
                        NotificationCenter.default.post(name: Notification.Name("NewEventCreated"), object: nil, userInfo: nil)
                        
                        let newEventViewController = EventOwnerViewController()
                        newEventViewController.id = self.eventId
                        newEventViewController.eventTitle =  self.titleTextField.text!
                        newEventViewController.isEventEdit = true
                        self.navigationController?.pushViewController(newEventViewController, animated: true)
                    }
                    
                }
            }
            
        } else {
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.createEvent(date: "\(stringDate)", startTime: selectedStartTime, endTime: selectedEndTime, title: titleTextField.text!, location: locationLabel.text!, hostNotes: commentsTextView.text!, userModel: userContactDataSource, backgroudColor: backgroundColor) { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self)
                    
                } else {
                    if let id = result?["id"] as? Int {
                        
                        if self.imageHolder.count > 0 {
                            self.doUploadEventCover(eventId: id)
                        }
                        else{
                            
                            NotificationCenter.default.post(name: Notification.Name("NewEventCreated"), object: nil, userInfo: nil)
                            
                            let _ = Utility.addEventInCal(viewController: EventOwnerViewController(), eventTitle: self.titleTextField.text ?? "", date: self.stringDate, startTime: self.selectedStartTime, endTime: self.selectedEndTime)
                            let newEventViewController = EventOwnerViewController()
                            newEventViewController.isEventCreated = true
                            newEventViewController.id = id
                            newEventViewController.eventTitle = self.titleTextField.text!
                            self.navigationController?.pushViewController(newEventViewController, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func doUploadEventCover(eventId: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.uploadEventCoverImage(image: self.imageHolder[0],eventId: eventId) { (success, response) in
            Utility.hideLoading(viewController: self)
            if success {
                let newEventViewController = EventOwnerViewController()
                newEventViewController.id = eventId
                newEventViewController.eventTitle =  self.titleTextField.text!
                self.navigationController?.pushViewController(newEventViewController, animated: true)
            }
        }
    }
    
    @IBAction func addLocationButtonTapped(_ sender: Any) {
        titleReload = false
        //        isEventEdit = false
        titleHolder = self.titleTextField.text ?? ""
        emptyEventForm = false
        let autoCompleteViewController = GMSAutocompleteViewController()
        autoCompleteViewController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "USA"
        autoCompleteViewController.autocompleteFilter = filter
        self.present(autoCompleteViewController, animated: true, completion: nil)
    }
    
    
    //MARK: - Private Methods
    
    
    @IBAction func titleEditing(_ sender: Any) {
        titleTextField.becomeFirstResponder()
        //        titleTextField.selectedTextRange = titleTextField.textRange(from: titleTextField.beginningOfDocument, to: titleTextField.endOfDocument)
        titleTextField.selectAll(nil)
        
    }
    
    func getCoverColors() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getCoverColors { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<ColorModel>().mapArray(JSONObject: result) {
                    self.colorDataSource = data
                    self.colorDataSource[0].isSelected = true
                    self.backgroundColor = self.colorDataSource[0].colorCode
                    self.backgroudImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(self.colorDataSource[0].colorCode, alpha: 1.0)
                    //                    self.coverCollectioView.reloadData()
                }
            }
        }
    }
    
    func formatEvent() {
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = stringDateFormatter.date(from: selectedDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        let modifiedDate = dateFormatter.string(from: date ?? Date())
        dateView.text = modifiedDate
        
        let stringTimeFormatter = DateFormatter()
        stringTimeFormatter.dateFormat = "HH:mm:ss"
        let startTime = stringTimeFormatter.date(from: selectedStartTime)!
        let endTime = stringTimeFormatter.date(from: selectedEndTime)!
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mma"
        let startTimeFormatted = timeFormatter.string(from: startTime)
        let endTimeFormatted = timeFormatter.string(from: endTime)
        timeTextField.text = "\(startTimeFormatted) - \(endTimeFormatted)"
        
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.dateFormat = "yyyy-MM-dd"
        stringDate = apiDateFormatter.string(from: date ?? Date())
    }
    
    func doGetEventData(date: String, startTime: String, endTime: String){
        
        
        if userContactDataSource.phoneContacts.count > 0 {
            for phoneContacts in userContactDataSource.phoneContacts {
                guestIds.append(phoneContacts.id)
            }
        }
        
        if userContactDataSource.hives.count > 0 {
            for hives in userContactDataSource.hives {
                guestIds.append(hives.hiveMember.id)
            }
        }
        
        if userContactDataSource.swarms.count > 0 {
            for swarm in self.memberDatasource{
                print("id",swarm.Id)
                guestIds.append(swarm.Id)
            }
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getEventData(hostId: self.userId, guestIds: guestIds, eventDate: date, startTime: startTime, endTime: endTime) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<EventData>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    
                    if !self.isEventEdit {
                        let stringDateFormatter = DateFormatter()
                        stringDateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = stringDateFormatter.date(from: self.dataSource[0].eventDate)
                        self.selectedDate = self.dataSource[0].eventDate
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEEE, MMMM dd"
                        let modifiedDate = dateFormatter.string(from: date ?? Date())
                        self.dateView.text = modifiedDate
                        
                        
                        let stringTimeFormatter = DateFormatter()
                        stringTimeFormatter.dateFormat = "HH:00:00"
                        let startTime = stringTimeFormatter.date(from: self.dataSource[0].startTime)
                        let endTime = stringTimeFormatter.date(from: self.dataSource[0].endTime)
                        
                        
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "hh:00 a"
                        let startTimeFormatted = timeFormatter.string(from: startTime ?? Date())
                        
                        
                        let EndTime = Calendar.current.date(byAdding: .hour, value: 1, to: endTime ?? Date())
                        let endTimeFormatted = timeFormatter.string(from: EndTime ?? Date())
                        
                        self.timeTextField.text = "\(startTimeFormatted) - \(endTimeFormatted)"
                        
                        let format = DateFormatter()
                        
                        format.dateFormat = "HH:00:00"
                        
                        
                        let CformattedStartTime = format.date(from: self.dataSource[0].startTime)
                        let formattedStartTime = format.string(from: CformattedStartTime ?? Date())
                        self.selectedStartTime = formattedStartTime
                        
                        let EformattedStartTime = format.date(from: self.dataSource[0].endTime)
                        var AgoEndTime = Calendar.current.date(byAdding: .hour, value: 1, to: EformattedStartTime ?? Date())!
                        let formattedEndTime = format.string(from: AgoEndTime ?? Date())
                        
                        
                        self.selectedEndTime = formattedEndTime
                        
                        let apiDateFormatter = DateFormatter()
                        apiDateFormatter.dateFormat = "yyyy-MM-dd"
                        self.stringDate = apiDateFormatter.string(from: date ?? Date())
                    }
                    
                    self.score = self.dataSource[0].score
                    for (index,score) in self.dataSource[0].guests.enumerated(){
                        for (index,member) in self.memberDatasource.enumerated() {
                            if member.Id == score.guestId{
                                self.memberDatasource[index].score = score.score
                            }
                        }
                    }
                    
                    self.guestCollectionView.reloadData()
                    self.showScores()
                    
                }
            }
        }
    }
    
    func showScores() {
        if !scoreForNonBizee {
            scoreImageView.image = #imageLiteral(resourceName: "score-gray")
            scoreLabel.isHidden = true
            
        }
        else{
            scoreImageView.image = #imageLiteral(resourceName: "score")
            scoreLabel.isHidden = false
            scoreLabel.text = "\(Int(score*100))%"
        }
        
    }
    
    func setTitle(){
        //        titleTextField.text = ""
        
        if isSwarm {
            titleTextField.text = myFirstName
            titleTextField.text?.append(" & "+swarmTitle)
            return
        }
        
        if memberDatasource.count > 0 {
            titleTextField.text = myFirstName
            for (index,title) in memberDatasource.enumerated() {
                if index == 0 {
                    titleTextField.text?.append(" & "+title.firstName)
                }
                else{
                    titleTextField.text?.append(", "+title.firstName)
                }
            }
        }
        else{
            if userContactDataSource.phoneContacts.count > 0 {
                for (index,title) in userContactDataSource.phoneContacts.enumerated() {
                    if index == 0 {
                        
                        titleTextField.text?.append(" & "+title.name)
                    }
                    else{
                        titleTextField.text?.append(", "+title.name)
                    }
                }
            }
        }
        
        
        titleReload = false
    }
    
    func getMembers() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMembers(userModel: userContactDataSource) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                
                if (self.userContactDataSource.hives.count == 0 && self.userContactDataSource.swarms.count == 0) && self.userContactDataSource.phoneContacts.count > 0 {
                    if self.titleReload {
                        self.setTitle()
                    }
                }
                if let data = Mapper<EventMember>().mapArray(JSONObject: result) {
                    self.memberDatasource = data.removingDuplicates(byKey: { $0.Id })
                    //                    self.memberDatasource = self.memberDatasource.filter{ $0.Id != self.userId }
                    self.memberDatasource = self.memberDatasource.filter { $0.Id != self.userId }
                    
                    if self.titleReload{
                        self.setTitle()
                        self.isOneToOneEvent = true
                    }
                    if self.isOneToOneEvent || (self.isEventEdit && (self.userContactDataSource.hives.count > 0 || self.userContactDataSource.swarms.count > 0) || (self.userContactDataSource.hives.count > 0 || self.userContactDataSource.swarms.count > 0)) {
                        let date = Date()
                        let format = DateFormatter()
                        let EndTime = Calendar.current.date(byAdding: .hour, value: 1, to: date)!
                        format.dateFormat = "yyyy-MM-dd"
                        let formattedStartDate = format.string(from: date)
                        format.dateFormat = "HH:mm:ss"
                        let formattedStartTime = format.string(from: date)
                        format.dateFormat = "HH:mm:ss"
                        let formattedEndTime = format.string(from: EndTime)
                        
                        if !self.withNonHive{
                            self.doGetEventData(date: formattedStartDate, startTime: formattedStartTime, endTime: formattedEndTime)
                        }
                        else{
                            self.emptyFormDateTimeSet()
                        }
                        
                    }
                    self.guestCollectionView.reloadData()
                }
            }
        }
    }
}

extension EventFormViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == guestCollectionView {
            return (memberDatasource.count + 2)
            
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == guestCollectionView {
            if indexPath.row == 0 {
                let addGuestCell = addGuestFormCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
                return addGuestCell
            }
            if indexPath.row == 1 {
                let guestCell = GuestCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
                //                if indexPath.row <= self.memberDatasource.count {
                //                    guestCell.noSyncLabel.isHidden = false
                //                    guestCell.noSyncLabel.text = "Host"
                //                    guestCell.progressBarView.isHidden = true
                //                    guestCell.nameLabel.text = "You"
                //                    guestCell.initData(profilePic: memberDatasource[indexPath.row-1].profilePicture, fname: memberDatasource[indexPath.row - 1].firstName,lname: memberDatasource[indexPath.row - 1].lastName, color: memberDatasource[indexPath.row - 1].color)
                //                }
                guestCell.noSyncLabel.isHidden = false
                guestCell.noSyncLabel.text = "Host"
                guestCell.progressBarView.isHidden = true
                guestCell.statusDot.isHidden = true
                guestCell.nameLabel.text = self.myFirstName
                
                guestCell.initData(profilePic: self.myProfilePic, fname: myFirstName,lname: myLastName, color: "")
                return guestCell
            }
            
            let guestCell = GuestCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            
            if memberDatasource[indexPath.row - 2].isBizee == 0 {
                guestCell.noSyncLabel.isHidden = false
                guestCell.noSyncLabel.text = "SMS"
                guestCell.progressBarView.isHidden = true
                guestCell.statusDot.isHidden = true
                guestCell.nameLabel.text = memberDatasource[indexPath.row - 2].firstName
                guestCell.emptyViewLabel.text = memberDatasource[indexPath.row - 2].firstName.getFirstChar()+memberDatasource[indexPath.row - 2].lastName.getFirstChar()
            }
            else{
                
                if withNonHive {
                    guestCell.noSyncLabel.isHidden = false
                    guestCell.noSyncLabel.text = "No Sync"
                    guestCell.progressBarView.isHidden = true
                    guestCell.statusDot.isHidden = true
                    guestCell.nameLabel.text = memberDatasource[indexPath.row - 2].firstName
                    guestCell.emptyViewLabel.text = memberDatasource[indexPath.row - 2].firstName.getFirstChar()+memberDatasource[indexPath.row - 2].lastName.getFirstChar()
                }
                else{
                    guestCell.noSyncLabel.isHidden = true
                    guestCell.progressBarView.isHidden = false
                    guestCell.statusDot.isHidden = true
                    guestCell.progressBarView.progress = CGFloat(memberDatasource[indexPath.row - 2].score)
                    guestCell.nameLabel.text = memberDatasource[indexPath.row - 2].firstName
                    guestCell.initData(profilePic: memberDatasource[indexPath.row-2].profilePicture, fname: memberDatasource[indexPath.row - 2].firstName,lname: memberDatasource[indexPath.row - 2].lastName, color: memberDatasource[indexPath.row - 2].color)
                }
            }
            return guestCell
            
        } else {
            let coverCell = CoverCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            coverCell.colorBackView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(colorDataSource[indexPath.item].colorCode, alpha: 1.0)
            coverCell.checkMark.isHidden = !colorDataSource[indexPath.item].isSelected
            return coverCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == guestCollectionView {
            return CGSize(width: 76 , height: 104)
            
        } else {
            if colorDataSource[indexPath.item].isSelected {
                return CGSize(width: 56 , height: 40)
            }
            return CGSize(width: 56 , height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == guestCollectionView {
            if indexPath.item == 0 {
                let addguestViewController = addGuestViewController()
                addguestViewController.isNewEvent = true
                addguestViewController.delegate = self
                addguestViewController.selectedUserContacts = self.userContactDataSource
                self.navigationController?.pushViewController(addguestViewController, animated: true)
            }
            if indexPath.item == 1 {
                let profileViewController  = MyProfileViewController()
                let profileNavigationController = UINavigationController()
                profileNavigationController.setupAppThemeNavigationBar()
                profileNavigationController.viewControllers = [profileViewController]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.present(profileNavigationController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension EventFormViewController: DateTimeViewControllerDelegate {
    
    func schedualValues(value: String, component: EventSchedule, date: Date, time: String) {
        print(component)
        if component == .Date {
            self.dateObject = date
            dateView.text = value
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            let date = dateFormatterPrint.string(from: date)
            
            self.selectedDate = date
        }
        if component == .StartTime {
            selectedTime = value
            stringStartTime = value
            selectedStartTime = time
        }
        if component == .EndTime {
            selectedTime = "\(selectedTime) - \(value)"
            stringEndTime = value
            selectedEndTime = time
        }
    }
    
    func didTapSuggestion() {
        
    }
}

extension EventFormViewController: addGuestViewControllerDelegate {
    func didAddContacts(contacts: [HiveModel]) {
        
    }
    
    func didAddUserContacts(userContacts: BizeeUserModel) {
        titleTextField.text = ""
        self.memberDatasource.removeAll()
        self.titleReload = true
        self.userContactDataSource = userContacts
        self.guestCollectionView.reloadData()
    }
}

extension EventFormViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationLabel.text = ""
        locationLabel.text = place.formattedAddress
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EventFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("image data")
            
            bgImageHeightConstraint.constant = 128
            cameraImage2.isHidden = false
            uploadImageView.isHidden = true
            addCoverLabel.isHidden = true
            
            
            backgroudImageView.image = image
            self.imageHolder = [image]
            
            editDataSource.eventDetails.coverPicture = ""
            pickerController.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker canceled")
        pickerController.dismiss(animated: true, completion: nil)
    }
}

extension EventFormViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}


