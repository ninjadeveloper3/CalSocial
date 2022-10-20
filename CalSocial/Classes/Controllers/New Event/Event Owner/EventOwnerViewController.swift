//
//  EventOwnerViewController.swift
//  CalSocial
//
//  Created by DevBatch on 04/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class EventOwnerViewController: UIViewController {
    
    //MARK: - Variables
    
    let headerCell = EventHeaderTableViewCell.instanceFromNib()
    
    var dataSource = Mapper<EventDetailsModel>().map(JSON: [:])!
    
    var isLoadData = false
    
    var id = 0
    
    var userId = 0
    
    var myUserId = 0
    
    var isOwner = false
    
    var isEventCreated = false
    
    var eventTitle = "Event Title"
    
    var isEventInvite = false
    
    var isCommentAdded = false
    
    var ignorEvent = false
    
    var isEventEdit = false
    
    var pickerController = UIImagePickerController()
    
    var image = UIImage()
    
    var isImageAddedInComment = false
    
    @IBOutlet weak var commentImageView: UIImageView!
    
    @IBOutlet weak var hiddeImageView: UIView!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var messageTextView: UITextView! {
        didSet {
            //messageTextView.placeholder = "Type Message"
            messageTextView.layer.borderColor = #colorLiteral(red: 0.9214683175, green: 0.9216262698, blue: 0.9214583635, alpha: 1)
            messageTextView.layer.borderWidth = 1.0
            messageTextView.layer.cornerRadius = 7.0
            messageTextView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var messageStack: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        self.navigationItem.title = eventTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "create-message-1"), style: .plain, target: self, action: #selector(addButtonTapped(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        tableView.separatorStyle = .none
        
        getEventDetail()
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.myUserId = UserDefaults.standard.object(forKey: kUserId) as! Int
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mainDelegate = self
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func addCommentButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        if isImageAddedInComment {
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.addCommentWithImage(image: self.image, eventId: id, userId: userId, comment: messageTextView.text) { (success, response) in
                Utility.hideLoading(viewController: self)
                if success {
                    self.isCommentAdded = true
                    self.getEventDetail()
                }
            }
            
        } else {
            if (messageTextView.text.trimmingCharacters(in: .whitespaces)) != "" {
                Utility.showLoading(viewController: self)
                APIClient.sharedClient.addComments(eventId: id, userId: userId, comment: messageTextView.text) { (response, result, error, message) in
                    Utility.hideLoading(viewController: self)
                    if error != nil {
                        error?.showErrorBelowNavigation(viewController: self)
                        
                    } else {
                        self.isCommentAdded = true
                        self.getEventDetail()
                    }
                }
            }
        }
    }
    
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        
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
    
    
    //MARK: - Private Methods
    
    @objc func addButtonTapped(sender: UIBarButtonItem) {
        
        let alert = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        var addAction = UIAlertAction()
        var blockAction = UIAlertAction()
        
        
        
        addAction = UIAlertAction(title: "Edit Event", style: UIAlertAction.Style.default) { (action) in
            self.dismiss(animated: true, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let visibleViewController = Utility.getVisibleViewController(appDelegate.window?.rootViewController)
                let userDatasource = Mapper<BizeeUserModel>().map(JSON: [:])!
                
                for member in self.dataSource.eventDetails.eventMembers {
                    if member.isBizee {
                        let members = Mapper<HiveModel>().map(JSON: [:])!
                        members.hiveMember.id = member.userId
                        if member.role != 1 {
                            userDatasource.hives.append(members)
                        }
                        
                    } else {
                        let phoneMember = Mapper<PhoneContacts>().map(JSON: [:])!
                        phoneMember.id = member.userId
                        phoneMember.name = "\(member.firstName) \(member.lastName)"
                        userDatasource.phoneContacts.append(phoneMember)
                    }
                }
                let newEventViewController = EventFormViewController()
                let newEventNavigationController = UINavigationController()
                newEventNavigationController.setupAppThemeNavigationBar()
                newEventViewController.userContactDataSource = userDatasource
                newEventViewController.eventId = self.id
                newEventViewController.delegate = self
                newEventViewController.isEventEdit = true
                newEventViewController.editDataSource = self.dataSource
                newEventNavigationController.viewControllers = [newEventViewController]
                visibleViewController?.present(newEventNavigationController, animated: true, completion: nil)
            })
        }
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.userId = UserDefaults.standard.object(forKey: kUserId) as! Int
            if self.userId == self.dataSource.eventDetails.userId {
                blockAction = UIAlertAction(title: "Cancel Event", style: UIAlertAction.Style.destructive) {
                    (action) in
                    
                    let popUp = RemoveConfirmViewController()
                    popUp.removal = .CancelEvent
                    
                    popUp.modalPresentationStyle = .overCurrentContext
                    popUp.delegate = self
                    self.present(popUp, animated: true, completion: nil)
                }
            }
            else{
                blockAction = UIAlertAction(title: "Leave Event", style: UIAlertAction.Style.destructive) {
                    (action) in
                    
                    Utility.showLoading(viewController: self)
                    APIClient.sharedClient.leaveEvent(eventId: self.id, { (response, result, error, message) in
                        Utility.hideLoading(viewController: self)
                        if error != nil {
                            error?.showErrorBelowNavigation(viewController: self)
                            
                        } else {
                            self.dismiss(animated: true, completion: {
                                NotificationCenter.default.post(name: Notification.Name("NewEventCreated"), object: nil, userInfo: nil)
                            })
                        }
                    })
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        if self.userId == self.dataSource.eventDetails.userId {
            alert.addAction(addAction)
        }
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            if self.isEventCreated {
                NotificationCenter.default.post(name: Notification.Name("NewEventCreated"), object: nil, userInfo: nil)
            }
        }
    }
    
    func cancelEvent(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.deleteEvent(id: self.id, { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: Notification.Name("NewEventCreated"), object: nil, userInfo: nil)
                })
            }
        })
    }
    
    func deleteComment(eventId: Int, commentId: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.deleteComment(eventId: eventId, commentId: commentId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dataSource.eventDetails.eventComments = self.dataSource.eventDetails.eventComments.filter { $0.id != commentId }
                self.tableView.reloadData()
            }
        }
    }
    
    func getEventDetail(isComment: Bool = false) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getEventDetails(eventId: id) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<EventDetailsModel>().map(JSONObject: result) {
                    self.dataSource = data
                    self.isLoadData = true
                    self.tableView.reloadData()
                    self.eventScreenPopUps()
                    if self.isCommentAdded {
                        self.messageTextView.text = ""
                        self.hiddeImageView.isHidden = true
                        self.isCommentAdded = false
                        self.isImageAddedInComment = false
                        self.tableView.reloadData()
                        if self.dataSource.eventDetails.eventComments.count > 0 && isComment{
                            let index = IndexPath(row: self.dataSource.eventDetails.eventComments.count-1, section: 1)
                            self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func eventScreenPopUps() {
        if isEventCreated {
            isEventCreated = false
            let popUp = EventInviteDialogViewController()
            if self.dataSource.eventDetails.eventMembers.count == 1 {
                //here you can change the titles
                popUp.isOnlyHost = true
            }
            popUp.modalPresentationStyle = .overCurrentContext
            self.present(popUp, animated: true, completion: nil)
        }
        
        if isEventEdit {
            isEventEdit = false
            let popUp = EventInviteDialogViewController()
            popUp.eventUpdated = true
            popUp.modalPresentationStyle = .overCurrentContext
            self.present(popUp, animated: true, completion: nil)
        }
        
        //        if dataSource.status == 3 && dataSource.eventDetails.eventMembers.count > 2 {
        //            let popUp = CanMakeItViewController()
        //            popUp.delegate = self
        //            popUp.eventId = id
        //            isEventCreated = false
        //            popUp.modalPresentationStyle = .overCurrentContext
        //            self.present(popUp, animated: true, completion: nil)
        //
        //        } else if dataSource.status == 3 {
        //            let popUp = RecievedInvite2ViewController()
        //            popUp.delegate = self
        //            popUp.eventId = id
        //            isEventCreated = false
        //            popUp.modalPresentationStyle = .overCurrentContext
        //            self.present(popUp, animated: true, completion: nil)
        //        }
    }
    
    func setStatus(status: Int) {
        Utility.isEventStatusChange = true
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.setEventStatus(status: status, eventId: id) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if status == 4 {
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    self.getEventDetail()
                }
            }
        }
    }
}

