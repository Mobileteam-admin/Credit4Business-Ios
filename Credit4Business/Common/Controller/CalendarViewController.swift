//
//  CalendarViewController.swift
//  Credit4Business
//
//  Created by MacMini on 12/03/24.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController{
    
    var dateSelectionHandler: ((String, Date) -> Void)?
    
    private var lastContentOffset: CGPoint = .zero
    
    @IBOutlet weak var monthView: UIView!
    
    @IBOutlet weak var monthTitle: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    var isRestrict = false
    //  let monthOptions = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    let selectedDateTextColor = UIColor.black
    let weekendTextColor = UIColor.init(red: 237/255, green: 27/255, blue: 47/255, alpha: 1.0)
    let highlightedColorForRange = UIColor.init(red: 243/255, green: 243/255, blue: 255/255, alpha: 0.9)
    let selectedColor = UIColor.init(red: 26/255, green: 66/255, blue: 155/255, alpha: 1)
    
    let weekdaysTextColor = UIColor.black
    private var currentPage: Date?
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date]?
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }()
    
    var startDate : Date?
    var endDate : Date?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    private lazy var today: Date = {
        return Date()
    }()
    // var currentMonthIndex = 6
    var currentMonthIndex = 0
    let calender = Calendar.current
    var month = FSCalendarHeaderView()
    var isForSweepIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.today = nil
        calendar.calendarHeaderView.backgroundColor = UIColor.white
        calendar.calendarWeekdayView.backgroundColor = UIColor.white
        calendar.appearance.weekdayTextColor = weekdaysTextColor
        calendar.scrollEnabled = false
        
        calendar.appearance.headerTitleColor = weekdaysTextColor
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.allowsMultipleSelection = true
        calendar.headerHeight = 0
        calendar.clipsToBounds = true
        view2.addSubview(calendar)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.61)
        calendar.appearance.titleWeekendColor = weekendTextColor
        calendar.appearance.titleSelectionColor = selectedDateTextColor
        calendar.appearance.borderRadius = 6
        updateMonthLabel()
        monthView.borderWidth = 2
        monthView.borderColor = UIColor(displayP3Red: 0, green: 14, blue: 51, alpha: 0.05)
        self.calendar.appearance.headerTitleFont    = UIFont(name: "Poppins-Regular", size: 14)
        self.calendar.appearance.weekdayFont        = UIFont(name: "Poppins-Regular", size: 14)
        self.calendar.appearance.titleFont          = UIFont(name: "Poppins-Regular", size: 14)
        self.confirmButton.backgroundColor = UIColor(named: "blue")?.withAlphaComponent(0.5)
        self.confirmButton.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nextBtnConfig()
        self.previousBtnConfig()
        
    }
    func nextBtnConfig() {
        let indexPath = self.calendar.calculator.indexPath(for: self.calendar.currentPage, scope: .month)
        let startDate = self.calendar.calculator.monthHead(forSection: (indexPath?.section)!)!
        let middleDate = self.calendar.gregorian.date(byAdding: .day, value: 10, to: startDate)
        var currentDate = Date()
        var currentMonth = Calendar.current.component(.month, from: currentDate)
        var currentYear = Calendar.current.component(.year, from: Date())
        if firstDate != nil {
            currentDate = Calendar.current.date(byAdding: .day, value: +89, to:firstDate ?? Date())!
            let maxMonth = Calendar.current.component(.month, from: Date())
            let maxYear = Calendar.current.component(.year, from: Date())
            currentMonth = Calendar.current.component(.month, from: currentDate)
            currentYear = Calendar.current.component(.year, from: currentDate)
            if maxMonth < currentMonth || maxYear < currentYear {
                currentMonth = Calendar.current.component(.month, from: Date())
                currentYear = Calendar.current.component(.year, from: Date())
            }
        }
        let calenderMonth = Calendar.current.component(.month, from: middleDate!)
        let calenderYear = Calendar.current.component(.year, from: middleDate!)
        
        //NextBtn
        if currentYear == calenderYear && currentMonth == calenderMonth {
            self.nextBtn.alpha = 0.3
            self.nextBtn.isUserInteractionEnabled = false
        }else{
            self.nextBtn.alpha = 1
            self.nextBtn.isUserInteractionEnabled = true
        }
    }
    func previousBtnConfig() {
        let indexPath = self.calendar.calculator.indexPath(for: self.calendar.currentPage, scope: .month)
        let startDate = self.calendar.calculator.monthHead(forSection: (indexPath?.section)!)!
        let middleDate = self.calendar.gregorian.date(byAdding: .day, value: 10, to: startDate)
        let minimumDate = firstDate ?? Date()//Calendar.current.date(byAdding: .day, value: +89, to:firstDate ?? Date())!
        let minimumMonth = Calendar.current.component(.month, from: minimumDate)
        let calenderMonth = Calendar.current.component(.month, from: middleDate!)
        if isRestrict {
                    if minimumMonth == calenderMonth {
                        self.prevBtn.alpha = 0.3
                        self.prevBtn.isUserInteractionEnabled = false
                    }else{
                        self.prevBtn.alpha = 1
                        self.prevBtn.isUserInteractionEnabled = true
                    }

        }
        else{
            self.prevBtn.alpha = 1
            self.prevBtn.isUserInteractionEnabled = true

        }
    }
    
    func isDateEnabled(date: Date) -> Bool {
        // Implement the logic to determine if the date should be enabled or disabled
        // In this case, all dates are enabled, so return true
        return true
    }
    
    
    func updateMonthLabel() {
//        let currentDate = calender.date(byAdding: .month, value: currentMonthIndex, to: Date())!
        let currentDate = calendar.currentPage

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let monthString = dateFormatter.string(from: currentDate)
        monthTitle.text = monthString
    }
    
    @IBAction func prevClicked(_ sender: Any) {
        
        calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
        currentMonthIndex -= 1
        updateMonthLabel()
        
        let indexPath = self.calendar.calculator.indexPath(for: self.calendar.currentPage, scope: .month)
        let startDate = self.calendar.calculator.monthHead(forSection: (indexPath?.section)!)!
        let middleDate = self.calendar.gregorian.date(byAdding: .day, value: 10, to: startDate)
        let currentMonth = Calendar.current.component(.month, from: Date())
        let calenderMonth = Calendar.current.component(.month, from: middleDate!)
        let currentYear = Calendar.current.component(.year, from: Date())
        let calenderYear = Calendar.current.component(.year, from: middleDate!)
        
//        if currentYear == calenderYear && currentMonth == calenderMonth {
//            self.nextBtn.alpha = 0.3
//            self.nextBtn.isUserInteractionEnabled = false
//
//        }else{
//            self.nextBtn.alpha = 1
//            self.nextBtn.isUserInteractionEnabled = true
//
//        }
        self.nextBtnConfig()
        self.previousBtnConfig()
    }
    
    
    @IBAction func nextClicked(_ sender: Any) {
        let indexPath = self.calendar.calculator.indexPath(for: self.calendar.currentPage, scope: .month)
        let startDate = self.calendar.calculator.monthHead(forSection: (indexPath?.section)!)!
        let middleDate = self.calendar.gregorian.date(byAdding: .day, value: 10, to: startDate)
        var currentDate = Date()
        var currentYear = Calendar.current.component(.year, from: Date())
        var currentMonth = Calendar.current.component(.month, from: currentDate)

        if firstDate != nil {
            currentDate = Calendar.current.date(byAdding: .day, value: +89, to:firstDate ?? Date())!
            var maxMonth = Calendar.current.component(.month, from: Date())
            var maxYear = Calendar.current.component(.year, from: Date())

            currentMonth = Calendar.current.component(.month, from: currentDate)
            currentYear = Calendar.current.component(.year, from: currentDate )
            if maxMonth < currentMonth || maxYear < currentYear {
                currentMonth = Calendar.current.component(.month, from: Date())
                currentYear = Calendar.current.component(.year, from: Date())
            }
        }

        let calenderMonth = Calendar.current.component(.month, from: middleDate!)
        let calenderYear = Calendar.current.component(.year, from: middleDate!)
        
        if currentYear == calenderYear && currentMonth == calenderMonth + 1 {
            self.nextBtn.alpha = 0.3
            self.nextBtn.isUserInteractionEnabled = false
        }else{
            self.nextBtn.alpha = 1
            self.nextBtn.isUserInteractionEnabled = true
        }
        
        if !(currentYear == calenderYear && currentMonth == calenderMonth) {
            calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
            currentMonthIndex += 1
            updateMonthLabel()
        }
        self.previousBtnConfig()
    }
    
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    
    func getPreviousMonth(date:Date)->Date {
        
        
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        removeAnimate()
//    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        
        guard let startDate = firstDate else {
            return
        }
        
        let dateFormatter = DateFormatter()
        if isForSweepIn {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }else {
            dateFormatter.dateFormat = "yyyy-MM-dd"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
        }
        let fromDateString = dateFormatter.string(from: startDate)
        
        if let endDate = lastDate {
            let toDateString = dateFormatter.string(from: endDate)
            dateSelectionHandler?(fromDateString, endDate)
        } else {
            dateSelectionHandler?(fromDateString, startDate) // Pass the first date only
        }
        
        removeAnimate()
    }
    
}
extension CalenderViewController {
    
