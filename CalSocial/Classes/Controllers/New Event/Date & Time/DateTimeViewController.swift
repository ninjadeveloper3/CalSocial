//
//  DateTimeViewController.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

protocol DateTimeViewControllerDelegate {
    func schedualValues(value: String, component: EventSchedule, date: Date, time: String)
    func didTapSuggestion()
}

class DateTimeViewController: UIViewController {

    //MARK: - Variables
    
    var calendar: VACalendarView!
    
    var delegate : DateTimeViewControllerDelegate?
    
    var eventSchedual: EventSchedule = .Date
    
    var selectedDate: String = ""
    
    var inMyHive = false

    
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = .current
        return calendar
    }()
    
    var isCalenderHidden = false
    
    var selectedLastDate = Date()
    
    var selectedStartTime = ""
    
    var selectedEndTime = ""
    
    var dateObject = Date()
    
    var stringStartTime = ""
    
    var stringEndTime = ""
    
    var userId = 0
    
    var time = ""
    
    var isEditEvent = false
    
    var isSuggestTimeEvent = false
    
    var eventId = 0
    
    var userContactDataSource = Mapper<BizeeUserModel>().map(JSON: [:])!
    
    var memberDatasource = [EventMember]()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var startPicker: UIDatePicker!
    
    @IBOutlet weak var endPicker: UIDatePicker!
    
    @IBOutlet weak var endTimeDisplay: UILabel!
    
    @IBOutlet weak var startTimeDisplay: UILabel!
    
    @IBOutlet weak var startTimeOutlet: UIButton!
    
    @IBOutlet weak var endTimeOutlet: UIButton!
    
    
    @IBOutlet weak var monthsHeaderView: VAMonthHeaderView!{
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL YYYY"
            
            let appereance = VAMonthHeaderViewAppearance(
                monthFont: UIFont.muliBold(14.0),
                monthTextColor: #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1),
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
    
    @IBOutlet weak var startPickerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var endPickerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var continueButtonPosition: NSLayoutConstraint!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendar.frame == .zero {
            calendar.frame = CGRect(
                x: 0,
                y: 0,
                width: calendarView.frame.width,
                height: calendarView.frame.height
            )
            calendar.setup()
        }
    }
    
    //MARK: - SetUp ViewController Methods

    func setUpViewController() {
        startPicker.datePickerMode = .time
        endPicker.datePickerMode = .time
        
        let vCalendar = VACalendar(calendar: defaultCalendar)
        calendar = VACalendarView(frame: .zero, calendar: vCalendar)
        calendar.showDaysOut = true
        calendar.selectionStyle = .single
        calendar.monthDelegate = monthsHeaderView
        calendar.dayViewAppearanceDelegate = self
        calendar.monthViewAppearanceDelegate = self
        calendar.calendarDelegate = self
        calendar.scrollDirection = .horizontal
        calendarView.addSubview(calendar)
        let calanderGesture = UITapGestureRecognizer(target: self, action: #selector(openCloseCalender(sender:)))
        monthsHeaderView.addGestureRecognizer(calanderGesture)
        
        self.navigationItem.title = "Date & Time"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        self.navigationItem.leftBarButtonItem?.setFontStyle()
        
        self.startPicker.isHidden = true
        self.startPickerHeight.constant = 0
        
        self.endPicker.isHidden = true
        self.endPickerHeight.constant = 0
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.userId = UserDefaults.standard.object(forKey: kUserId) as! Int
        }
        
        if isEditEvent {
            let stringDateFormatter = DateFormatter()
            stringDateFormatter.dateFormat = "yyyy-MM-dd"
            let date = stringDateFormatter.date(from: selectedDate) ?? Date()
//            let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date()
            calendar.selectDates([date])
            dateObject = date
            
            let stringTimeFormatter = DateFormatter()
            stringTimeFormatter.dateFormat = "HH:00:00"
            let startTime = stringTimeFormatter.date(from: selectedStartTime) ?? Date()
            let endTime = stringTimeFormatter.date(from: selectedEndTime) ?? Date()
            
            startPicker.setDate(startTime, animated: false)
            endPicker.setDate(endTime, animated: false)
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short
            endTimeDisplay.text = dateFormatter.string(from: endTime)
            startTimeDisplay.text = dateFormatter.string(from: startTime)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:00:00"
            stringEndTime = timeFormatter.string(from: endTime)
            stringStartTime = timeFormatter.string(from: startTime)
        }
    }
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        if isSuggestTimeEvent {
            self.dismiss(animated: true, completion: nil)
        
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func hideCalender() {
        weekDaysViewHeight.constant = 0
        calenderViewHeight.constant = 0
        isCalenderHidden = true
    }
    
    func showCalender() {
        weekDaysViewHeight.constant = 50
        calenderViewHeight.constant = 220
        isCalenderHidden = false
    }
    
    @objc func openCloseCalender(sender: UITapGestureRecognizer) {
        if isCalenderHidden {
            showCalender()
            
            if startPicker.isHidden == false {
                self.startPicker.isHidden = true
                self.startPickerHeight.constant = 0
                
            }
            
            if endPicker.isHidden == false {
                self.endPicker.isHidden = true
                self.endPickerHeight.constant = 0
                
            }
            
        } else {
            hideCalender()
        }
        
        UIView.animate(withDuration: 0.7, animations: {
            self.view.layoutIfNeeded()
            
        }) { (finished) in
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func pickerValueChanged(_ sender: Any) {
        //        if eventSchedual == .StartTime {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        
        let selectedTimeFormatter = DateFormatter()
        selectedTimeFormatter.dateFormat = "HH:mm:ss"
        if isSuggestTimeEvent {
            selectedTimeFormatter.dateFormat = "HH:mm:ss"
        }
        
        selectedStartTime = selectedTimeFormatter.string(from: startPicker.date)
        
        let strDate = dateFormatter.string(from: startPicker.date)
        startTimeDisplay.text = strDate
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mma"
        stringStartTime = timeFormatter.string(from: startPicker.date)
        
    }
    
    @IBAction func endTimeChanged(_ sender: Any) {
        //        if eventSchedual == .EndTime {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let selectedTimeFormatter = DateFormatter()
        selectedTimeFormatter.dateFormat = "HH:mm:ss"
        if isSuggestTimeEvent {
            selectedTimeFormatter.dateFormat = "HH:mm:ss"
        }
        selectedEndTime = selectedTimeFormatter.string(from: endPicker.date)
        
        let strDate = dateFormatter.string(from: endPicker.date)
        endTimeDisplay.text = strDate
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mma"
        stringEndTime = timeFormatter.string(from: endPicker.date)
        //        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
        if startPicker.isHidden == false {
            self.startPicker.isHidden = true
            self.startPickerHeight.constant = 0
            
        } else {
            self.startPickerHeight.constant = 100
            self.startPicker.isHidden = false
            self.endPicker.isHidden = true
            self.endPickerHeight.constant = 0
            hideCalender()
        }
        
        UIView.animate(withDuration: 0.5)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func endButtonTapped(_ sender: Any) {
        
        if endPicker.isHidden == false {
            self.endPicker.isHidden = true
            self.endPickerHeight.constant = 0
            
        } else {
            self.endPickerHeight.constant = 100
            self.endPicker.isHidden = false
            hideCalender()
            self.startPicker.isHidden = true
            self.startPickerHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.5)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        if isSuggestTimeEvent {
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.suggestOtherTime(eventId: eventId, date: selectedDate, startTime: selectedStartTime, endTime: selectedEndTime) { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self)
                    
                } else {
                    self.delegate?.didTapSuggestion()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            
            let dateLimit = endPicker.date - startPicker.date
            let hours = Int(dateLimit)/3600
            if hours > 24 || hours < 0 {
                NSError.showErrorWithMessage(message: "Time interval should be within the 24 hours", viewController: self, type: .error, isNavigation: true)
                return
            }
            
            if startPicker.date == endPicker.date {
                NSError.showErrorWithMessage(message: "Please select different Start & End time for Event", viewController: self, type: .error, isNavigation: true)
                return
            }
            
            
            
            if stringStartTime != "" && stringEndTime != "" && selectedDate != "" {
                
                
                if (userContactDataSource.hives.count > 0 && !inMyHive) || (userContactDataSource.swarms.count > 0 && !inMyHive) {
                    
//                    let chooseTimeViewController = ChooseTimeViewController()
//
//                    chooseTimeViewController.userContactDataSource = self.userContactDataSource
//                    chooseTimeViewController.userId = self.userId
//                    chooseTimeViewController.selectedDate = self.selectedDate
//                    chooseTimeViewController.dateObject = self.dateObject
//                    chooseTimeViewController.selectedStartTime = self.selectedStartTime
//                    chooseTimeViewController.selectedEndTime = self.selectedEndTime
//                    chooseTimeViewController.stringStartTime = self.stringStartTime
//                    chooseTimeViewController.stringEndTime = self.stringEndTime
//                    self.navigationController?.pushViewController(chooseTimeViewController, animated: true)
//                    profileNavigationController.setupAppThemeNavigationBar()
//                    profileNavigationController.viewControllers = [chooseTimeViewController]
//                    self.present(profileNavigationController, animated: true, completion: nil)
                    
                    
                    let transition:CATransition = CATransition()
                    transition.duration = 0.5
                    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromTop
                    let chooseTimeViewController = ChooseTimeViewController()
                    chooseTimeViewController.userContactDataSource = self.userContactDataSource
                    chooseTimeViewController.userId = self.userId
                    chooseTimeViewController.selectedDate = self.selectedDate
                    chooseTimeViewController.dateObject = self.dateObject
                    chooseTimeViewController.selectedStartTime = self.selectedStartTime
                    chooseTimeViewController.selectedEndTime = self.selectedEndTime
                    chooseTimeViewController.stringStartTime = self.stringStartTime
                    chooseTimeViewController.stringEndTime = self.stringEndTime
                    self.navigationController?.view.layer.add(transition, forKey: kCATransition)
                    self.navigationController?.pushViewController(chooseTimeViewController, animated: true)
                    
                }
                else{
                    let controllers = self.navigationController?.viewControllers
                    for vc in controllers! {
                        if vc is EventFormViewController {
                            let eventViewController = vc as! EventFormViewController
//                                self.suggestedScore = dataSource[indexPath.row+1].guests.filter({$0.guestId != userId })
                                eventViewController.selectedDate = self.selectedDate
                                eventViewController.selectedStartTime = self.selectedStartTime
                                eventViewController.selectedEndTime = self.selectedEndTime
//                                eventViewController.score = dataSource[indexPath.row+1].score
                                eventViewController.isScoreUpdate = true
                            eventViewController.scoreForNonBizee = false
//                                eventViewController.suggestedScore = self.suggestedScore
                            self.navigationController?.popToViewController(eventViewController, animated: true)
                        }
                    }
                }
                
                
                
            } else if selectedDate == "" {
                NSError.showErrorWithMessage(message: "Please select a future date to proceed", viewController: self, type: .error, isNavigation: true)
                
            } else if stringStartTime == "" {
                NSError.showErrorWithMessage(message: "Please select start time to proceed", viewController: self, type: .error, isNavigation: true)
                
            } else if stringEndTime == "" {
                NSError.showErrorWithMessage(message: "Please select end time to proceed", viewController: self, type: .error, isNavigation: true)
            }
        }
    }
}

extension DateTimeViewController: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendar.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendar.previousMonth()
    }
}

extension DateTimeViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
//        if Utility.isiphone6() {
//            return 10.0
//        }
//        if Utility.isiphone6Plus() {
//            return 10.0
//        }
//        if Utility.isiphoneX() {
//            return 8.0
//        }
        return 10.0
    }
    
    func rightInset() -> CGFloat {
//        if Utility.isiphone6() {
//            return 50.0
//        }
//        if Utility.isiphone6Plus() {
//            return 10.0
//        }
//        if Utility.isiphoneX() {
//            return 8.0
//        }
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
    }
}

extension DateTimeViewController: VADayViewAppearanceDelegate {
    
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
            return -3
        }
    }
}

extension DateTimeViewController: VACalendarViewDelegate {
    
    func selectedDates(_ dates: [Date]) {
        calendar.startDate = dates.last ?? Date()
        print(dates)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        let date = dateFormatterPrint.string(from: dates.last ?? Date())
        selectedDate = date
        selectedLastDate = dates.last ?? Date()
        monthsHeaderView.monthDidChange(dates.last ?? Date())
    }
}