extension EventOwnerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoadData {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        return self.dataSource.eventDetails.eventComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            headerCell.initData(dataSource: self.dataSource)
            headerCell.delegate = self
            return headerCell
            
        } else {
            if dataSource.eventDetails.eventComments[indexPath.row].image != "" {
                let imageCommentCell = ImageCommentsTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                imageCommentCell.commentLabel.text = dataSource.eventDetails.eventComments[indexPath.row].comment
                imageCommentCell.nameLabel.text = dataSource.eventDetails.eventComments[indexPath.row].userName
                imageCommentCell.timeLabel.text = imageCommentCell.getTimeInFormat(date: dataSource.eventDetails.eventComments[indexPath.row].createdAt)
                if dataSource.eventDetails.eventComments[indexPath.row].profilePic == "" {
                    imageCommentCell.emptyView.isHidden = false
                    imageCommentCell.emptyViewLabel.text = dataSource.eventDetails.eventComments[indexPath.row].firstName.getFirstChar()+dataSource.eventDetails.eventComments[indexPath.row].lastName.getFirstChar()
                    
                } else {
                    imageCommentCell.emptyView.isHidden = true
                    if let url = URL(string: "\(kImageDownloadBaseUrl)\(dataSource.eventDetails.eventComments[indexPath.row].profilePic)") {
                        print("url",url)
                        imageCommentCell.profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                        })
                    }
                }
                if let url = URL(string: "\(kImageDownloadBaseUrl)users/\(dataSource.eventDetails.eventComments[indexPath.row].image)") {
                    print("url",url)
                    imageCommentCell.commentImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
                return imageCommentCell
            }
            
            let commentsCell = CommentTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            commentsCell.commentTextLabel.text = dataSource.eventDetails.eventComments[indexPath.row].comment
            commentsCell.nameLabel.text = dataSource.eventDetails.eventComments[indexPath.row].userName
            commentsCell.timeLabel.text = commentsCell.getTimeInFormat(date: dataSource.eventDetails.eventComments[indexPath.row].createdAt)
            
            if dataSource.unreadDot == 0 {
                headerCell.unreadCommentDot.isHidden = true
            }
            else{
                headerCell.unreadCommentDot.isHidden = false
            }
            
