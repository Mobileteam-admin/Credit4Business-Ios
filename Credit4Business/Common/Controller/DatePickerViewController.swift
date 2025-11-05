//
//  DatePickerViewController.swift
//  Credit4Business
//
//  Created by MacMini on 16/04/24.
//

import UIKit

class DatePickerViewController: UIViewController {
    var dateSelectionHandler: ((String, Date) -> Void)?

    @IBOutlet weak var view2: UIView!
    var isReadableFormat = false
    var isForLeaseHold = false

    var isRestrictToday = false
    var goback60 = false
    var stayMaxDate: Date?

    var fromDate: Date?
    var selectedDate: Date?
    var stayCollectionRestriction = false
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.locale = .current
//        datePicker.date = Date()
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .compact
            } else {
                // Fallback on earlier versions
            }
        }
        datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
        if self.goback60 {
            let minimumDate = Calendar.current.date(byAdding: .day, value: -60, to:Date())!
            datePicker.maximumDate = minimumDate
            datePicker.date = self.selectedDate ?? Date()

        }
        else if self.stayCollectionRestriction ?? false {
            datePicker.maximumDate = stayMaxDate ?? Date()
        }
        else {
            if fromDate != nil {
                datePicker.minimumDate = fromDate
                let maximumDate = Calendar.current.date(byAdding: .day, value: 89, to:fromDate!)!
                if maximumDate.compare(Date()) == .orderedAscending || maximumDate.compare(Date()) == .orderedSame {
                    datePicker.maximumDate = maximumDate
                }else{
                    datePicker.maximumDate = Date()
                }
            }
            else {
                if !self.isForLeaseHold {
                    datePicker.maximumDate = Date()
                }
            }
            datePicker.date = self.selectedDate ?? Date()

        }
        view2.addSubview(datePicker)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.61)

    }
    

    @objc func dateSelected() {
//        print(datePicker.date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
//        let fromDateString = dateFormatter.string(from: datePicker.date)
//        dateSelectionHandler?(fromDateString, fromDateString)
    }

    @IBAction func confirmClicked(_ sender: Any) {
        let dateFormatter = DateFormatter()
        if isReadableFormat {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }else {
            dateFormatter.dateFormat = "yyyy-MM-dd"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
        }
        let fromDateString = dateFormatter.string(from: datePicker.date)
        dateSelectionHandler?(fromDateString, datePicker.date)
        self.dismiss(animated: true)
    }
}