    func configureVisibleCells() {
        self.calendar.visibleCells().forEach { (cell) in
            let date = self.calendar.date(for: cell)
            let position = self.calendar.monthPosition(for: cell)
            self.configureCell(cell, for: date, at: position)
        }
    }
    
    
    func configureCell(_ cell: FSCalendarCell?, for date: Date?, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        diyCell.borderColor = UIColor(displayP3Red: 0, green: 14, blue: 51, alpha: 0.05)
        diyCell.borderWidth = 1
        diyCell.cornerRadius = 6
        diyCell.selectionType = .none
        if position == .current {
            if let date = date {
                
                if calendar.selectedDates.contains(date) {
                    print("Date: \(date) && selectedDates: \(calendar.selectedDates)")
                    var selectionType = SelectionType.none
                    let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                    let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        diyCell.selectionLayer.fillColor = highlightedColorForRange.cgColor
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .single // .rightBorder
                        diyCell.titleLabel.textColor = .white
                        diyCell.selectionLayer.fillColor = selectedColor.cgColor
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .single // .leftBorder
                        diyCell.titleLabel.textColor = .white
                        diyCell.selectionLayer.fillColor = selectedColor.cgColor
                    }
                    else{
                        selectionType = .single //.single
                        diyCell.titleLabel.textColor = .white
                        diyCell.selectionLayer.fillColor = selectedColor.cgColor
                    }
                    
                    if selectionType == .none {
                        diyCell.selectionLayer.isHidden = true
                        return
                    }
                    diyCell.selectionLayer.isHidden = false
                    diyCell.selectionType = selectionType
                }else{
                    diyCell.selectionType = .none
                    diyCell.selectionLayer.isHidden = true
                    if date.removeTimeStamp!.compare(Date().removeTimeStamp!) == .orderedDescending{
                        let weekday = Calendar.current.component(.weekday, from: date)
                        if weekday == 1
                        {
                            cell?.titleLabel.textColor = UIColor.red.withAlphaComponent(0.3)
                        }else{
                            cell?.titleLabel.textColor = UIColor.black.withAlphaComponent(0.3)
                        }
                    }
                    else if date.removeTimeStamp!.compare(Calendar.current.date(byAdding: .day, value: +89, to:firstDate ?? Date())!.removeTimeStamp!) == .orderedDescending {
                        if isRestrict {

                            let weekday = Calendar.current.component(.weekday, from: date)
                            if weekday == 1
                            {
                                cell?.titleLabel.textColor = UIColor.red.withAlphaComponent(0.3)
                            }else{
                                cell?.titleLabel.textColor = UIColor.black.withAlphaComponent(0.3)
                            }
                        }
                    }
                    else if firstDate != nil {
                        if date.removeTimeStamp!.compare(firstDate!.removeTimeStamp!) == .orderedAscending {
                            if isRestrict {
                                let weekday = Calendar.current.component(.weekday, from: date)
                                if weekday == 1
                                {
                                    cell?.titleLabel.textColor = UIColor.red.withAlphaComponent(0.3)
                                }else{
                                    cell?.titleLabel.textColor = UIColor.black.withAlphaComponent(0.3)
                                }
                            }
                        }
                    }
                    else{
                        let weekday = Calendar.current.component(.weekday, from: date)
                        if weekday == 1
                        {
                            cell?.titleLabel.textColor = UIColor.red
                        }else{
                            cell?.titleLabel.textColor = UIColor.black
                        }
                    }
                }
            }
        }else{
//            if let date = date {
//                if date.removeTimeStamp!.compare(Calendar.current.date(byAdding: .day, value: +89, to:firstDate ?? Date())!.removeTimeStamp!) == .orderedAscending {
//                    if isRestrict {
//                        let weekday = Calendar.current.component(.weekday, from: date)
//                        if weekday == 1
//                        {
//                            cell?.titleLabel.textColor = UIColor.red.withAlphaComponent(0.3)
//                        }else{
//                            cell?.titleLabel.textColor = UIColor.black.withAlphaComponent(0.3)
//                        }
//                    }
//                }
//            }
//            else{
                diyCell.selectionLayer.isHidden = true
                cell?.titleLabel.textColor = UIColor.black.withAlphaComponent(0.3)//UIColor.lightGray
//            }
        }}
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        
        if from > to { return [Date]() }
        
        var tempDate = from + 1
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate - 1)!
            array.append(tempDate)
        }
        
        return array
    }
    
}