//            if dataSource.eventDetails.eventComments.count == 0 { //no comments
//                headerCell.unreadCommentDot.isHidden = true
//            }
//            else{
//                if dataSource.isOwner == 1 { //for host
//                    if dataSource.eventDetails.eventComments[indexPath.row].userId != self.myUserId { //my comment and i'm the host
//                        if dataSource.eventDetails.isUnreadComment == 0 {
//                            headerCell.unreadCommentDot.isHidden = false
//                        }
//                        else{
//                            headerCell.unreadCommentDot.isHidden = true
//                        }
//                    }
//                    else{
//                        headerCell.unreadCommentDot.isHidden = true
//                    }
//                }
//                else{
//                    if dataSource.eventDetails.isUnreadComment == 0 {
//                        headerCell.unreadCommentDot.isHidden = false
//                    }
//                    else{
//                        headerCell.unreadCommentDot.isHidden = true
//                    }
//                }
//            }
            if dataSource.eventDetails.eventComments[indexPath.row].profilePic == "" {
                commentsCell.emptyView.isHidden = false
                commentsCell.emptyViewLabel.text = dataSource.eventDetails.eventComments[indexPath.row].firstName.getFirstChar()+dataSource.eventDetails.eventComments[indexPath.row].lastName.getFirstChar()
                commentsCell.emptyView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(dataSource.eventDetails.eventComments[indexPath.row].color, alpha: 1.0)
                
            } else {
                commentsCell.emptyView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(dataSource.eventDetails.eventComments[indexPath.row].profilePic)"){
                    print("url",url)
                    commentsCell.profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            return commentsCell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 0 {
            return UISwipeActionsConfiguration()
            
        } else {
            let deleteAction =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
                completionHandler(true)
                if Utility.isKeyPresentInUserDefaults(key: kUserId){
                    
                    if self.dataSource.eventDetails.eventComments[indexPath.row].isOwner == 1 {
                        self.deleteComment(eventId: self.id, commentId: self.dataSource.eventDetails.eventComments[indexPath.row].id)
                    }
                    else{
                        if let id = UserDefaults.standard.object(forKey: kUserId) as? Int {
                            if id == (self.dataSource.eventDetails.eventComments[indexPath.row].userId) {
                                self.deleteComment(eventId: self.id, commentId: self.dataSource.eventDetails.eventComments[indexPath.row].id)
                                
                            } else {
                                print("you cannot delete other's comment")
                            }
                        }
                    }
                }
            })
            deleteAction.image = #imageLiteral(resourceName: "cross-color")
            deleteAction.backgroundColor = #colorLiteral(red: 0.8274844289, green: 0.379353106, blue: 0.209089905, alpha: 1)
            let confrigation = UISwipeActionsConfiguration(actions: [deleteAction])
            if let id = UserDefaults.standard.object(forKey: kUserId) as? Int {
                if self.dataSource.eventDetails.eventComments[indexPath.row].userId == id {
                    return confrigation
                    
                } else {
                    return UISwipeActionsConfiguration()
                }
                
            } else {
                return UISwipeActionsConfiguration()
            }
        }
        
    }
}

