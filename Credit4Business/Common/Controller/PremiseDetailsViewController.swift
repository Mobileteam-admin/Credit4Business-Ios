//
//  PremiseDetailsViewController.swift
//  Credit4Business
//
//  Created by MacMini on 14/03/24.
//

import UIKit
import StepProgressBar
import IQKeyboardManagerSwift
import Photos
import MobileCoreServices
import UniformTypeIdentifiers

class PremiseDetailsViewController: BaseViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var regAddress1TF: UITextField!
    @IBOutlet weak var regAddress1ErrLabel: UILabel!
    @IBOutlet weak var regAddress1ErrStack: UIStackView!
    
    @IBOutlet weak var regAddress2TF: UITextField!
    @IBOutlet weak var regAddress2ErrLabel: UILabel!
    @IBOutlet weak var regAddress2ErrStack: UIStackView!

    @IBOutlet weak var regCityTF: UITextField!
    @IBOutlet weak var regCityErrLabel: UILabel!
    @IBOutlet weak var regCityErrStack: UIStackView!

    @IBOutlet weak var regPostView: UITextField!
    @IBOutlet weak var regPostTF: UITextField!
    @IBOutlet weak var regPostTableHeight: NSLayoutConstraint!
    @IBOutlet weak var regPostTable: UITableView!
    @IBOutlet weak var regPostTableArrowActionView: UIView!
    @IBOutlet weak var regPostTableArrow: UIImageView!
    @IBOutlet weak var regPostErrLabel: UILabel!
    @IBOutlet weak var regPostErrStack: UIStackView!
    
    @IBOutlet weak var regPremiseTypeView: UITextField!
    @IBOutlet weak var regPremiseTypeTF: UITextField!
    @IBOutlet weak var regPremiseTypeTableHeight: NSLayoutConstraint!
    @IBOutlet weak var regPremiseTypeTable: UITableView!
    @IBOutlet weak var regPremiseTypeTableArrowActionView: UIView!
    @IBOutlet weak var regPremiseTypeTableArrow: UIImageView!
    @IBOutlet weak var regPremiseTypeErrLabel: UILabel!
    @IBOutlet weak var regPremiseTypeErrStack: UIStackView!

    @IBOutlet weak var traLeaseLabelView: UIView!
    @IBOutlet weak var regLeaseLabelView: UIView!
    
    @IBOutlet weak var TraAddress1TF: UITextField!
    @IBOutlet weak var TraAddress1ErrLabel: UILabel!
    @IBOutlet weak var TraAddress1ErrStack: UIStackView!

    @IBOutlet weak var TraAddress2TF: UITextField!
    @IBOutlet weak var TraAddress2ErrLabel: UILabel!
    @IBOutlet weak var TraAddress2ErrStack: UIStackView!

    @IBOutlet weak var TraCityTF: UITextField!
    @IBOutlet weak var TraCityErrLabel: UILabel!
    @IBOutlet weak var TraCityErrStack: UIStackView!

    @IBOutlet weak var TraPostView: UITextField!
    @IBOutlet weak var TraPostTF: UITextField!
    @IBOutlet weak var TraPostTableHeight: NSLayoutConstraint!
    @IBOutlet weak var TraPostTable: UITableView!
    @IBOutlet weak var TraPostTableArrowActionView: UIView!
    @IBOutlet weak var TraPostTableArrow: UIImageView!
    @IBOutlet weak var TraPostErrLabel: UILabel!
    @IBOutlet weak var TraPostErrStack: UIStackView!
    
    @IBOutlet weak var TraPremiseTypeView: UITextField!
    @IBOutlet weak var TraPremiseTypeTF: UITextField!
    @IBOutlet weak var TraPremiseTypeTableHeight: NSLayoutConstraint!
    @IBOutlet weak var TraPremiseTypeTable: UITableView!
    @IBOutlet weak var TraPremiseTypeTableArrowActionView: UIView!
    @IBOutlet weak var TraPremiseTypeTableArrow: UIImageView!
    @IBOutlet weak var TraPremiseTypeErrLabel: UILabel!
    @IBOutlet weak var TraPremiseTypeErrStack: UIStackView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var regLeaseStartDateTF: UITextField!
    @IBOutlet weak var regLeaseStartDateView: UIView!
    @IBOutlet weak var regLeaseEndDateTF: UITextField!
    @IBOutlet weak var regLeaseEndDateView: UIView!
    @IBOutlet weak var regLeaseErrLabel: UILabel!
    @IBOutlet weak var regLeaseErrStack: UIStackView!
    
    @IBOutlet weak var regLeaseDateStack: UIStackView!
    @IBOutlet weak var traLeaseDateStack: UIStackView!

    @IBOutlet weak var TraAddressLine1Stack: UIStackView!
    @IBOutlet weak var TraAddressLine2Stack: UIStackView!
    @IBOutlet weak var TraCityStack: UIStackView!
    @IBOutlet weak var TraPostStack: UIStackView!
    @IBOutlet weak var TraPremiseStack: UIStackView!

    @IBOutlet weak var tradingAddressImage: UIImageView!
    @IBOutlet weak var tradingAddressActionView: UIView!
    
    @IBOutlet weak var traLeaseStartDateTF: UITextField!
    @IBOutlet weak var traLeaseStartDateView: UIView!
    @IBOutlet weak var traLeaseEndDateTF: UITextField!
    @IBOutlet weak var traLeaseEndDateView: UIView!
    @IBOutlet weak var traLeaseDateErrLabel: UILabel!
    @IBOutlet weak var traLeaseDateErrStack: UIStackView!
    
    @IBOutlet weak var tradingFileUploadStack: UIView!
    @IBOutlet weak var tradingFileUploadView: UIView!
    @IBOutlet weak var tradingFileUploadLabel: UILabel!
    @IBOutlet weak var tradingFileUploadImage: UIImageView!
    @IBOutlet weak var tradingFileUploadErrLabel: UILabel!
    @IBOutlet weak var tradingFileUploadErrStack: UIStackView!
    
    @IBOutlet weak var registeringFileUploadStack: UIView!
    @IBOutlet weak var registeringFileUploadView: UIView!
    @IBOutlet weak var registeringFileUploadLabel: UILabel!
    @IBOutlet weak var registeringFileUploadErrLabel: UILabel!
    @IBOutlet weak var registeringFileUploadErrStack: UIStackView!
    @IBOutlet weak var registeringFileUploadImage: UIImageView!
    @IBOutlet weak var commentButton: UIImageView!
    @IBOutlet weak var pageControl: CustomPageControl!

    //MARK: -------------------- Class Variable --------------------

    var regPostTableHidden = true
    var regPremiseTypeTableHidden = true
    var traPostTableHidden = true
    var traPremiseTypeTableHidden = true
    var dropdownType : DropDownType = .none
    var viewModel = HomeVM()
    var selectedRegPostCode : String?
    var selectedRegPremiseType : Common?
    var selectedTraPostCode : String?
    var selectedTraPremiseType : Common?
    var selectedTradingAddress : Bool = false
    var tradingFileUploadStr = ""
    var tradingFileUploadData : Data?

    var registeringFileUploadStr = ""
    var registeringFileUploadData : Data?
    var registeringFileSelectedStr = ""
    var tradingFileSelectedStr = ""
    var isTradingFileUpload = false
    var regLeaseStartDate : Date?
    var regLeaseEndDate : Date?
    var traLeaseStartDate : Date?
    var traLeaseEndDate : Date?
    var selectedPremiseResponse : PremiseDataClass?
    var customerId = ""
    var delegate : CellDelegate?
    var loanId = ""
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.updateUI()
        self.manageActionMethods()
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.isEnabled = true
        if UserDefaults.standard.value(forKey: "role") as? String != "" && isFromIncomplete {
            self.fetchPremiseDetails()
        }
        if self.selectedPremiseResponse != nil {
            self.showModelValues()
        }
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }
   //---------------------------------------
   // MARK: - Init With Story
   //---------------------------------------

   class func initWithStory(loanId: String) -> PremiseDetailsViewController {
       let vc : PremiseDetailsViewController = UIStoryboard.Main.instantiateViewController()
       vc.loanId = loanId
       return vc
   }
    
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.regPostTable.delegate = self
        self.regPostTable.dataSource = self
        self.regPremiseTypeTable.delegate = self
        self.regPremiseTypeTable.dataSource = self
        self.TraPostTable.delegate = self
        self.TraPostTable.dataSource = self
        self.TraPremiseTypeTable.delegate = self
        self.TraPremiseTypeTable.dataSource = self

        self.regAddress1TF.delegate = self
        self.regAddress2TF.delegate = self
        self.regCityTF.delegate = self
        self.TraAddress1TF.delegate = self
        self.TraAddress2TF.delegate = self
        self.TraCityTF.delegate = self
        self.regPostTF.delegate = self
        self.TraPostTF.delegate = self
    }
    func updateUI()
    {
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
//        self.regLeaseStartDateTF.placeholder = dateFormatter.string(from: date )
//        self.regLeaseEndDateTF.placeholder = dateFormatter.string(from: date )
//        self.traLeaseStartDateTF.placeholder = dateFormatter.string(from: date )
//        self.traLeaseEndDateTF.placeholder = dateFormatter.string(from: date )
        self.traLeaseDateStack.isHidden = true
        self.regLeaseDateStack.isHidden = true
        self.regLeaseLabelView.isHidden = true
        self.traLeaseLabelView.isHidden = true
        self.tradingFileUploadStack.isHidden = true
        self.registeringFileUploadStack.isHidden = true
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 2)

    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }
    func manageActionMethods() {
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanId)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
//        self.regPostTableArrowActionView.addTapGestureRecognizer {
//            self.dropdownType = .RegPost
//            self.regPostTableHidden = !self.regPostTableHidden
//            self.showHideTable()
//        }
//        self.regPostTF.addTapGestureRecognizer {
//            self.dropdownType = .RegPost
//            self.regPostTableHidden = !self.regPostTableHidden
//            self.showHideTable()
//        }
        self.regPremiseTypeTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .RegPremise
            self.regPremiseTypeTableHidden = !self.regPremiseTypeTableHidden
            self.showHideTable()
        }
        self.regPremiseTypeTF.addTapGestureRecognizer {
            self.dropdownType = .RegPremise
            self.regPremiseTypeTableHidden = !self.regPremiseTypeTableHidden
            self.showHideTable()
        }