extension CalenderViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    
    /*  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
     self.calendar.frame.size.height = bounds.height
     }*/
    func configureDateCell(cell: FSCalendarCell, date: Date, enabled: Bool) {
        // Configure the appearance of the date cell here
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let cellMonth = calendar.component(.month, from: date)
        
        // Set the text color based on whether the cell date belongs to the current month or not
        if cellMonth == currentMonth {
            cell.titleLabel.textColor = UIColor.black
        } else {
            cell.titleLabel.textColor = UIColor.blue
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1
        {
            return weekendTextColor
        }
        return UIColor.black
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 6.0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return UIColor.black
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate != nil {
//            if date.removeTimeStamp!.compare(firstDate ?? Date().removeTimeStamp!) == .orderedDescending {
//                calendar.deselect(date)
//                self.configureVisibleCells()
//                return
//            }
//            else {
                let minimumMonth = Calendar.current.component(.month, from: firstDate ?? Date())
                let current = Calendar.current.component(.month, from: date)
                if minimumMonth > current {
                    calendar.deselect(date)
                    self.configureVisibleCells()
                    return
                }
                else if minimumMonth == current {
                    if date.removeTimeStamp!.compare(firstDate ?? Date().removeTimeStamp!) == .orderedAscending {
                        calendar.deselect(date)
                        self.configureVisibleCells()
                        return
                    }
                }
//            }
        }
       

        self.confirmButton.backgroundColor = UIColor.init(named: "blue")
             self.confirmButton.isEnabled = true
        formatter.dateFormat = "dd-MMM-yyyy"
        
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            isRestrict = true
            self.configureVisibleCells()
            self.previousBtnConfig()
            self.nextBtnConfig()
            datesRange = [firstDate!]
            print("datesRange contains: \(datesRange!)")
            
            configureVisibleCells()
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                
                datesRange = [firstDate!]
                
                print("datesRange contains: \(datesRange!)")
                
                configureVisibleCells()
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            
            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
            print("datesRange contains: \(datesRange!)")
            let value =  firstDate!
            let value2 =  lastDate!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            
            let fromDate = dateFormatter.string(from: value)
            let toDate = dateFormatter.string(from: value2)
            
            configureVisibleCells()
            return
        }
        
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            self.confirmButton.backgroundColor = UIColor(named: "blue")?.withAlphaComponent(0.5)
            self.confirmButton.isEnabled = false
            self.previousBtnConfig()
            self.nextBtnConfig()
            datesRange = []
            
            print("datesRange contains: \(datesRange!)")
            
        }
        configureVisibleCells()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        
        
        let currentDate = Date()
                if calendar.currentPage > currentDate {
                    calendar.setCurrentPage(currentDate, animated: true)
                    // Optionally, show an alert to inform the user that sliding to future months is disabled
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM yyyy"
                    let date = calendar.currentPage
                    let monthYearString = dateFormatter.string(from: date)
                    monthTitle.text = monthYearString
                }
        
        
    }
    func calendar(_ calendar: FSCalendar, titleForMonth month: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let date = calendar.currentPage
        return dateFormatter.string(from: date)
    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureCell(cell, for: date, at: monthPosition)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date <= Date()
        // return monthPosition == FSCalendarMonthPosition.current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did deselect date \(self.formatter.string(from: date))")
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, cellSizeFor date: Date) -> CGSize {
        return CGSize(width: 35.3, height: 34) // Set your desired cell size here
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, shadowColorFor date: Date) -> UIColor? {
        return  UIColor(displayP3Red: 0, green: 14, blue: 51, alpha: 0.05)
        
    }
    private func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, shadowOffsetFor date: Date) -> CGSize {
        return CGSize(width: 35.3, height: 34) // Set the shadow offset of the cells
    }
    
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return CalendarMinDate//Calendar.current.date(byAdding: .day, value: -89, to:Date())!
//    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
            return Date()
    }
    
}