extension EventOwnerViewController: CanMakeItViewControllerDelegate, RecievedInvite2ViewControllerDelegate {
    func didTapSuggests() {
        let dateNavigationController = UINavigationController()
        let dateTimeViewController = DateTimeViewController()
        dateTimeViewController.delegate = self
        dateTimeViewController.eventId = self.id
        dateTimeViewController.eventSchedual = .Date
        dateTimeViewController.isSuggestTimeEvent = true
        dateTimeViewController.isEditEvent = dataSource.eventDetails.eventDate != "" ? true : false
        dateTimeViewController.selectedDate = dataSource.eventDetails.eventDate
        dateTimeViewController.selectedStartTime = dataSource.eventDetails.startTime
        dateTimeViewController.selectedEndTime = dataSource.eventDetails.endTime
        dateNavigationController.setupAppThemeNavigationBar()
        dateNavigationController.viewControllers = [dateTimeViewController]
        self.present(dateNavigationController, animated: true, completion: nil)
    }
    
    
    func didTapSelection() {
        getEventDetail()
    }
    
    
    func didSelectionTapped() {
        getEventDetail()
    }
}

extension EventOwnerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("image data")
            self.hiddeImageView.isHidden = false
            self.image = image
            self.commentImageView.image = image
            self.isImageAddedInComment = true
            self.isCommentAdded = true
            
        } else {
            self.isImageAddedInComment = false
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker canceled")
        self.isImageAddedInComment = false
        pickerController.dismiss(animated: true, completion: nil)
    }
}

extension EventOwnerViewController: confirmPopUpSelectionDelegate {
    func didSelectOption(selection: Bool) {
        if selection {
            print("confirm delete")
            self.dismiss(animated: true, completion: nil)
            
            if self.ignorEvent {
            setStatus(status: 4)
            }
            else{
            self.cancelEvent()
            }
        } else {
            print("do nothind")
            self.ignorEvent = false
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension EventOwnerViewController: DateTimeViewControllerDelegate {
    func schedualValues(value: String, component: EventSchedule, date: Date, time: String) {
        
    }
    
    func didTapSuggestion() {
        getEventDetail()
    }
}

extension EventOwnerViewController: EventFormViewControllerDelegate {
    func didEditEvent() {
        getEventDetail()
    }
}

extension EventOwnerViewController : EventHeaderTableViewCellDelegate {
    func didTapIgnoreButton() {
        self.ignorEvent = true
        let popUp = RemoveConfirmViewController()
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.ignorEvent = true
        popUp.delegate = self
        self.present(popUp, animated: true, completion: nil)
    
    }
    
    func didTapDontJoinButton() {
        setStatus(status: 0)
    }
    
    func didTapMaybeButton() {
        if dataSource.eventDetails.eventMembers.count > 2 {
            setStatus(status: 2)
            
        } else {
            Utility.isEventStatusChange = true
            let dateNavigationController = UINavigationController()
            let dateTimeViewController = DateTimeViewController()
            dateTimeViewController.delegate = self
            dateTimeViewController.eventId = self.id
            dateTimeViewController.eventSchedual = .Date
            dateTimeViewController.isSuggestTimeEvent = true
            dateTimeViewController.isEditEvent = dataSource.eventDetails.eventDate != "" ? true : false
            dateTimeViewController.selectedDate = dataSource.eventDetails.eventDate
            dateTimeViewController.selectedStartTime = dataSource.eventDetails.startTime
            dateTimeViewController.selectedEndTime = dataSource.eventDetails.endTime
            dateNavigationController.setupAppThemeNavigationBar()
            dateNavigationController.viewControllers = [dateTimeViewController]
            self.present(dateNavigationController, animated: true, completion: nil)
        }
    }
    
    func didTapJoinButton() {
        setStatus(status: 1)
    }
    
    func didSelectUserProfile(index: Int) {
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.userId = UserDefaults.standard.object(forKey: kUserId) as! Int
            
            if self.dataSource.eventDetails.eventMembers[index].userId != self.userId {
                let profileViewController  = UserProfileViewController()
                profileViewController.userId = self.dataSource.eventDetails.eventMembers[index].userId
                profileViewController.userName = "\(self.dataSource.eventDetails.eventMembers[index].firstName) \(self.dataSource.eventDetails.eventMembers[index].lastName)"
                profileViewController.firstName = self.dataSource.eventDetails.eventMembers[index].firstName
                if self.dataSource.eventDetails.eventMembers[index].status == 1 {
                    profileViewController.inHive = true
                }
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

extension EventOwnerViewController: MainAppDelegate {
    func didPresentNotification() {
        self.isCommentAdded = true
        getEventDetail(isComment: true)
    }
}