//        self.TraPostTableArrowActionView.addTapGestureRecognizer {
//            self.dropdownType = .TraPost
//            self.traPostTableHidden = !self.traPostTableHidden
//            self.showHideTable()
//        }
//        self.TraPostTF.addTapGestureRecognizer {
//            self.dropdownType = .TraPost
//            self.traPostTableHidden = !self.traPostTableHidden
//            self.showHideTable()
//        }
        self.TraPremiseTypeTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .TraPremise
            self.traPremiseTypeTableHidden = !self.traPremiseTypeTableHidden
            self.showHideTable()
        }
        self.TraPremiseTypeTF.addTapGestureRecognizer {
            self.dropdownType = .TraPremise
            self.traPremiseTypeTableHidden = !self.traPremiseTypeTableHidden
            self.showHideTable()
        }
        self.regLeaseStartDateTF.addTapGestureRecognizer {
            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                 popup.modalPresentationStyle = .overFullScreen
                 popup.isReadableFormat = true
                popup.isForLeaseHold = true
                 self.present(popup, animated: true, completion: nil)
                 popup.dateSelectionHandler = { [weak self] fromDate, toDate in
                     print(fromDate)
                     self?.regLeaseStartDateTF.text = fromDate
                     self?.regLeaseStartDate = toDate
                     self?.dismiss(animated: true)
                     self?.regLeaseErrStack.isHidden = true
                 }
            }
        self.regLeaseEndDateTF.addTapGestureRecognizer {
            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                 popup.modalPresentationStyle = .overFullScreen
                 popup.isReadableFormat = true
            popup.isForLeaseHold = true

                 self.present(popup, animated: true, completion: nil)
                 popup.dateSelectionHandler = { [weak self] fromDate, DateObj in
                     print(fromDate)
                     if self?.regLeaseStartDate?.compare(DateObj ) == .orderedAscending {
                     }else if self?.regLeaseStartDate?.compare(DateObj ) == .orderedSame {
                     }else{
                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                             self?.showAlert(title: "Info", message: "Start date should be earlier than End Date")
                         }
                         self?.dismiss(animated: true)
                         self?.regLeaseEndDateTF.text = ""
                         return
                     }
                     self?.regLeaseEndDateTF.text = fromDate
                     self?.regLeaseEndDate = DateObj
                     self?.dismiss(animated: true)
                     self?.regLeaseErrStack.isHidden = true
                 }
            }
        self.traLeaseStartDateTF.addTapGestureRecognizer {
            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                 popup.modalPresentationStyle = .overFullScreen
                 popup.isReadableFormat = true
            popup.isForLeaseHold = true

                 self.present(popup, animated: true, completion: nil)
                 popup.dateSelectionHandler = { [weak self] fromDate, toDate in
                     print(fromDate)
                     self?.traLeaseStartDateTF.text = fromDate
                     self?.traLeaseStartDate = toDate
                     self?.dismiss(animated: true)
                     self?.traLeaseDateErrStack.isHidden = true
                 }
            }
        self.traLeaseEndDateTF.addTapGestureRecognizer {
            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                 popup.modalPresentationStyle = .overFullScreen
                 popup.isReadableFormat = true
            popup.isForLeaseHold = true

                 self.present(popup, animated: true, completion: nil)
                 popup.dateSelectionHandler = { [weak self] fromDate, DateObj in
                     print(fromDate)
                     if self?.traLeaseStartDate?.compare(DateObj ) == .orderedAscending {
                     }else if self?.traLeaseStartDate?.compare(DateObj ) == .orderedSame {
                     }else{
                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                             self?.showAlert(title: "Info", message: "Start date should be earlier than End Date")
                         }
                         self?.traLeaseEndDateTF.text = ""
                         self?.dismiss(animated: true)
                         return
                     }
                     self?.traLeaseEndDateTF.text = fromDate
                     self?.traLeaseEndDate = DateObj
                     self?.dismiss(animated: true)
                     self?.traLeaseDateErrStack.isHidden = true
                 }
            }
        self.tradingAddressActionView.addTapGestureRecognizer {
            self.selectedTradingAddress = !self.selectedTradingAddress
            self.tradingAddressImage.image = self.selectedTradingAddress ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
            self.TraPremiseStack.isHidden = false //self.selectedTradingAddress
//            self.TraCityStack.isHidden = self.selectedTradingAddress
            self.TraPostStack.isHidden = false //self.selectedTradingAddress
            self.TraAddressLine1Stack.isHidden = false //self.selectedTradingAddress
            
            self.traLeaseDateStack.isHidden =  self.selectedTraPremiseType?.description == "Leasehold" ? (self.selectedTradingAddress ? false : true) : true
            self.traLeaseLabelView.isHidden = self.selectedTraPremiseType?.description == "Leasehold" ? (self.selectedTradingAddress ? false : true) : true
            self.tradingFileUploadStack.isHidden = self.selectedTraPremiseType?.description == "Leasehold" ? (self.selectedTradingAddress ? false : true) : true
//            self.TraAddressLine2Stack.isHidden = self.selectedTradingAddress
            if self.selectedTradingAddress {
                self.TraAddress1ErrStack.isHidden = true
                self.TraAddress2ErrStack.isHidden = true
                self.TraCityErrStack.isHidden = true
                self.TraPostErrStack.isHidden = true
                self.TraPremiseTypeErrStack.isHidden = true
                self.traLeaseDateStack.isHidden = true
                self.traLeaseLabelView.isHidden = true
                self.tradingFileUploadStack.isHidden = true
                self.TraAddress1TF.text = self.regAddress1TF.text
                self.TraPostTF.text = self.regPostTF.text

            }
        }
        self.tradingFileUploadView.addTapGestureRecognizer {
            self.isTradingFileUpload = true
            self.redirectToImageChooseVC()
        }
        self.tradingFileUploadLabel.addTapGestureRecognizer {
            self.isTradingFileUpload = true
            self.redirectToImageChooseVC()
        }
        self.registeringFileUploadView.addTapGestureRecognizer {
            self.isTradingFileUpload = false
            self.redirectToImageChooseVC()
        }
        self.registeringFileUploadLabel.addTapGestureRecognizer {
            self.isTradingFileUpload = false
            self.redirectToImageChooseVC()
        }
        self.skipButton.addTapGestureRecognizer {
            if self.delegate != nil {
                self.delegate?.reload()
                self.dismiss(animated: true)
            }else{
                var vc = DirectorDetailsViewController.initWithStory(loanId: self.loanId)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.nextButton.addTapGestureRecognizer {
            self.checkLoanStatus(loanId: self.loanId)
            if (canEditForms && GlobalmodeOfApplication != .Representative) || self.delegate != nil {
                self.isValidTextFields()
                if self.goNext() {
                    print("go next")
                    self.updateModel()
//                    var vc = DirectorDetailsViewController.initWithStory()
//                    self.navigationController?.pushViewController(vc, animated: true)
                }}else{
//                    self.updateModel()
//
                    var vc = DirectorDetailsViewController.initWithStory(loanId: self.loanId)
                self.navigationController?.pushViewController(vc, animated: true)
                }
        }
        self.backButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func fetchPremiseDetails() {
        APIService.shared.retrievePremiseFormDetails(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedPremiseResponse = responseData
                        self.showModelValues()
                    }
                    catch {
                    }
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func showModelValues() {
        guard let initial = self.selectedPremiseResponse else {return}
        var registeredAddress = initial.registeredAddress
        var tradingAddress = initial.tradingAddress
        var isSameForTrade = initial.tradingSameAsRegistered
        if isSameForTrade {
           // tradingAddress = registeredAddress
            self.selectedTradingAddress = true
            self.TraPremiseStack.isHidden = false//self.selectedTradingAddress
//            self.TraCityStack.isHidden = self.selectedTradingAddress
            self.TraPostStack.isHidden = false //self.selectedTradingAddress
            self.TraAddressLine1Stack.isHidden = false //self.selectedTradingAddress
//            self.TraAddressLine2Stack.isHidden = self.selectedTradingAddress
            if self.selectedTradingAddress {
                self.TraAddress1ErrStack.isHidden = true
                self.TraAddress2ErrStack.isHidden = true
                self.TraCityErrStack.isHidden = true
                self.TraPostErrStack.isHidden = true
                self.TraPremiseTypeErrStack.isHidden = true
            }

        }
        self.tradingAddressImage.image = self.selectedTradingAddress ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")

        self.regAddress1TF.text = registeredAddress?.addressLine1
        self.regPostTF.text = registeredAddress?.postCode
        self.regPremiseTypeTF.text = registeredAddress?.premiseType
        self.selectedRegPremiseType = self.viewModel.regpremiseTypeArray.filter({$0.description == registeredAddress?.premiseType}).first
        if self.selectedRegPremiseType?.description == "Leasehold" {
            self.regLeaseDateStack.isHidden = false
            self.regLeaseLabelView.isHidden = false
            self.registeringFileUploadStack.isHidden = false
        }else{
            self.regLeaseDateStack.isHidden = true
            self.regLeaseLabelView.isHidden = true
            self.registeringFileUploadStack.isHidden = true
        }
        self.regLeaseStartDateTF.text =  registeredAddress?.leasehold?.startDate
        self.regLeaseEndDateTF.text =  registeredAddress?.leasehold?.endDate
        self.registeringFileSelectedStr = registeredAddress?.leasehold?.document ?? ""
        if self.registeringFileSelectedStr != "" {
            var url = URL(string: self.registeringFileSelectedStr)
            let document = url?.lastPathComponent.components(separatedBy: ".")
            let fileName = URL(fileURLWithPath: self.registeringFileSelectedStr).deletingPathExtension().lastPathComponent
            let fileType = url?.pathExtension ?? ""
            self.registeringFileUploadLabel.text = fileName + "." + fileType
        }
      

       // if !isSameForTrade {
            self.TraAddress1TF.text = tradingAddress?.addressLine1
            self.TraPostTF.text = tradingAddress?.postCode
            self.TraPremiseTypeTF.text = tradingAddress?.premiseType
            self.selectedTraPremiseType = self.viewModel.tradingpremiseTypeArray.filter({$0.description == tradingAddress?.premiseType}).first
            if self.selectedTraPremiseType?.description == "Leasehold" {
                self.traLeaseDateStack.isHidden = false
                self.traLeaseLabelView.isHidden = false
                self.tradingFileUploadStack.isHidden = false
            }else{
                self.traLeaseDateStack.isHidden = true
                self.traLeaseLabelView.isHidden = true
                self.tradingFileUploadStack.isHidden = true
            }
            self.traLeaseStartDateTF.text =  tradingAddress?.leasehold?.startDate
            self.traLeaseEndDateTF.text =  tradingAddress?.leasehold?.endDate
            self.tradingFileSelectedStr = tradingAddress?.leasehold?.document ?? ""
            if self.tradingFileSelectedStr != "" {
                var url = URL(string: self.tradingFileSelectedStr)
                let document = url?.lastPathComponent.components(separatedBy: ".")
                let fileName = URL(fileURLWithPath: self.tradingFileSelectedStr).deletingPathExtension().lastPathComponent
                let fileType = url?.pathExtension ?? ""
                self.tradingFileUploadLabel.text = fileName + "." + fileType
            }
       // }

        
        
    }
    func updateModel() {
        let model = GlobalFundingModelObject
        var initial = AddressModel()
        initial.address1 = self.regAddress1TF.text ?? ""
        initial.address2 = self.regAddress2TF.text ?? ""
        initial.town = self.regCityTF.text ?? ""
        initial.postcode = self.regPostTF.text ?? ""
        initial.premiseType = self.regPremiseTypeTF.text ?? ""
        initial.leaseStartDate = self.regLeaseStartDateTF.text ?? ""
        initial.leaseEndDate = self.regLeaseEndDateTF.text ?? ""
        initial.leaseDocumentURL = self.registeringFileUploadStr
        initial.isSameForTrade = self.selectedTradingAddress
        model.registeredAddress = initial
//        if self.selectedTradingAddress {
//            model.tradingAddress = initial
//            model.tradingAddress.premiseType = self.TraPremiseTypeTF.text ?? ""
//        }else{
            var initial2 = AddressModel()
        initial2.address1 = self.TraAddress1TF.text ?? ""
        initial2.address2 = self.TraAddress2TF.text ?? ""
        initial2.town = self.TraCityTF.text ?? ""
        initial2.postcode = self.TraPostTF.text ?? ""
        initial2.premiseType = self.TraPremiseTypeTF.text ?? ""
        initial2.leaseStartDate = self.traLeaseStartDateTF.text ?? ""
        initial2.leaseEndDate = self.traLeaseEndDateTF.text ?? ""
        initial2.leaseDocumentURL = self.tradingFileUploadStr
        initial2.isSameForTrade = self.selectedTradingAddress
            model.tradingAddress = initial2
//        }
        var dict2 = JSON()
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"//DateTimeFormaterEnum.ddMMMyyyy.rawValue

        dict2["registered_address.address_line"] = model.registeredAddress.address1
        dict2["registered_address.post_code"] = model.registeredAddress.postcode
       // dict2["registered_address.premise_type"] = model.registeredAddress.premiseType
        if model.registeredAddress.premiseType == "Leasehold" {
            let leaseStartDateString = dateFormatter.string(from: self.regLeaseStartDate ?? Date())
            let leaseEndDateString = dateFormatter.string(from: self.regLeaseEndDate ?? Date())

            dict2["registered_address.leasehold.start_date"] = leaseStartDateString
            dict2["registered_address.leasehold.end_date"] = leaseEndDateString
        }
        dict2["trading_same_as_registered"] = self.selectedTradingAddress ? "Yes" : "No"
        if self.selectedTradingAddress {
           // dict2["trading_address.address_line"] = model.tradingAddress.address1
           // dict2["trading_address.post_code"] = model.tradingAddress.postcode
            dict2["trading_address.premise_type"] = model.tradingAddress.premiseType
            if model.tradingAddress.premiseType == "Leasehold" {
                let leaseStartDateString = dateFormatter.string(from: self.traLeaseStartDate ?? Date())
                let leaseEndDateString = dateFormatter.string(from: self.traLeaseEndDate ?? Date())

                dict2["trading_address.leasehold.start_date"] = leaseStartDateString
                dict2["trading_address.leasehold.end_date"] = leaseEndDateString
            }
        }else{
            dict2["trading_address.address_line"] = model.tradingAddress.address1
            dict2["trading_address.post_code"] = model.tradingAddress.postcode
            dict2["trading_address.premise_type"] = model.tradingAddress.premiseType
            if model.tradingAddress.premiseType == "Leasehold" {
                let leaseStartDateString = dateFormatter.string(from: self.traLeaseStartDate ?? Date())
                let leaseEndDateString = dateFormatter.string(from: self.traLeaseEndDate ?? Date())

                dict2["trading_address.leasehold.start_date"] = leaseStartDateString
                dict2["trading_address.leasehold.end_date"] = leaseEndDateString
            }
        }
       
        
        
//        APIService.shared.makeRequest(endpoint: APIEnums.createPremise.rawValue,
//                                      withLoader: true,
//                                      method: .post,
//                                      params: dict2) { result in
//
//            switch result {
//            case .success(let data):
//                if data.statusCode == 201 {
//                    var vc = InitialPageViewController.initWithStory()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                else {
//                    self.showAlert(title: "Info", message: data.statusMessage)
//                }
//
//            case .failure(let error):
//                print(error)
//                self.showAlert(title: "Info", message: error.localizedDescription)
//            }
//        }
        self.createPremiseDetails(params: dict2)
    }
    func updateFilledForms(){
        var params = JSON()
        params["complete_business_premis_detail"] = "True"
        var url = APIEnums.updateFilledForms.rawValue
        if loanId != "" {
            url = url + "\(loanId)/"
        }
      
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                }
                else if data.statusCode == 401 {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
    func createPremiseDetails(params: JSON) {
        var url = APIEnums.createPremise.rawValue
        if loanId != "" {
            url = url + "\(loanId)/"
        }
        if customerId != "" {
            url = url + "?customer_id=\(customerId)"
        }
        ConnectionHandler().uploadMutipleImgPost(wsMethod: url, paramDict: params, imgData: self.registeringFileUploadData, imgData1: self.tradingFileUploadData, viewController: self, isToShowProgress: true, isToStopInteraction: true) { response in
            if response.status_code == 200 {
                self.updateFilledForms()
                if self.delegate != nil {
                    self.delegate?.reload()
                    self.dismiss(animated: true)
                }else{
                    print(response)
                    var vc = DirectorDetailsViewController.initWithStory(loanId: self.loanId)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if response.status_code == 401 {
                self.tokenRefreshApi(params: params)
            }
            else{
                print(response)
                self.showAlert(title: "Info", message: response.status_message)
            }
        }
    }
    func tokenRefreshApi(params: JSON) {
        var dict = JSON()
        dict["refresh"] = UserDefaults.standard.value(forKey: "refresh") as? String
        APIService.shared.refreshTokenRequest(endpoint: APIEnums.refreshToken.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    UserDefaults.standard.set(data.access, forKey:"access")
                    UserDefaults.standard.set(data.refresh, forKey:"refresh")

                    self.createPremiseDetails(params: params)
                }
                else if data.statusCode == 422 {
                    UserDefaults.standard.set("", forKey:"access")
                    UserDefaults.standard.set("", forKey:"refresh")
                    UserDefaults.standard.set("", forKey:"role")
                    UserDefaults.standard.set(0, forKey:"isLogin")
                    UserDefaults.standard.set("", forKey:"email")
                    UserDefaults.standard.set("", forKey:"name")
                    UserDefaults.standard.set("", forKey:"image")
                    UserDefaults.standard.set("", forKey:"address")

                    var navigationController = UINavigationController()
                    navigationController = UINavigationController(rootViewController: HomeViewController.initWithStory())
                    sceneDelegate.window?.rootViewController = navigationController
                    sceneDelegate.window?.makeKeyAndVisible()
                    navigationController.isNavigationBarHidden = true
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }

    }
    func showHideTable() {
        switch self.dropdownType {
        case .RegPost:
            if self.regPostTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .RegPremise:
            if self.regPremiseTypeTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .TraPost:
            if self.traPostTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .TraPremise:
            if self.traPremiseTypeTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        default:
            break
        }
        
    }
}

extension PremiseDetailsViewController {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                switch self.dropdownType {
                case .RegPost:
                    self.regPostTable.isHidden = false
                    self.regPostTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.regPostTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                    self.regPostTable.reloadData()
                    self.view.layoutIfNeeded()
                case .RegPremise:
                    self.regPremiseTypeTable.isHidden = false
                    self.regPremiseTypeTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.regPremiseTypeTableHeight.constant = CGFloat(self.viewModel.regpremiseTypeArray.count * 50)
                    self.regPremiseTypeTable.reloadData()
                    self.view.layoutIfNeeded()
                case .TraPost:
                    self.TraPostTable.isHidden = false
                    self.TraPostTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.TraPostTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                    self.TraPostTable.reloadData()
                    self.view.layoutIfNeeded()
                case .TraPremise:
                    self.TraPremiseTypeTable.isHidden = false
                    self.TraPremiseTypeTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.TraPremiseTypeTableHeight.constant = CGFloat(self.viewModel.tradingpremiseTypeArray.count * 50)
                    self.TraPremiseTypeTable.reloadData()
                    self.view.layoutIfNeeded()
                default:
                    break

                }
               
            }, completion: nil)
        }
        
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            switch self.dropdownType {
            case .RegPost:
                self.regPostTable.isHidden = true
                self.regPostTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.regPostTableHeight.constant = 0
                self.regPostTable.reloadData()
            case .RegPremise:
                self.regPremiseTypeTable.isHidden = true
                self.regPremiseTypeTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.regPremiseTypeTableHeight.constant = 0
                self.regPremiseTypeTable.reloadData()
            case .TraPost:
                self.TraPostTable.isHidden = true
                self.TraPostTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.TraPostTableHeight.constant = 0
                self.TraPostTable.reloadData()
            case .TraPremise:
                self.TraPremiseTypeTable.isHidden = true
                self.TraPremiseTypeTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.TraPremiseTypeTableHeight.constant = 0
                self.TraPremiseTypeTable.reloadData()
            default:
                break

            }
        }, completion: nil)
    }
    func redirectToImageChooseVC()
    {
//        guard let alertPop = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageChooseViewController") as? ImageChooseViewController else {return}
//            let rootVC = UIApplication.shared.windows.last!.rootViewController
//            rootVC?.addChild(alertPop)
//            rootVC?.view.addSubview(alertPop.view)
//            alertPop.didMove(toParent: rootVC)
//            alertPop.delegate = self
//            alertPop.modalPresentationStyle = UIModalPresentationStyle.formSheet
//            alertPop.modalTransitionStyle = .crossDissolve
        let types: [String] = [kUTTypePDF as String,kUTTypeJPEG as String,kUTTypePNG as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
        }
}
extension PremiseDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == regPostTable || tableView == TraPostTable {
            count = self.viewModel.postalLookupArray.count
        }else if tableView == regPremiseTypeTable {
            count = self.viewModel.regpremiseTypeArray.count
        }else if tableView == TraPremiseTypeTable {
            count = self.viewModel.tradingpremiseTypeArray.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.dropdownType == .RegPost && tableView == regPostTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as? CellClass4 else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                return cell
            }
            var modelText = model.ItemText
            var address = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
            cell.label3.text = (modelText == "" && self.viewModel.postalLookupArray.count == 1) ? address : modelText
            cell.action3.setTitle("", for: .normal)
            cell.separator3.isHidden = (indexPath.row == self.viewModel.postalLookupArray.count - 1)
            cell.action3.addTapGestureRecognizer {
                
                if model.Selected == "true" && self.viewModel.postalLookupArray.count == 1{
                    self.selectedRegPostCode = self.viewModel.postalLookupArray.value(atSafe: indexPath.row)?.Sid ?? ""
                    self.regAddress1TF.text = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
                    self.regAddress1ErrStack.isHidden = true
//                    self.pincodeTF.text = model.Label5
                    self.regPostTableHidden = !self.regPostTableHidden
                    self.dropdownType = .RegPost
                    self.removeTransparentView()
                    self.regPostErrStack.isHidden = true
                }else{
                    self.callPostcodeLookupSidAPI(isTrading: false, parms: ["address_sid": model.Sid ?? ""])

                }
            }
            return cell
        }
        else if self.dropdownType == .RegPremise {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            cell.documentLabel.text = self.viewModel.regpremiseTypeArray.value(atSafe: indexPath.row)?.description
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.viewModel.regpremiseTypeArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                self.regPremiseTypeTF.text = "\(self.viewModel.regpremiseTypeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedRegPremiseType = self.viewModel.regpremiseTypeArray.value(atSafe: indexPath.row)
                self.regPremiseTypeTableHidden = !self.regPremiseTypeTableHidden
                self.dropdownType = .RegPremise
                self.removeTransparentView()
                self.regPremiseTypeErrStack.isHidden = true
                if self.selectedRegPremiseType?.description == "Leasehold" {
                    self.regLeaseDateStack.isHidden = false
                    self.regLeaseLabelView.isHidden = false
                    self.registeringFileUploadStack.isHidden = false
                }else{
                    self.registeringFileUploadData = Data()
                    self.regLeaseDateStack.isHidden = true
                    self.regLeaseLabelView.isHidden = true
                    self.registeringFileUploadStack.isHidden = true
                }
            }
            return cell
        }
        else if self.dropdownType == .TraPost && tableView == TraPostTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? CellClass3 else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                return cell
            }
            var modelText = model.ItemText
            var address = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4

            cell.label2.text = (modelText == "" && self.viewModel.postalLookupArray.count == 1) ? address : modelText
            cell.action2.setTitle("", for: .normal)
            cell.separator2.isHidden = (indexPath.row == self.viewModel.postalLookupArray.count - 1)
            cell.action2.addTapGestureRecognizer {
                
                
                if model.Selected == "true" && self.viewModel.postalLookupArray.count == 1{
                    self.selectedTraPostCode = self.viewModel.postalLookupArray.value(atSafe: indexPath.row)?.Sid ?? ""
                    self.TraAddress1TF.text = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
                    self.TraAddress1ErrStack.isHidden = true
//                    self.pincodeTF.text = model.Label5
                    self.traPostTableHidden = !self.traPostTableHidden
                    self.dropdownType = .TraPost
                    self.removeTransparentView()
                    self.TraPostErrStack.isHidden = true
                }else{
                    self.callPostcodeLookupSidAPI(isTrading: true, parms: ["address_sid": model.Sid ?? ""])

                }
            }
            return cell
        }
        else if self.dropdownType == .TraPremise {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            cell.documentLabel.text = self.viewModel.tradingpremiseTypeArray.value(atSafe: indexPath.row)?.description
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.viewModel.tradingpremiseTypeArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                self.TraPremiseTypeTF.text = "\(self.viewModel.tradingpremiseTypeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedTraPremiseType = self.viewModel.tradingpremiseTypeArray.value(atSafe: indexPath.row)
                self.traPremiseTypeTableHidden = !self.traPremiseTypeTableHidden
                self.dropdownType = .TraPremise
                self.removeTransparentView()
                self.TraPremiseTypeErrStack.isHidden = true
                if self.selectedTraPremiseType?.description == "Leasehold" {
                    self.traLeaseDateStack.isHidden = false
                    self.traLeaseLabelView.isHidden = false
                    self.tradingFileUploadStack.isHidden = false
                }else{
                    self.tradingFileUploadData = Data()
                    self.traLeaseDateStack.isHidden = true
                    self.traLeaseLabelView.isHidden = true
                    self.tradingFileUploadStack.isHidden = true
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension PremiseDetailsViewController : UITextFieldDelegate {
    
    
    func updateProceedButtonUI(enabled: Bool) {
//        self.nextButton.isEnabled = enabled
//        self.nextButton.backgroundColor = enabled ? UIColor.init(named: "blue") :  UIColor.init(named: "grayborder")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.regAddress1TF {
            self.regAddress1ErrStack.isHidden = true
        }
        if textField == self.regAddress2TF {
            self.regAddress2ErrStack.isHidden = true
        }
        if textField == self.regCityTF {
            self.regCityErrStack.isHidden = true
        }
        if textField == self.TraAddress1TF {
            self.TraAddress1ErrStack.isHidden = true
        }
        if textField == self.TraAddress2TF {
            self.TraAddress2ErrStack.isHidden = true
        }
        if textField == self.TraCityTF {
            self.TraCityErrStack.isHidden = true
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        switch textField {
        
        case self.regPostTF:
            self.regAddress1TF.text = ""
            self.selectedRegPostCode = ""
        case self.TraPostTF:
            self.TraAddress1TF.text = ""
            self.selectedTraPostCode = ""

        default: break
        }
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        switch textField {
        case self.regAddress1TF:
            if (self.regAddress1TF.text == nil || self.regAddress1TF.text == "") {
                self.regAddress1ErrStack.isHidden = false
                self.regAddress1ErrLabel.text = "Please enter Addresss Line 1"
            }
        case self.regAddress2TF:
            if (self.regAddress2TF.text == nil || self.regAddress2TF.text == "") {
                self.regAddress2ErrStack.isHidden = false
                self.regAddress2ErrLabel.text = "Please enter Address Line 2"
            }
        case self.regCityTF:
            if (self.regCityTF.text == nil || self.regCityTF.text == "") {
                self.regCityErrStack.isHidden = false
                self.regCityErrLabel.text = "Please enter City"
            }
        case self.TraAddress1TF:
            if (self.TraAddress1TF.text == nil || self.TraAddress1TF.text == "") && !self.selectedTradingAddress{
                self.TraAddress1ErrStack.isHidden = false
                self.TraAddress1ErrLabel.text = "Please enter Address Line 1"
            }
        case self.TraAddress2TF:
            if (self.TraAddress2TF.text == nil || self.TraAddress2TF.text == "") && !self.selectedTradingAddress{
                self.TraAddress2ErrStack.isHidden = false
                self.TraAddress2ErrLabel.text = "Please enter Address Line 2"
            }
        case self.TraCityTF:
            if (self.TraCityTF.text == nil || self.TraCityTF.text == "") && !self.selectedTradingAddress{
                self.TraCityErrStack.isHidden = false
                self.TraCityErrLabel.text = "Please enter City"
            }
        case self.regPostTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
            let result      = eTest.evaluate(with: self.regPostTF.text?.trim())

            if (self.regPostTF.text == nil || self.regPostTF.text == "") {
                self.regPostErrStack.isHidden = false
                self.regPostErrLabel.text = "Please enter the Postcode"
                self.dropdownType = .RegPost
                self.regPostTableHidden = true
                self.showHideTable()

            }
            else if result == false {
                self.regPostErrStack.isHidden = false
                self.regPostErrLabel.text = "Valid UK Postcode is required"
                self.dropdownType = .RegPost
                self.regPostTableHidden = true
                self.showHideTable()

            }
            else{
                self.regAddress1TF.text = ""
                self.selectedRegPostCode = ""
                self.regPostErrStack.isHidden = true
                self.callPostcodeLookupAPI(isTrading: false, parms: ["address": self.regPostTF.text ?? ""])
            }
        case self.TraPostTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
            let result      = eTest.evaluate(with: self.TraPostTF.text?.trim())

            if (self.TraPostTF.text == nil || self.TraPostTF.text == "") {
                self.TraPostErrStack.isHidden = false
                self.TraPostErrLabel.text = "Please enter the Postcode"
                self.dropdownType = .TraPost
                self.traPostTableHidden = true
                self.showHideTable()

            }
            else if result == false {
                self.TraPostErrStack.isHidden = false
                self.TraPostErrLabel.text = "Valid UK Postcode is required"
                self.dropdownType = .TraPost
                self.traPostTableHidden = true
                self.showHideTable()

            }
            else{
                self.TraAddress1TF.text = ""
                self.selectedTraPostCode = ""
                self.TraPostErrStack.isHidden = true
                self.callPostcodeLookupAPI(isTrading: true, parms: ["address": self.TraPostTF.text ?? ""])
            }
        default:
            break
        }
        //        self.updateNextButton()
    }
    
        func goNext() -> Bool {
            if (self.regAddress1TF.text == nil || self.regAddress1TF.text == "") {
                return false
            }
            if (self.regPostTF.text == nil || self.regPostTF.text == "") {
                return false
            }
            if (self.TraPostTF.text == nil || self.TraPostTF.text == "") && !self.selectedTradingAddress{
                return false
            }
//            if (self.selectedRegPostCode?.description == nil || self.selectedRegPostCode?.description == "") {
//                return false
//            }
//            if (self.selectedRegPremiseType?.description == nil || self.selectedRegPremiseType?.description == "") {
//                return false
//            }
//            if (self.selectedTraPostCode?.description == nil || self.selectedTraPostCode?.description == "") && !self.selectedTradingAddress{
//                return false
//            }
            if (self.selectedTraPremiseType?.description == nil || self.selectedTraPremiseType?.description == "") {//&& !self.selectedTradingAddress{
                return false
            }
            if ((self.regLeaseStartDateTF.text == nil || self.regLeaseStartDateTF.text == "") && self.selectedRegPremiseType?.description == "Leasehold") {
                return false
            }
            if ((self.regLeaseEndDateTF.text == nil || self.regLeaseEndDateTF.text == "") && self.selectedRegPremiseType?.description == "Leasehold") {
                return false
            }
            if ((self.traLeaseStartDateTF.text == nil || self.traLeaseStartDateTF.text == "") && self.selectedTraPremiseType?.description == "Leasehold") {
                return false
            }
            if ((self.traLeaseEndDateTF.text == nil || self.traLeaseEndDateTF.text == "") && self.selectedTraPremiseType?.description == "Leasehold") {
                return false
            }
            if ((self.tradingFileUploadStr == "" ) && self.selectedTraPremiseType?.description == "Leasehold") {
                if self.tradingFileSelectedStr != "" {
                }else{
                    return false
                }
            }
            if ((self.registeringFileUploadStr == "") && self.selectedRegPremiseType?.description == "Leasehold") {
                if self.registeringFileSelectedStr != "" {
                }else{
                    return false
                }
            }
//            if (self.regAddress2TF.text == nil || self.regAddress2TF.text == "") {
//                return false
//            }
//            if (self.regCityTF.text == nil || self.regCityTF.text == "") {
//                return false
//            }
            if (self.TraAddress1TF.text == nil || self.TraAddress1TF.text == "") && !self.selectedTradingAddress{
                return false
            }
//            if (self.TraAddress2TF.text == nil || self.TraAddress2TF.text == "") && !self.selectedTradingAddress{
//                return false
//            }
//            if (self.TraCityTF.text == nil || self.TraCityTF.text == "") && !self.selectedTradingAddress {
//                return false
//            }
            return true
        }
   
    func isValidTextFields() {
        if (self.regAddress1TF.text == nil || self.regAddress1TF.text == "") {
            self.regAddress1ErrStack.isHidden = false
            self.regAddress1ErrLabel.text = "Please enter the Address Line 1"
        }
        if (self.regPostTF.text == nil || self.regPostTF.text == "") {
            self.regPostErrStack.isHidden = false
            self.regPostErrLabel.text = "Please select post code"
        }
//        if (self.selectedRegPremiseType?.description == nil || self.selectedRegPremiseType?.description == "") {
//            self.regPremiseTypeErrStack.isHidden = false
//            self.regPremiseTypeErrLabel.text = "Please select premise type"
//        }
        if (self.TraPostTF.text == nil || self.TraPostTF.text == "") && !self.selectedTradingAddress {
            self.TraPostErrStack.isHidden = false
            self.TraPostErrLabel.text = "Please select post code"
        }
        if (self.selectedTraPremiseType?.description == nil || self.selectedTraPremiseType?.description == "") { //&& !self.selectedTradingAddress {
            self.TraPremiseTypeErrStack.isHidden = false
            self.TraPremiseTypeErrLabel.text = "Please select premise type"
        }
//        if (self.regAddress2TF.text == nil || self.regAddress2TF.text == "") {
//            self.regAddress2ErrStack.isHidden = false
//            self.regAddress2ErrLabel.text = "Please enter the Address Line 2"
//        }
//        if (self.regCityTF.text == nil || self.regCityTF.text == "") {
//            self.regCityErrStack.isHidden = false
//            self.regCityErrLabel.text = "Please enter city"
//        }
        if (self.TraAddress1TF.text == nil || self.TraAddress1TF.text == "") && !self.selectedTradingAddress {
            self.TraAddress1ErrStack.isHidden = false
            self.TraAddress1ErrLabel.text = "Please enter Trading Address Line 1"
        }
//        if (self.TraAddress2TF.text == nil || self.TraAddress2TF.text == "") && !self.selectedTradingAddress {
//            self.TraAddress2ErrStack.isHidden = false
//            self.TraAddress2ErrLabel.text = "Please enter Trading Address Line 2"
//        }
//        if (self.TraCityTF.text == nil || self.TraCityTF.text == "") && !self.selectedTradingAddress {
//            self.TraCityErrStack.isHidden = false
//            self.TraCityErrLabel.text = "Please enter city"
//        }
        if ((self.regLeaseStartDateTF.text == nil || self.regLeaseStartDateTF.text == "") && self.selectedRegPremiseType?.description == "Leasehold") {
            self.regLeaseErrStack.isHidden = false
            self.regLeaseErrLabel.text = "Please choose the date"
        }
        if ((self.regLeaseEndDateTF.text == nil || self.regLeaseEndDateTF.text == "") && self.selectedRegPremiseType?.description == "Leasehold") {
            self.regLeaseErrStack.isHidden = false
            self.regLeaseErrLabel.text = "Please choose the date"
        }
        if ((self.traLeaseStartDateTF.text == nil || self.traLeaseStartDateTF.text == "") && self.selectedTraPremiseType?.description == "Leasehold") {
            self.traLeaseDateErrStack.isHidden = false
            self.traLeaseDateErrLabel.text = "Please choose the date"
        }
        if ((self.traLeaseEndDateTF.text == nil || self.traLeaseEndDateTF.text == "") && self.selectedTraPremiseType?.description == "Leasehold") {
            self.traLeaseDateErrStack.isHidden = false
            self.traLeaseDateErrLabel.text = "Please choose the date"
        }
        if (self.tradingFileUploadStr == "") && self.selectedTraPremiseType?.description == "Leasehold"{
            if self.tradingFileSelectedStr != "" {
            }else{
                self.tradingFileUploadErrStack.isHidden = false
                self.tradingFileUploadErrLabel.text = "Please choose the file"
            }
        }
        if (self.registeringFileUploadStr == "") && self.selectedRegPremiseType?.description == "Leasehold"{
            if self.registeringFileSelectedStr != "" {
            }else{
                self.registeringFileUploadErrStack.isHidden = false
                self.registeringFileUploadErrLabel.text = "Please choose the file"
            }
        }
    }
    func callPostcodeLookupAPI(isTrading: Bool,parms: [AnyHashable: Any]){
        self.viewModel
            .PostcodeLookupApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.postalLookupArray.removeAll()
                    self.viewModel.postalLookupArray = responseDict.data.Results.Items
                    if isTrading {
                        self.dropdownType = .TraPost
                        self.traPostTableHidden = false
                        self.showHideTable()
                    }else{
                        self.dropdownType = .RegPost
                        self.regPostTableHidden = false
                        self.showHideTable()
                    }
                    break
                case .failure(let error):
                    break
                }
            }
    }
    func callPostcodeLookupSidAPI(isTrading: Bool,parms: [AnyHashable: Any]){
        self.viewModel
            .PostcodeLookupSidApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.postalLookupArray.removeAll()
                    self.viewModel.postalLookupArray = responseDict.data.Results.Items
                    if isTrading {
                        self.TraPostTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                        self.TraPostTable.reloadData()
                        self.view.layoutIfNeeded()
                    }else{
                        self.regPostTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                        self.regPostTable.reloadData()
                        self.view.layoutIfNeeded()
                    }
                    break
                case .failure(let error):
                    break
                }
            }
    }
}
extension PremiseDetailsViewController {
    func showImageChoices() {
        let alert = UIAlertController(title: "Choose an Option for Document image upload", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
                DispatchQueue.main.async {
                    self.openCamera()
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            DispatchQueue.main.async {
                self.requestPhotoLibraryPermission()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Gallery button")
        }))
        
        self.present(alert, animated: true)
    }
    
