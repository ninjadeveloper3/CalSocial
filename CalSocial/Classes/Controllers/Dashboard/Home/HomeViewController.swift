//
//  HomeViewController.swift
//  CalSocial
//
//  Created by DevBatch on 01/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    
    var calendar: VACalendarView!
    
    var lastContentOffset : CGFloat = 0
    
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = .current
        return calendar
    }()
    
    var isCalenderHidden = false
    
    var favouritesDatasource = Mapper<FavouritesModel>().map(JSON: [:])!
    
    var isLoadData = false
    
    var isLoadFavouriteData = false
    
    var dataSource = [UserCalender]()
    
    var hiveDataSource = [HiveModel]()
    
    var datesData = [(Date, [VADaySupplementary])]()
    
    var isCreateEvent = false
    
    var isHive = false
    
    var contactDatasouce = [Contacts]()
    
    var permission = false
    
    var isLoadEvent = false
    
    let refreshControl = UIRefreshControl()
    
    var isPullToRefresh = false
    
    var profileLabel = UILabel()
    
    var backButton = UIButton()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var emptyFavouritesLabel: UILabel!
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var monthsHeaderView: VAMonthHeaderView!{
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL YYYY"
            
            let appereance = VAMonthHeaderViewAppearance(
                monthFont: UIFont.muliBold(14.0),
                monthTextColor: #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1),
                previousButtonImage: #imageLiteral(resourceName: "left-arrow-1"),
                nextButtonImage: #imageLiteral(resourceName: "Right-arrow"),
                dateFormatter: dateFormatter
            )
            monthsHeaderView.delegate = self
            monthsHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var calendarView: UIView!
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView!{
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .short,
                                                      weekDayTextColor: #colorLiteral(red: 0.4391649365, green: 0.4392448664, blue: 0.4391598701, alpha: 1),
                                                      weekDayTextFont: UIFont.muliRegular(14.0),
                                                      calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    @IBOutlet weak var calenderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var weekDaysViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpViewController()
        if calendar.frame == .zero {
            calendar.frame = CGRect(
                x: 0,
                y: 0,
                width: calendarView.frame.width,
                height: calendarView.frame.height
            )
            calendar.setup()
        }
        hideCalender()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.newEventCreated),
            name: NSNotification.Name(rawValue: "NewEventCreated"),
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        getFavourites()
//        if Utility.isProfileEdit {
//            Utility.isProfileEdit = false
            updateProfileImage()
//        }
        
        if Utility.isEventStatusChange {
            getUserCalender(limit: 200, page: 1)
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        if isCreateEvent {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.createNewEvent()
            }
        }
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "home-logo")
        self.navigationItem.titleView = imageView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Search"), style: .plain, target: self, action: #selector(editButtonTapped(sender:)))
        customBarButton()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        let vCalendar = VACalendar(calendar: defaultCalendar)
        calendar = VACalendarView(frame: .zero, calendar: vCalendar)
        calendar.showDaysOut = true
        
        calendar.selectionStyle = .single
        calendar.monthDelegate = monthsHeaderView
        calendar.dayViewAppearanceDelegate = self
        calendar.monthViewAppearanceDelegate = self
        calendar.calendarDelegate = self
        calendar.scrollDirection = .horizontal
        calendar.selectDates([Date()])
        calendarView.addSubview(calendar)
        tableView.separatorStyle = .none
        let calanderGesture = UITapGestureRecognizer(target: self, action: #selector(openCloseCalender(sender:)))
        monthsHeaderView.addGestureRecognizer(calanderGesture)
        getUserCalender(limit: 200, page: 1)
    }
    
    //MARK: - Private Methods
    
    @objc private func newEventCreated(notification: NSNotification) {
        getUserCalender(limit: 200, page: 1)
    }
    
    func customBarButton() {
        profileLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        backButton = UIButton (type: UIButton.ButtonType.custom)
        
        if Utility.isKeyPresentInUserDefaults(key: kUserColorCode) {
            if let color = UserDefaults.standard.object(forKey: kUserColorCode) as? String {
                backButton.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(color, alpha: 1.0)
            }
            
        } else {
            backButton.backgroundColor = UIColor.appThemeColor()
        }
        
        backButton.layer.cornerRadius = 12
        self.backButton.imageView?.layer.cornerRadius = 12
        profileLabel.textColor = .white
        profileLabel.textAlignment = .center
        if Utility.isKeyPresentInUserDefaults(key: kUserProfileImageUrl) {
            profileLabel.isHidden = true
            if let profilePic = UserDefaults.standard.object(forKey: kUserProfileImageUrl) as? String {
                profileLabel.isHidden = true
                if profilePic != "" {
                    let imageView = UIImageView()
                    imageView.layer.cornerRadius = 12
                    imageView.layer.masksToBounds = true
                    imageView.backgroundColor = .clear
                    self.backButton.backgroundColor = .clear
                    if let url = URL(string: "\(kImageDownloadBaseUrl)\(profilePic)") {
                        print("url",url)
                        imageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            self.backButton.imageView?.layer.cornerRadius = 12
                            self.backButton.imageView?.layer.masksToBounds = true
                            self.backButton.imageView?.contentMode = .scaleToFill
                            self.backButton.imageView?.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
                            self.backButton.setBackgroundImage(imageView.image, for: .normal)
                        })
                    }
                    
                } else {
                    if Utility.isKeyPresentInUserDefaults(key: kUserFirstName)  {
                        var fname = ""
                        var lname = ""
                        if let firstName = UserDefaults.standard.object(forKey: kUserFirstName) as? String {
                            fname = firstName.getFirstChar()
                        }
                        if let lastName = UserDefaults.standard.object(forKey: kUserLastName) as? String {
                            lname = lastName.getFirstChar()
                        }
                        profileLabel.text = fname+lname
                        
                    } else {
                        profileLabel.text = "A"
                    }
                    backButton.addSubview(profileLabel)
                }
            }
            
        } else {
            if Utility.isKeyPresentInUserDefaults(key: kUserFirstName) {
                profileLabel.isHidden = false
                var fname = ""
                var lname = ""
                if let firstName = UserDefaults.standard.object(forKey: kUserFirstName) as? String {
                    fname = firstName.getFirstChar()
                }
                if let lastName = UserDefaults.standard.object(forKey: kUserLastName) as? String {
                    lname = lastName.getFirstChar()
                }
                profileLabel.text = fname+lname
                
            } else {
                profileLabel.text = "A"
            }
            backButton.addSubview(profileLabel)
        }
        backButton.addTarget(self, action: #selector(profileButtonTapped(button:)), for: UIControl.Event.touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        backButton.layer.cornerRadius = 12
        self.backButton.layer.masksToBounds = true
        let barButton = UIBarButtonItem(customView: backButton)
        
        let width = barButton.customView?.widthAnchor.constraint(equalToConstant: 35)
        width?.isActive = true
        
        let height = barButton.customView?.heightAnchor.constraint(equalToConstant: 35)
        height?.isActive = true
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    func updateProfileImage() {
        if Utility.isKeyPresentInUserDefaults(key: kUserProfileImageUrl) {
            if let profilePic = UserDefaults.standard.object(forKey: kUserProfileImageUrl) as? String {
                profileLabel.isHidden = true
                if profilePic != "" {
                    profileLabel.isHidden = true
                    let imageView = UIImageView()
                    imageView.layer.cornerRadius = 12
                    imageView.backgroundColor = .clear
                    self.backButton.backgroundColor = .clear
                    if let url = URL(string: "\(kImageDownloadBaseUrl)\(profilePic)") {
                        imageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            self.backButton.imageView?.contentMode = .scaleToFill
                            self.backButton.imageView?.layer.cornerRadius = 12
                            self.backButton.imageView?.layer.masksToBounds = false
                            self.backButton.imageView?.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
                            self.backButton.setBackgroundImage(imageView.image, for: .normal)
                        })
                    }
                    
                } else {
                    if Utility.isKeyPresentInUserDefaults(key: kUserFirstName) {
                        var fname = ""
                        var lname = ""
                        if let firstName = UserDefaults.standard.object(forKey: kUserFirstName) as? String {
                            fname = firstName.getFirstChar()
                        }
                        if let lastName = UserDefaults.standard.object(forKey: kUserLastName) as? String {
                            lname = lastName.getFirstChar()
                        }
                        profileLabel.text = fname+lname
                        profileLabel.isHidden = false
                        
                    } else {
                        profileLabel.text = "A"
                    }
                }
                
            } else {
                if Utility.isKeyPresentInUserDefaults(key: kUserFirstName) {
                    var fname = ""
                    var lname = ""
                    if let firstName = UserDefaults.standard.object(forKey: kUserFirstName) as? String {
                        fname = firstName.getFirstChar()
                    }
                    if let lastName = UserDefaults.standard.object(forKey: kUserLastName) as? String {
                        lname = lastName.getFirstChar()
                    }
                    profileLabel.text = fname+lname
                    profileLabel.isHidden = false
                    
                } else {
                    profileLabel.text = "A"
                }
            }
            
        } else {
            if Utility.isKeyPresentInUserDefaults(key: kUserFirstName) {
                var fname = ""
                var lname = ""
                if let firstName = UserDefaults.standard.object(forKey: kUserFirstName) as? String {
                    fname = firstName.getFirstChar()
                }
                if let lastName = UserDefaults.standard.object(forKey: kUserLastName) as? String {
                    lname = lastName.getFirstChar()
                }
                profileLabel.text = fname+lname
                profileLabel.isHidden = false
                
            } else {
                profileLabel.text = "A"
            }
        }
    }
    
    @objc func editButtonTapped(sender: UIBarButtonItem) {
        let searchViewController  = SearchHomeViewController()
        let searchNavigationController = UINavigationController()
        searchNavigationController.setupAppThemeNavigationBar()
        searchNavigationController.viewControllers = [searchViewController]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(searchNavigationController, animated: true, completion: nil)
        }
    }
    
    @objc func profileButtonTapped(button: UIButton) {
        let profileViewController  = MyProfileViewController()
        let profileNavigationController = UINavigationController()
        profileNavigationController.setupAppThemeNavigationBar()
        profileNavigationController.viewControllers = [profileViewController]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(profileNavigationController, animated: true, completion: nil)
        }
    }
    
    @objc func openCloseCalender(sender: UITapGestureRecognizer) {
        if isCalenderHidden {
            showCalender()
            
        } else {
            //            hideCalender()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideCalender() {
        borderView.isHidden = true
        weekDaysViewHeight.constant = 0
        calenderViewHeight.constant = 0
        isCalenderHidden = true
    }
    
    func showCalender() {
        borderView.isHidden = false
        calendarView.isHidden = false
        weekDaysView.isHidden = false
        weekDaysViewHeight.constant = 50
        calenderViewHeight.constant = 200
        isCalenderHidden = false
    }
    
    func getFavourites() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getFavorites { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                self.emptyFavouritesLabel.isHidden = false
                
            } else {
                if let data = Mapper<FavouritesModel>().map(JSONObject: result) {
                    self.isLoadFavouriteData = true
                    
                    if data.hive.count == 0 && data.swarm.count == 0 {
                        self.isHive = true
                        self.favouritesDatasource.hive.removeAll()
                        self.favouritesDatasource.swarm.removeAll()
                        self.getMyHive()
                        
                    } else {
                        self.isHive = false
                        self.favouritesDatasource = data
                        self.emptyFavouritesLabel.isHidden = true
                    }
                    self.homeCollectionView.reloadData()
                }
            }
        }
    }
    
    func getMyHive(){
        
        APIClient.sharedClient.getHive(page: -1, limit: 100) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                self.emptyFavouritesLabel.isHidden = true
                
            } else {
                if let data = Mapper<HiveModel>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.emptyFavouritesLabel.isHidden = false
                        self.hiveDataSource.removeAll()
                        
                    } else {
                        self.emptyFavouritesLabel.isHidden = true
                        self.hiveDataSource = data
                    }
                    self.homeCollectionView.reloadData()
                }
            }
        }
    }
    
    func getUserCalender(limit: Int, page: Int, date: Date = Date()) {
        
        if !isPullToRefresh {
            Utility.showLoading(viewController: self)
        }
        
        APIClient.sharedClient.getUserCalender(page: page, limit: limit,userDate: date) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            
            if !self.isPullToRefresh {
                Utility.hideLoading(viewController: self)
            } else {
                self.refreshControl.endRefreshing()
                
            }
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<UserCalender>().mapArray(JSONObject: result) {
                    
                    if self.isPullToRefresh {
                        self.isPullToRefresh = false
                        self.dataSource.removeAll()
                    }
                    
                    self.isLoadData = true
                    self.dataSource = data
                    self.tableView.reloadData()
                    
                    for data in self.dataSource {
                        let userDate = Date().covertStringToDate(date: data.date)
                        self.datesData.append((userDate, [VADaySupplementary.bottomDots([#colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)])]))
                    }
                    self.calendar.setSupplementaries(self.datesData)
                }
            }
        }
    }
    
    func createNewEvent() {
        let newEventViewController = EventFormViewController()
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventViewController.emptyEventForm = true
        newEventNavigationController.viewControllers = [newEventViewController]
        self.present(newEventNavigationController, animated: true, completion: nil)
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func createEventButtonTapped(_ sender: Any) {
        createNewEvent()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        self.isPullToRefresh = true
        getUserCalender(limit: 200, page: 1)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadFavouriteData {
            if section == 0 {
                return self.favouritesDatasource.swarm.count
            }
            
            
            if self.favouritesDatasource.hive.count > 0 || self.favouritesDatasource.swarm.count > 0 {
                return self.favouritesDatasource.hive.count
            }
            else{
                return self.hiveDataSource.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if favouritesDatasource.swarm[indexPath.item].swarmMembers.count >= 1 && favouritesDatasource.swarm[indexPath.item].swarmMembers.count < 3 { //if swarm member is 2
                let cell = TwoMembersCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
                cell.delegate = self
                cell.swarmTitleLabel.text = "\(self.favouritesDatasource.swarm[indexPath.item].title)"
                for (index, member) in self.favouritesDatasource.swarm[indexPath.item].swarmMembers.enumerated() {
                    if member.profilePicture == "" {
                        if index == 0 {
                            cell.firstView.isHidden = false
                            cell.firstViewImage.isHidden = true
                            cell.firstViewLabel.text = member.firstName.getFirstChar()+member.lastName.getFirstChar()
                            cell.firstView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( member.color, alpha: 1.0)
                        }
                        if index == 1 {
                            cell.secondView.isHidden = false
                            cell.secondViewImage.isHidden = true
                            cell.secondViewLabel.text = member.firstName.getFirstChar()+member.lastName.getFirstChar()
                            cell.secondView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( member.color, alpha: 1.0)
                        }
                    }
                    else{
                        cell.firstView.isHidden = false
                        cell.firstViewImage.isHidden = true
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePicture)") {
                            print("url",url)
                            if index == 0 {
                                cell.firstViewImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                                })
                            }
                            if index == 1 {
                                cell.secondViewImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                                })
                            }
                        }
                    }
                }
                return cell
            }
            
            if favouritesDatasource.swarm[indexPath.item].swarmMembers.count == 3 { //if swarm member is 3
                let cell = ThreeMemberCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
                cell.delegate = self
                cell.swarmTitleLabel.text = "\(self.favouritesDatasource.swarm[indexPath.item].title)"
                for (index, member) in self.favouritesDatasource.swarm[indexPath.item].swarmMembers.enumerated() {
                    if member.profilePicture == ""{
                        if index == 0 {
                            cell.firstView.isHidden = false
                            cell.firstViewImage.isHidden = true
                            cell.firstViewLabel.text = member.firstName.getFirstChar()+member.lastName.getFirstChar()
                            cell.firstView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( member.color, alpha: 1.0)
                        }
                        if index == 1 {
                            
                            cell.secondView.isHidden = false
                            cell.secondViewImage.isHidden = true
                            cell.secondViewLabel.text = member.firstName.getFirstChar()+member.lastName.getFirstChar()
                            cell.secondView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( member.color, alpha: 1.0)
                        }
                        if index == 2 {
                            cell.thirdView.isHidden = false
                            cell.thirdViewImage.isHidden = true
                            cell.thirdViewLabel.text = member.firstName.getFirstChar()+member.lastName.getFirstChar()
                            cell.thirdView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( member.color, alpha: 1.0)
                        }
                    }
                    else{
                        cell.firstView.isHidden = false
                        cell.firstViewImage.isHidden = true
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePicture)") {
                            print("url",url)
                            if index == 0 {
                                cell.firstViewImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                                })
                            }
                            if index == 1 {
                                cell.secondViewImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                                })
                            }
                            if index == 2 {
                                cell.thirdViewImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                                })
                            }
                        }
                    }
                }
                return cell
            }
            
            let cell = HomeCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            cell.delegate = self
            cell.swarmTitleLabel.text = "\(self.favouritesDatasource.swarm[indexPath.item].title)"
            
            for (index, member) in self.favouritesDatasource.swarm[indexPath.item].swarmMembers.enumerated() {
                if member.profilePicture == ""{
                    if index == 0 {
                        cell.firstView.isHidden = false
                        cell.firstViewImage.isHidden = true
                        cell.firstViewLabel.text = member.firstName.getFirstChar()
                        cell.firstView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( member.color, alpha: 1.0)
                    }
                    if index == 1 {
                        
                        cell.secondView.isHidden = false
                        cell.secondViewImage.isHidden = true
                        cell.secondViewLabel.text = member.firstName.getFirstChar()+member.lastName.getFirstChar()
                        cell.secondView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( member.color, alpha: 1.0)
                    }
                    if index == 2 {
                        cell.thirdView.isHidden = false
                        cell.thirdViewImage.isHidden = true
                        cell.thirdViewLabel.text = member.firstName.getFirstChar()+member.lastName.getFirstChar()
                        cell.thirdView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( member.color, alpha: 1.0)
                    }
                    if index == 3 {
                        cell.forthView.isHidden = false
                        cell.forthViewImage.isHidden = true
                        cell.thirdViewLabel.text = member.firstName.getFirstChar()+member.lastName.getFirstChar()
                        cell.forthView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( member.color, alpha: 1.0)
                    }
                    
                } else {
                    cell.firstView.isHidden = false
                    cell.firstViewImage.isHidden = true
                    if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePicture)") {
                        print("url",url)
                        if index == 0 {
                            cell.firstViewImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098") , filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                        if index == 1 {
                            cell.secondViewImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                        if index == 2 {
                            cell.thirdViewImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                        if index == 3 {
                            cell.forthViewImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
            }
            return cell
            
        }
        
        let cell = HomeUserCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        cell.delegate = self
        
        if self.favouritesDatasource.hive.count > 0 {
            if self.favouritesDatasource.hive[indexPath.item].profilePicture == "" {
                cell.emptyView.isHidden = false
                cell.emptyViewLabel.text = self.favouritesDatasource.hive[indexPath.item].firstName.getFirstChar()+self.favouritesDatasource.hive[indexPath.item].lastName.getFirstChar()
                cell.emptyView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( self.favouritesDatasource.hive[indexPath.item].color, alpha: 1.0)
            }
            else{
                cell.emptyView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.favouritesDatasource.hive[indexPath.item].profilePicture)") {
                    print("url",url)
                    cell.profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "loading-placeholder"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                    
                } else {
                    cell.emptyView.isHidden = false
                    cell.emptyViewLabel.text = self.favouritesDatasource.hive[indexPath.item].firstName.getFirstChar()
                }
            }
            cell.nameLabel.text = "\(self.favouritesDatasource.hive[indexPath.item].firstName)"
            
        } else {
            if self.hiveDataSource[indexPath.item].hiveMember.profilePicture == "" {
                cell.emptyView.isHidden = false
                cell.emptyViewLabel.text = self.hiveDataSource[indexPath.item].hiveMember.firstName.getFirstChar()+self.hiveDataSource[indexPath.item].hiveMember.lastName.getFirstChar()
                cell.emptyView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( self.hiveDataSource[indexPath.item].hiveMember.color, alpha: 1.0)
            }
            else{
                cell.emptyView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.hiveDataSource[indexPath.item].hiveMember.profilePicture)") {
                    print("url",url)
                    cell.profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                        
                    })
                } else {
                    cell.emptyView.isHidden = false
                    cell.emptyViewLabel.text = self.hiveDataSource[indexPath.item].hiveMember.firstName.getFirstChar()
                }
            }
            cell.nameLabel.text = "\(self.hiveDataSource[indexPath.item].hiveMember.firstName)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 88 , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userDatasource = Mapper<BizeeUserModel>().map(JSON: [:])!
        let newEventViewController  = EventFormViewController()
        newEventViewController.emptyEventForm = true
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        if indexPath.section == 0 {
            
            let swarm = Mapper<SwarmModel>().map(JSON: [:])!
            swarm.swarmId = favouritesDatasource.swarm[indexPath.row].id
            for swarmMember in favouritesDatasource.swarm[indexPath.row].swarmMembers {
                let tempSwarmMember = Mapper<SwarmMember>().map(JSON: [:])!
                tempSwarmMember.userId = swarmMember.id
                swarm.swarm.swarmMembers.append(tempSwarmMember)
            }
            userDatasource.swarms.append(swarm)
            newEventViewController.swarmTitle = favouritesDatasource.swarm[indexPath.row].title
            newEventViewController.isSwarm = true
            newEventViewController.titleReload = true
            
        } else {
            if isHive {
                userDatasource.hives.append(hiveDataSource[indexPath.row])
                
            } else {
                let hive = Mapper<HiveModel>().map(JSON: [:])!
                hive.id = favouritesDatasource.hive[indexPath.row].id
                hive.hiveMember.id = favouritesDatasource.hive[indexPath.row].userId
                userDatasource.hives.append(hive)
            }
            newEventViewController.titleReload = true
        }
        
        newEventViewController.userContactDataSource = userDatasource
        newEventViewController.isOneToOneEvent = true
        newEventNavigationController.viewControllers = [newEventViewController]
        newEventNavigationController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.present(newEventNavigationController, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendar.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendar.previousMonth()
    }
}