extension Date {

    public var removeTimeStamp : Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
         return nil
        }
        return date
    }
}
public var selectedColor = UIColor.init(red: 26/255, green: 66/255, blue: 155/255, alpha: 1)

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}
class DIYCalendarCell: FSCalendarCell {

    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    weak var roundedLayer: CAShapeLayer!
    
    
    
    var selectionType: SelectionType = .none {
        didSet {
           setNeedsLayout()
        }
    }
  

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.frame = CGRect(x: 0, y: 0, width: 35.3, height: 34)
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = selectedColor.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
      
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        self.backgroundView = view;

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
     
        if selectionType == .middle {
         
            let path = UIBezierPath(rect: self.selectionLayer.bounds)
             
                  self.selectionLayer.path = path.cgPath
      
                  // Add rounded corners to the start and end of the row
                  
                  let cornerRadius: CGFloat = self.selectionLayer.frame.height/6
                  
                  if self.frame.minX == self.superview?.subviews.first?.frame.minX {
                      let maskLayer = CAShapeLayer()
                      maskLayer.frame = self.bounds
                      maskLayer.path = UIBezierPath(roundedRect: maskLayer.bounds, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
                      self.layer.mask = maskLayer
                  } else if self.frame.maxX == self.superview?.subviews.last?.frame.maxX {
                      let maskLayer = CAShapeLayer()
                      maskLayer.frame = self.bounds
                      maskLayer.path = UIBezierPath(roundedRect: maskLayer.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
                      self.layer.mask = maskLayer
                  }else {
                    self.layer.mask = nil
                }
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 6, height: self.selectionLayer.frame.width / 6)).cgPath
           
            
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 6, height: self.selectionLayer.frame.width / 6)).cgPath
        }
        else if selectionType == .single {
        
            let path = UIBezierPath(roundedRect: self.selectionLayer.bounds, cornerRadius: self.selectionLayer.bounds.size.height/6)
            self.selectionLayer.path = path.cgPath
          
        }
    }

    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.black
        }
    }
}