    func openCamera() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        pickerController.delegate = self
        pickerController.modalPresentationStyle = .overCurrentContext
        self.present(pickerController, animated: true)
    }
    
    func openGallery() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        pickerController.modalPresentationStyle = .overCurrentContext
        self.present(pickerController, animated: true)
    }
}
extension PremiseDetailsViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func requestPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .denied, .restricted:
                        print("No Photos Permission")
                    case .authorized, .limited:
                        DispatchQueue.main.async {
                            self.openGallery()
                        }
                        print("Photos Permission")
                    default:
                        print("Default")
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .denied, .restricted:
                        print("No Photos Permission")
                    case .authorized, .limited:
                        DispatchQueue.main.async {
                            self.openGallery()
                        }
                        print("Photos Permission")
                    default:
                        print("Default")
                    }
                }
            }
        case .denied, .restricted:
            print("No Photos Permission")
        case .authorized, .limited:
            DispatchQueue.main.async {
                self.openGallery()
            }
            print("Photos Permission")
        default:
            print("Default")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.getImageDetails(image: image, info: info)
        }
        else if let image = info[.editedImage] as? UIImage {
            self.getImageDetails(image: image, info: info)
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    func getImageDetails(image: UIImage,info: [UIImagePickerController.InfoKey : Any]) {
        var size = Float()
        var data = Data()

        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType  == "public.image" {
                    data = image.jpegData(compressionQuality: 1.0)!
                    size = Float(Double(data.count)/1024)
                    size = Float(Double(size/1024))
                    var imageName = "Image.jpg"
                    if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                    print(url.lastPathComponent)
                    print(url.pathExtension)
                        imageName = url.lastPathComponent
                    }
                if size >= 5 {
                    self.showAlert(title: "Info", message: "Please upload image with below 5MB")
                }else{
                    self.uploadProfileImage(image: image,imageName: imageName,imageSize: "\(size)KB")
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func uploadProfileImage(image: UIImage,imageName: String,imageSize: String) {
        
        var imageStr = ""
        let imageData = image.jpegData(compressionQuality: 0.3)
        if let imageString = imageData?.base64EncodedString() {
            imageStr = imageString
        }
        if self.isTradingFileUpload {
            self.tradingFileUploadLabel.text = imageName
            self.tradingFileUploadStr = imageStr
//            self.tradingFileUploadButton.isHidden = true
            self.tradingFileUploadErrStack.isHidden = true

        }else{
            self.registeringFileUploadLabel.text = imageName
            self.registeringFileUploadStr = imageStr
//            self.registeringFileUploadButton.isHidden = true
            self.registeringFileUploadErrStack.isHidden = true

        }
    }

}
extension PremiseDetailsViewController : ImageChooseDelegate {
    func selectedImage(type: SelectedImageType) {
        switch type {
        case .Camera:
            self.openCamera()
        case .Gallery:
            self.requestPhotoLibraryPermission()
        }
    }
}
extension PremiseDetailsViewController : UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        let isSecuredURL = url.startAccessingSecurityScopedResource() == true
        let coordinator = NSFileCoordinator()
        var error: NSError? = nil
        coordinator.coordinate(readingItemAt: url, options: [], error: &error) { (url) -> Void in
            _ = urls.compactMap { (url: URL) -> URL? in
                // Create file URL to temporary folder
                var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
                // Apend filename (name+extension) to URL
                tempURL.appendPathComponent(url.lastPathComponent)
                do {
                    // If file with same name exists remove it (replace file with new one)
                    if FileManager.default.fileExists(atPath: tempURL.path) {
                        try FileManager.default.removeItem(atPath: tempURL.path)
                    }
                    // Move file from app_id-Inbox to tmp/filename
                    try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
                    self.fileChecking(url:tempURL)
                    return tempURL
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
        }
        if (isSecuredURL) {
            url.stopAccessingSecurityScopedResource()
        }
        controller.dismiss(animated: true)
     //   self.dismiss(animated: true, completion: nil)
    }
    func fileChecking(url:URL){
        var size = self.sizePerMB(url: url)
        print(size)
        if size.description.toInt() >= 5 {
            DispatchQueue.main.async {
                self.showAlert(title: "Info", message: "Please upload the image upto 5MB")
            }
        }else{
        let document = url.lastPathComponent.components(separatedBy: ".")
        let fileName = "\(document[0])"
        let fileType = "\(document[1])"
        print(fileName)
        print(fileType)
        do {
            let fileData = try Data.init(contentsOf: url)
            let fileStream:String = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            if self.isTradingFileUpload {
                self.tradingFileUploadLabel.text = fileName + "." + fileType
                self.tradingFileUploadStr = fileStream
                self.tradingFileUploadData = fileData
//                self.tradingFileUploadButton.isHidden = true
                self.tradingFileUploadErrStack.isHidden = true
                
            }else{
                self.registeringFileUploadLabel.text = fileName + "." + fileType
                self.registeringFileUploadStr = fileStream
                self.registeringFileUploadData = fileData
//                self.registeringFileUploadButton.isHidden = true
                self.registeringFileUploadErrStack.isHidden = true
                
            }
            //            let decodeData = Data(base64Encoded: fileStream, options: .ignoreUnknownCharacters)
            //            body.append(decodeData!)
        }
        catch { }}
    }
}