extension HomeViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        if Utility.isiphone6() {
            return 10.0
        }
        if Utility.isiphone6Plus() {
            return 10.0
        }
        if Utility.isiphoneX() {
            return 8.0
        }
        return 0.0
    }
    
    func rightInset() -> CGFloat {
        
        if Utility.isiphone6() {
            return 50.0
        }
        if Utility.isiphone6Plus() {
            return 10.0
        }
        if Utility.isiphoneX() {
            return 8.0
        }
        return 0.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .ultraLight)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
    }
}

extension HomeViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case .selected:
            return .white
        case .unavailable:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default:
            return #colorLiteral(red: 0.4391649365, green: 0.4392448664, blue: 0.4391598701, alpha: 1)
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return #colorLiteral(red: 0.5414876938, green: 0.6542616487, blue: 0.7128990293, alpha: 1)
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return 0
        }
    }
}

extension HomeViewController: VACalendarViewDelegate {
    
    func selectedDate(_ date: Date) {
        hideCalender()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        monthsHeaderView.monthDidChange(date)
        getUserCalender(limit: 100, page: 1, date: date)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoadData {
            return self.dataSource.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadData {
            if section < self.dataSource.count {
                return self.dataSource[section].phoneEventData.count + self.dataSource[section].bizeeEventData.count + 1
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == IndexPath(row: 0, section: indexPath.section) {
            let headCell = HeaderTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            if indexPath.section == 0 {
                headCell.dateLabel.textColor = #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
                
            } else {
                headCell.dateLabel.textColor = .gray
            }
            headCell.dateLabel.text = Date().convertDateFormat(date: dataSource[indexPath.section].date)
            return headCell
            
        } else {
            if (indexPath.row - 1) < self.dataSource[indexPath.section].phoneEventData.count  {
                let nonBizeeCell = NonEventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                nonBizeeCell.initData(dataSource: self.dataSource[indexPath.section].phoneEventData[indexPath.row - 1])
                return nonBizeeCell
                
            } else {
                let index = indexPath.row - self.dataSource[indexPath.section].phoneEventData.count - 1
                
                let swarmEventCell = SwarmEventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                if self.dataSource[indexPath.section].bizeeEventData[index].swarms.members.count != 0 {
                    swarmEventCell.initData(dataSource: self.dataSource[indexPath.section].bizeeEventData[index],dateFormat: false)
                    return swarmEventCell
                    
                } else {
                    let eventCell = EventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                    eventCell.initData(dataSource: self.dataSource[indexPath.section].bizeeEventData[index],dateFormat: false)
                    return eventCell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath != IndexPath(row: 0, section: indexPath.section) {
            if (indexPath.row - 1) >= self.dataSource[indexPath.section].phoneEventData.count {
                let index = indexPath.row - self.dataSource[indexPath.section].phoneEventData.count - 1
                let newEventViewController = EventOwnerViewController()
                let newEventNavigationController = UINavigationController()
                newEventNavigationController.setupAppThemeNavigationBar()
                newEventViewController.id = self.dataSource[indexPath.section].bizeeEventData[index].id
                newEventViewController.eventTitle = self.dataSource[indexPath.section].bizeeEventData[index].title
                newEventNavigationController.viewControllers = [newEventViewController]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.present(newEventNavigationController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= self.dataSource.count {
            return 120
        }
        return 0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            // did move up
            hideCalender()
            
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            // did move down
            hideCalender()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: HomeCollectionViewCellDelegate, ThreeMemberCollectionViewCellDelegate, TwoMembersCollectionViewCellDelegate {
    func didLongPressTapped(cell: TwoMembersCollectionViewCell) {
        if let indexPath = homeCollectionView.indexPath(for: cell) {
            var roleId = 0
            var userId = 0
            if Utility.isKeyPresentInUserDefaults(key: kUserId){
                userId = UserDefaults.standard.object(forKey: kUserId) as! Int
            }
            for member in self.favouritesDatasource.swarm[indexPath.item].swarmMembers {
                if member.id == userId && member.role == 1 {
                    roleId = 1
                }
            }
            
            let newEventViewController = SwarmBaseViewController()
            let newEventNavigationController = UINavigationController()
            newEventNavigationController.setupAppThemeNavigationBar()
            newEventViewController.swarmId = self.favouritesDatasource.swarm[indexPath.item].id
            newEventViewController.isFavourite = 1
            newEventViewController.roleId = roleId
            newEventNavigationController.viewControllers = [newEventViewController]
            newEventNavigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(newEventNavigationController, animated: true, completion: nil)
            }
        }
    }
    
    func didLongPressTapped(cell: ThreeMemberCollectionViewCell) {
        if let indexPath = homeCollectionView.indexPath(for: cell) {
            let newEventViewController = SwarmBaseViewController()
            let newEventNavigationController = UINavigationController()
            newEventNavigationController.setupAppThemeNavigationBar()
            newEventViewController.swarmId = self.favouritesDatasource.swarm[indexPath.item].id
            newEventViewController.isFavourite = 1
            newEventNavigationController.viewControllers = [newEventViewController]
            newEventNavigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(newEventNavigationController, animated: true, completion: nil)
            }
        }
    }
    
    func didLongPressTapped(cell: HomeCollectionViewCell) {
        if let indexPath = homeCollectionView.indexPath(for: cell) {
            var roleId = 0
            var userId = 0
            if Utility.isKeyPresentInUserDefaults(key: kUserId){
                userId = UserDefaults.standard.object(forKey: kUserId) as! Int
            }
            for member in self.favouritesDatasource.swarm[indexPath.item].swarmMembers {
                if member.id == userId && member.role == 1 {
                    roleId = 1
                }
            }
            
            
            let newEventViewController = SwarmBaseViewController()
            let newEventNavigationController = UINavigationController()
            newEventNavigationController.setupAppThemeNavigationBar()
            newEventViewController.swarmId = self.favouritesDatasource.swarm[indexPath.item].id
            newEventViewController.isFavourite = 1
            newEventViewController.roleId = roleId
            newEventNavigationController.viewControllers = [newEventViewController]
            newEventNavigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(newEventNavigationController, animated: true, completion: nil)
            }
        }
    }
}

extension HomeViewController: HomeUserCollectionViewCellDelegate {
    
    func didLongPressTapped(cell: HomeUserCollectionViewCell) {
        if let indexPath = homeCollectionView.indexPath(for: cell) {
            
            if isHive {
                let profileViewController  = UserProfileViewController()
                profileViewController.userId = hiveDataSource[indexPath.item].hiveMember.id
                profileViewController.userName = "\( hiveDataSource[indexPath.item].hiveMember.firstName) \( hiveDataSource[indexPath.item].hiveMember.lastName)"
                profileViewController.firstName = hiveDataSource[indexPath.item].hiveMember.firstName
                let profileNavigationController = UINavigationController()
                profileNavigationController.setupAppThemeNavigationBar()
                profileNavigationController.viewControllers = [profileViewController]
                profileNavigationController.modalPresentationStyle = .fullScreen
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.present(profileNavigationController, animated: true, completion: nil)
                }
                
            } else {
                let profileViewController  = UserProfileViewController()
                profileViewController.userId = self.favouritesDatasource.hive[indexPath.item].userId
                profileViewController.userName = "\(self.favouritesDatasource.hive[indexPath.item].firstName) \( self.favouritesDatasource.hive[indexPath.item].lastName)"
                profileViewController.firstName = self.favouritesDatasource.hive[indexPath.item].firstName
                let profileNavigationController = UINavigationController()
                profileNavigationController.setupAppThemeNavigationBar()
                profileNavigationController.viewControllers = [profileViewController]
                profileNavigationController.modalPresentationStyle = .fullScreen
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.present(profileNavigationController, animated: true, completion: nil)
                }
            }
        }
    }
}

