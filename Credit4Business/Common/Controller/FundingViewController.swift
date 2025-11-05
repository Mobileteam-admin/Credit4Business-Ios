//
//  FundingViewController.swift
//  Credit4Business
//
//  Created by MacMini on 07/03/24.
//

import UIKit
import IQKeyboardManagerSwift
import RangeUISlider
class FundingViewController: BaseViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var directorDetailsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var businessTypeTF: UITextField!
    @IBOutlet weak var businessTableHeight: NSLayoutConstraint!
    @IBOutlet weak var businessTable: UITableView!
    @IBOutlet weak var businessTableArrowActionView: UIView!
    @IBOutlet weak var businessTableArrow: UIImageView!
    @IBOutlet weak var businessTypeErrLabel: UILabel!
    @IBOutlet weak var businessTypeErrStack: UIStackView!
    
    @IBOutlet weak var directorDetailsTable: UITableView!
    @IBOutlet weak var directorDetailsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var numberOfDirectorsStack: UIStackView!
    
    @IBOutlet weak var numberOfDirectorsTF: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tradingDateErrLabel: UILabel!
    @IBOutlet weak var tradingDateErrStack: UIStackView!

    @IBOutlet weak var tradingDateStack: UIStackView!
    
    @IBOutlet weak var salesSlider: RangeUISlider!
    @IBOutlet weak var salesSliderNew: UISlider!
    @IBOutlet weak var annaulSalesTF: UITextField!

    @IBOutlet weak var annualTurnOverTF: UITextField!
    @IBOutlet weak var annualTurnNew: UISlider!

    @IBOutlet weak var annualSalesStack: UIStackView!
    @IBOutlet weak var annualSalesErrLabel: UILabel!
    @IBOutlet weak var annualSalesLabel: UILabel!
    @IBOutlet weak var annualSalesErrStack: UIStackView!

    @IBOutlet weak var turnOverLabel: UILabel!
    @IBOutlet weak var sliderView: RangeUISlider!
    @IBOutlet weak var annualTurnOverErrLabel: UILabel!
    @IBOutlet weak var annualTurnOverErrStack: UIStackView!

    @IBOutlet weak var startedTradingYesImage: UIImageView!
    @IBOutlet weak var startedTradingYesView: UIView!
    @IBOutlet weak var startedTradingNoImage: UIImageView!
    @IBOutlet weak var startedTradingNoView: UIView!
    @IBOutlet weak var modeOfTradingErrLabel: UILabel!
    @IBOutlet weak var modeOfTradingErrStack: UIStackView!

    @IBOutlet weak var profitableYesImage: UIImageView!
    @IBOutlet weak var profitableYesView: UIView!
    @IBOutlet weak var profitableNoImage: UIImageView!
    @IBOutlet weak var profitableNoView: UIView!
    @IBOutlet weak var modeOfProfitableErrLabel: UILabel!
    @IBOutlet weak var modeOfProfitableErrStack: UIStackView!

    @IBOutlet weak var acceptCardYesImage: UIImageView!
    @IBOutlet weak var acceptCardYesView: UIView!
    @IBOutlet weak var acceptCardNoImage: UIImageView!
    @IBOutlet weak var acceptCardNoView: UIView!
    @IBOutlet weak var modeOfAcceptCardErrLabel: UILabel!
    @IBOutlet weak var modeOfAcceptCardErrStack: UIStackView!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var businessSectorTypeView: UIStackView!
    @IBOutlet weak var businessSectorTypeTF: UITextField!
    @IBOutlet weak var businessSectorTableHeight: NSLayoutConstraint!
    @IBOutlet weak var businessSectorTable: UITableView!
    @IBOutlet weak var businessSectorTableArrowActionView: UIView!
    @IBOutlet weak var businessSectorTableArrow: UIImageView!
    @IBOutlet weak var businessSectorTypeErrLabel: UILabel!
    @IBOutlet weak var businessSectorTypeErrStack: UIStackView!
    
    @IBOutlet weak var otherFundingPurposeStack: UIStackView!
    @IBOutlet weak var otherFundingPurposeView: UIStackView!
    @IBOutlet weak var otherFundingPurposeTF: UITextField!
    @IBOutlet weak var otherfundingProcessErrLabel: UILabel!
    @IBOutlet weak var otherfundingProcessErrStack: UIStackView!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var directorDetailsLabelView: UIView!
    @IBOutlet weak var commentButton: UIImageView!
    @IBOutlet weak var weeklyCardSalesTF: UITextField!
    //MARK: -------------------- Class Variable --------------------
    
    var businessTableHidden = true
    var businessSectorTableHidden = true
    var directorTableHidden = true
    var viewModel = HomeVM()
    var selectedBusinessType : Common?
    var selectedBusinessSectorType : Common?
    var dropdownType : DropDownType = .Director
    var businessMemberType : BusinessMemberType = .none
    var numberOfDirectors = 0
    var selectedTrading : Option = .none
    var selectedAcceptCard : Option = .none
    var selectedProfitable : Option = .none
    var tradeDate : Date?
    var selectedBusinessResponse : BusinessDataClass?
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
        //self.showModelValues()
    }

    override
    func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
       // if UserDefaults.standard.value(forKey: "role") as? String == "LEADS" && isFromIncomplete {
        if self.customerId != "" {
            self.fetchBusinessDetails(customerId: self.customerId)
        }else{
            self.fetchBusinessDetails()
        }
        //}
//        if self.selectedBusinessResponse != nil {
//            self.showModelValues()
//        }
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------
    
    class func initWithStory(loanId: String) -> FundingViewController {
        let vc : FundingViewController = UIStoryboard.Main.instantiateViewController()
        vc.loanId = loanId
        return vc
    }
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.businessTable.delegate = self
        self.businessTable.dataSource = self
        self.directorDetailsTable.delegate = self
        self.directorDetailsTable.dataSource = self
        self.businessSectorTable.delegate = self
        self.businessSectorTable.dataSource = self
        self.numberOfDirectorsTF.delegate = self
        self.otherFundingPurposeTF.delegate = self
        self.sliderView.delegate = self
        self.salesSlider.delegate = self
        self.weeklyCardSalesTF.delegate = self
        self.weeklyCardSalesTF.keyboardType = .numberPad
        self.annualTurnOverTF.delegate = self
        self.annaulSalesTF.delegate = self
    }
    func showModelValues() {
        guard let initial = self.selectedBusinessResponse else {return}
//        self.businessTypeTF.text = initial.businessType
//        self.selectedBusinessType = self.viewModel.businessTypeArray.filter({$0.description == initial.businessType}).first
        var model = GlobalFundingModelObject.initial
//        self.selectedBusinessType = self.viewModel.businessTypeArray.filter({$0.description.contains(model.businessType?.description ?? "")}).first
        self.selectedBusinessType = self.viewModel.businessTypeArray.filter({$0.description.contains(initial.businessType)}).first

        self.businessTypeTF.text = self.selectedBusinessType?.description

        self.numberOfDirectorsTF.text = initial.numberOfDirectors.description
        self.numberOfDirectors = initial.numberOfDirectors

//        initial.directorArray = self.viewModel.directorNameArray
//        initial.remainingDirectorArray = self.viewModel.directorNameArray
        self.selectedTrading = initial.hasStartedTrading == "Yes" ? Option.Yes : Option.No
        self.startedTradingNoImage.image = self.selectedTrading.rawValue == "Yes" ? UIImage.init(named: "radioUnselected") : UIImage.init(named: "radioSelected")
        self.startedTradingYesImage.image = self.selectedTrading.rawValue == "Yes" ? UIImage.init(named: "radioSelected") : UIImage.init(named: "radioUnselected")
        self.tradingDateStack.isHidden = self.selectedTrading.rawValue == "Yes" ? false : true

        self.selectedProfitable = initial.isProfitable == "Yes" ? Option.Yes : Option.No
        self.profitableNoImage.image = self.selectedProfitable.rawValue == "Yes" ? UIImage.init(named: "radioUnselected") : UIImage.init(named: "radioSelected")
        self.profitableYesImage.image = self.selectedProfitable.rawValue == "Yes" ? UIImage.init(named: "radioSelected") : UIImage.init(named: "radioUnselected")

        self.selectedAcceptCard = initial.acceptsCardPayment == "Yes" ? Option.Yes : Option.No
        self.acceptCardNoImage.image = self.selectedAcceptCard.rawValue == "Yes" ? UIImage.init(named: "radioUnselected") : UIImage.init(named: "radioSelected")
        self.acceptCardYesImage.image = self.selectedAcceptCard.rawValue == "Yes" ? UIImage.init(named: "radioSelected") : UIImage.init(named: "radioUnselected")
        self.annualSalesStack.isHidden = self.selectedAcceptCard.rawValue == "Yes" ? false : true
        if initial.startTradingDate != "" {
            self.dateLabel.text = initial.startTradingDate
        }
        var str = String(format: "%.2f", initial.averageMonthlyTurnover.toFloat())
        var str2 = String(format: "%.2f", initial.averageWeeklyCardSales.toFloat())

        self.turnOverLabel.text = "£ " + str
        self.annualSalesLabel.text = "£ " + str2
        self.annaulSalesTF.text = initial.averageWeeklyCardSales.toFloat().description
        self.annualTurnOverTF.text = initial.averageMonthlyTurnover.toFloat().description

        if initial.averageMonthlyTurnover.toFloat() == 0.0 || initial.averageMonthlyTurnover == ""{
            rangeChangeFinished(minValueSelected: 4000.0, maxValueSelected: 4000.0, slider: self.sliderView)
            self.sliderView.changeLeftKnob(value: 4000.0)
            self.sliderView.changeRightKnob(value: 4000.0)
            self.annualTurnNew.value = 4000.0
            self.turnOverLabel.text = "£ 4000"
            self.annualTurnOverTF.text = "4000"
        }else {
            var integer = CGFloat(initial.averageMonthlyTurnover.toFloat())
            self.sliderView.scaleMinValue = 4000
            self.sliderView.scaleMaxValue = 1000000
            if integer < 4000 || integer > 1000000 {
                rangeChangeFinished(minValueSelected: 4000.0, maxValueSelected: 4000.0, slider: self.sliderView)
                self.sliderView.changeLeftKnob(value: 4000.0)
                self.sliderView.changeRightKnob(value: 4000.0)
//                self.turnOverLabel.text = "£\(integer) - £\(integer)"
                self.turnOverLabel.text = "£ \(str)"
                self.annualTurnNew.setValue(4000.0, animated: true)
            }else{
                self.sliderView.changeLeftKnob(value: integer)
                self.sliderView.changeRightKnob(value: integer)
                rangeChangeFinished(minValueSelected: integer, maxValueSelected: integer, slider: self.sliderView)
                self.annualTurnNew.setValue(Float(integer), animated: true)
            }

        }
        if initial.averageWeeklyCardSales.toFloat() == 0 || initial.averageWeeklyCardSales == ""{
            rangeChangeFinished(minValueSelected: 1000.0, maxValueSelected: 1000.0, slider: self.salesSlider)
            self.salesSlider.changeLeftKnob(value: 1000.0)
            self.salesSlider.changeRightKnob(value: 1000.0)
            self.salesSliderNew.value = 1000.0
            self.annualSalesLabel.text = "£ 1000"
            self.annaulSalesTF.text = "1000"

        }else {
            var integer = CGFloat(initial.averageWeeklyCardSales.toFloat())
            self.salesSlider.scaleMinValue = 1000
            self.salesSlider.scaleMaxValue = 250000
            if integer < 1000 || integer > 250000 {
                rangeChangeFinished(minValueSelected: 1000.0, maxValueSelected: 1000.0, slider: self.salesSlider)
                self.salesSlider.changeLeftKnob(value: 1000.0)
                self.salesSlider.changeRightKnob(value: 1000.0)
//                self.annualSalesLabel.text = "£\(integer) - £\(integer)"
                self.annualSalesLabel.text = "£ \(str2)"
                self.salesSliderNew.setValue(1000.0, animated: true)
            }else{
                rangeChangeFinished(minValueSelected: integer, maxValueSelected: integer, slider: self.salesSlider)
                self.salesSlider.changeLeftKnob(value: integer)
                self.salesSlider.changeRightKnob(value: integer)
                self.salesSliderNew.setValue(Float(integer), animated: true)
            }

        }
//        if initial.averageWeeklyCardSales.toInt() == 0 {
//            self.salesSlider.scaleMinValue = 1000
//            self.salesSlider.scaleMaxValue = 250000
//        }else{
//            self.salesSlider.scaleMinValue = CGFloat(initial.averageWeeklyCardSales.toInt())
//            self.salesSlider.scaleMaxValue = CGFloat(initial.averageWeeklyCardSales.toInt())
//        }
//        

        self.weeklyCardSalesTF.text = initial.averageWeeklyCardSales.toInt().description
        self.businessSectorTypeTF.text = initial.businessSector
        self.selectedBusinessSectorType = self.viewModel.businessSectorTypeArray.filter({$0.description == initial.businessSector}).first
        self.otherFundingPurposeTF.text = initial.otherBusinessName
        self.updateNumberOfDirectorsView()
    }
    func manageActionMethods() {
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanId)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.businessTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .Business
            self.businessTableHidden = !self.businessTableHidden
            self.showHideTable()
        }
        self.businessTypeTF.addTapGestureRecognizer {
            self.dropdownType = .Business
            self.businessTableHidden = !self.businessTableHidden
            self.showHideTable()
        }
        self.businessSectorTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .BusinessSector
            self.businessSectorTableHidden = !self.businessSectorTableHidden
            self.showHideTable()
        }
        self.businessSectorTypeTF.addTapGestureRecognizer {
            self.dropdownType = .BusinessSector
            self.businessSectorTableHidden = !self.businessSectorTableHidden
            self.showHideTable()
        }
        self.dateLabel.addTapGestureRecognizer {
            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                 popup.modalPresentationStyle = .overFullScreen
                 popup.isReadableFormat = true
                 popup.goback60 = true
                 self.present(popup, animated: true, completion: nil)
                 popup.dateSelectionHandler = { [weak self] fromDate, toDate in
//                     self?.dateSelectionHandler?(fromDate, toDate, "\(fromDate) - \(toDate ?? "")")
//                     self?.removeAnimate()
                     print(fromDate)
                     self?.tradeDate = toDate
                     self?.dateLabel.text = fromDate
                     self?.dismiss(animated: true)
                     self?.tradingDateErrStack.isHidden = true
                 }
            }
        self.startedTradingYesView.addTapGestureRecognizer {
            self.selectedTrading = .Yes
            self.startedTradingNoImage.image = UIImage.init(named: "radioUnselected")
            self.startedTradingYesImage.image = UIImage.init(named: "radioSelected")
            self.modeOfTradingErrStack.isHidden = true
            self.tradingDateStack.isHidden = false
        }
        self.startedTradingNoView.addTapGestureRecognizer {
            self.selectedTrading = .No
            self.startedTradingYesImage.image = UIImage.init(named: "radioUnselected")
            self.startedTradingNoImage.image = UIImage.init(named: "radioSelected")
            self.modeOfTradingErrStack.isHidden = true
            self.tradingDateStack.isHidden = true
//            self.showAlert(title: "Info", message: "Unfortunately you are not eligible at the moment after the submit option")
        }
        self.profitableYesView.addTapGestureRecognizer {
            self.selectedProfitable = .Yes
            self.profitableNoImage.image = UIImage.init(named: "radioUnselected")
            self.profitableYesImage.image = UIImage.init(named: "radioSelected")
            self.modeOfProfitableErrStack.isHidden = true
        }
        self.profitableNoView.addTapGestureRecognizer {
            self.selectedProfitable = .No
            self.profitableYesImage.image = UIImage.init(named: "radioUnselected")
            self.profitableNoImage.image = UIImage.init(named: "radioSelected")
            self.modeOfProfitableErrStack.isHidden = true
        }
        self.acceptCardYesView.addTapGestureRecognizer {
            self.selectedAcceptCard = .Yes
            self.acceptCardNoImage.image = UIImage.init(named: "radioUnselected")
            self.acceptCardYesImage.image = UIImage.init(named: "radioSelected")
            self.modeOfAcceptCardErrStack.isHidden = true
            self.annualSalesStack.isHidden = false
        }
        self.acceptCardNoView.addTapGestureRecognizer {
            self.selectedAcceptCard = .No
            self.acceptCardYesImage.image = UIImage.init(named: "radioUnselected")
            self.acceptCardNoImage.image = UIImage.init(named: "radioSelected")
            self.modeOfAcceptCardErrStack.isHidden = true
            self.annualSalesStack.isHidden = true
        }
        self.nextButton.addTapGestureRecognizer {
            self.checkLoanStatus(loanId: self.loanId)
            if (canEditForms && GlobalmodeOfApplication != .Representative) || self.delegate != nil{
                self.isValidTextFields()
                
                if self.goNext() {
                    if self.selectedTrading == .No {
                        self.showAlert(title: "Info", message: "Unfortunately you are not eligible at the moment after the submit option")
                    }
                    else if self.selectedAcceptCard == .No {
                        self.showAlert(title: "Info", message: "Unfortunately you are not eligible at the moment after the submit option")
                    }
                    else if self.selectedProfitable == .No {
                        self.showAlert(title: "Info", message: "Unfortunately you are not eligible at the moment after the submit option")
                    }
                    else{
                        self.updateModel()
//                        print("go next")
//                        var vc = PremiseDetailsViewController.initWithStory()
//                        GlobalFundingModelObject.business.directorArray = self.viewModel.directorNameArray
//                        vc.modalPresentationStyle = .overCurrentContext
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }}else{
                   self.updateModel()
                    var vc = PremiseDetailsViewController.initWithStory(loanId: self.loanId)
                    GlobalFundingModelObject.business.directorArray = self.viewModel.directorNameArray
                    vc.modalPresentationStyle = .overCurrentContext
                    self.navigationController?.pushViewController(vc, animated: true)
                }
        }
        self.backButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func updateModel() {
        let model = GlobalFundingModelObject
        var initial = BusinessModel()
        initial.businessType = self.businessTypeTF.text ?? ""
        initial.numberOfDirectors = self.numberOfDirectorsTF.text ?? ""
        initial.directorArray = self.viewModel.directorNameArray
        initial.remainingDirectorArray = self.viewModel.directorNameArray
        initial.isStartedTrading = self.selectedTrading == .Yes ? true : false
        initial.isProfitable = self.selectedProfitable == .Yes ? true : false
        initial.isAcceptCard = self.selectedAcceptCard == .Yes ? true : false
        initial.tradingDate = self.dateLabel.text ?? ""
        initial.turnOver = self.annualTurnOverTF.text ?? ""
        initial.salesTurnOver = self.annaulSalesTF.text ?? ""
        initial.businessSector = self.businessSectorTypeTF.text ?? ""
        initial.otherBusinessSector = self.otherFundingPurposeTF.text ?? ""
        model.business = initial
        var i = 0
        for _ in self.viewModel.directorNameArray {
            var obj = DirectorModel()
            obj.id = i
            model.directors.append(obj)
            i = i + 1
        }
        var array = [Director]()
        for (index,element) in self.viewModel.directorNameArray.enumerated() {
            let obj = Director(id: element.id != 0 ? element.id : 0, title: element.title, firstName: element.firstName, lastName: element.lastName,phoneNumber: element.phoneNumber,email: element.email,ownsOtherProperty: element.ownsOtherProperty,ownedProperty: element.ownedProperty,ownedPropertyCount: element.ownedPropertyCount,stay: element.stay)
                array.append(obj)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
        let fromDateString = dateFormatter.string(from: tradeDate ?? Date())
        var businessType = initial.businessType.description == "Limited Partnership (LLP)" ? "Limited Partnership" : initial.businessType.description

//        let parameters: [String: Any] = [
//            "business_type": businessType,
//            "number_of_directors": numberOfDirectors,
//            "has_started_trading": self.selectedTrading == .Yes ? "Yes" : "No",
//            "start_trading_date": fromDateString,
//            "is_profitable": self.selectedProfitable == .Yes ? "Yes" : "No",
//            "accepts_card_payment": self.selectedAcceptCard == .Yes ? "Yes" : "No",
//            "average_weekly_card_sales": self.annualSalesLabel.text?.split(separator: "-").first?.replacingOccurrences(of: "£", with: "") ?? "",
//            "average_monthly_turnover": self.turnOverLabel.text?.split(separator: "-").first?.replacingOccurrences(of: "£", with: "") ?? "",
//            "business_sector": self.businessSectorTypeTF.text ?? "",
//            "other_business_name": self.otherFundingPurposeTF.text ?? "",
//            "directors": array.map { $0.dictionaryRepresentation }
//        ]
        let parameters: [String: Any] = [
            "business_type": businessType,
            "number_of_directors": numberOfDirectors,
            "has_started_trading": self.selectedTrading == .Yes ? "Yes" : "No",
            "start_trading_date": fromDateString,
            "is_profitable": self.selectedProfitable == .Yes ? "Yes" : "No",
            "accepts_card_payment": self.selectedAcceptCard == .Yes ? "Yes" : "No",
            "average_weekly_card_sales": self.annaulSalesTF.text ?? "",
            "average_monthly_turnover": self.annualTurnOverTF.text ?? "",
            "business_sector": self.businessSectorTypeTF.text ?? "",
            "other_business_name": self.otherFundingPurposeTF.text ?? "",
            "directors": array.map { $0.dictionaryRepresentation }
        ]
        if (canEditForms && GlobalmodeOfApplication != .Representative) || self.delegate != nil {
            self.createBusinessDetails(params: parameters)
        }else{
            
        }


    }
    func updateFilledForms(){
        var params = JSON()
        params["complete_business_detail"] = "True"
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
    func createBusinessDetails(params: JSON) {
        var url = APIEnums.createBusiness.rawValue
        if loanId != "" {
            url = url + "\(loanId)/"
        }
        if customerId != "" {
            url = url + "?customer_id=\(customerId)"
        }
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.updateFilledForms()
                    if self.delegate != nil {
                        self.delegate?.reload()
                        self.dismiss(animated: true)
                    }else{
                        var vc = PremiseDetailsViewController.initWithStory(loanId: self.loanId)
                        GlobalFundingModelObject.business.directorArray = self.viewModel.directorNameArray
                        vc.modalPresentationStyle = .overCurrentContext
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(params: params)
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

                    self.createBusinessDetails(params: params)
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
    func fetchBusinessDetails(customerId: String) {
        APIService.shared.retrieveBusinessDetailsFromAgent(customerId: customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedBusinessResponse = responseData
                        self.showModelValues()
                    }
                    catch {
                        
                    }
                }
                else {
                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
                //self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func fetchBusinessDetails() {
        APIService.shared.retrieveBusinessFormDetails(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedBusinessResponse = responseData
                        self.showModelValues()
                    }
                    catch {
                        
                    }
                }
                else {
                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
                //self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    //---------------------------------------
    // MARK: - WS Function
    //---------------------------------------
    func encodeAnyDict(dictionary: [String: Any?]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error encoding dictionary to JSON string: \(error)")
        }
        return nil
    }
    func encodeAnyArray(array: [JSON]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error encoding dictionary to JSON string: \(error)")
        }
        return nil
    }
    func encodeDict(with: [String: String]) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(with)
            // jsonData is the JSON data
            print("Encoded JSON data: \(String(data: jsonData, encoding: .utf8)!)")
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
            return nil
        } catch {
            print("Error encoding JSON: \(error)")
            return nil
        }
    }
    
    func callBusinessDetailsAPI(parms: [AnyHashable: Any],directors: [Director]){
        self.viewModel
            .BusinessDetailsApicall(parms: parms){(result) in
                switch result{
                case .success:
                    var vc = PremiseDetailsViewController.initWithStory(loanId: self.loanId)
                    GlobalFundingModelObject.business.directorArray = self.viewModel.directorNameArray
                    vc.modalPresentationStyle = .overCurrentContext
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    break
                }
            }
    }
    func hideDirectorsTable(){
        self.dropdownType = .Director
        self.directorTableHidden = true//!self.directorTableHidden
        self.showHideTable()
    }
    func showDirectorsTable() {
        self.dropdownType = .Director
        self.directorTableHidden = false//!self.directorTableHidden
        self.showHideTable()
    }
    func updateUI()
    {
        self.directorTableHidden = true
        self.numberOfDirectorsStack.isHidden = true
        self.showHideTable()
        self.otherFundingPurposeStack.isHidden = true
        self.addObserverOnHeightTbl()
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //self.dateTF.placeholder = dateFormatter.string(from: date )
        self.annualSalesStack.isHidden = true
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 1)
        self.sliderView.scaleMinValue = 4000
        self.sliderView.scaleMaxValue = 1000000
        self.salesSlider.scaleMinValue = 1000
        self.salesSlider.scaleMaxValue = 250000
        let model = GlobalFundingModelObject
        var initial = model.initial
        self.selectedBusinessType = initial.businessType
        self.businessTypeTF.text = self.selectedBusinessType?.description
        self.updateNumberOfDirectorsView()
        self.salesSliderNew.setThumbImage(UIImage(named: "sliderTint"), for: .normal)
        self.annualTurnNew.setThumbImage(UIImage(named: "sliderTint"), for: .normal)
        self.annualTurnNew.minimumValue = 4000
        self.annualTurnNew.maximumValue = 1000000
        self.salesSliderNew.minimumValue = 1000
        self.salesSliderNew.maximumValue = 250000

    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }
    func showHideTable() {
        switch self.dropdownType {
        case .Business:
            if self.businessTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .Director:
            if self.directorTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .BusinessSector:
            if self.businessSectorTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        default:
            break
        }
    }
    @IBAction func salesSliderValueChanged(_ sender: Any) {
        self.annaulSalesTF.text = Int(salesSliderNew.value).description
        if Int(salesSliderNew.value) > 0 {
            self.annualSalesErrStack.isHidden = true
            self.annualSalesLabel.text = "£ \(Int(salesSliderNew.value))"
        }
    }
    @IBAction func sliderValueChanged(_ sender: Any) {
        self.annualTurnOverTF.text = Int(annualTurnNew.value).description
        if Int(annualTurnNew.value) > 0 {
            self.annualTurnOverErrStack.isHidden = true
            self.turnOverLabel.text = "£ \(Int(annualTurnNew.value))"
        }
    }
}
extension FundingViewController {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                switch self.dropdownType {
                case .Business:
                    self.businessTable.isHidden = false
                    self.businessTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.businessTableHeight.constant = CGFloat(self.viewModel.businessTypeArray.count * 50)
                    self.businessTable.reloadData()
                    self.view.layoutIfNeeded()
                case .Director:
                    self.directorDetailsTable.isHidden = false
                    self.directorDetailsLabelView.isHidden = false
//                    self.directorDetailsTableHeight.constant = CGFloat(self.numberOfDirectors * 90 + 200)
                    self.directorDetailsTable.reloadData()
                    self.view.layoutIfNeeded()
                case .BusinessSector:
                    self.businessSectorTable.isHidden = false
                    self.businessSectorTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.businessSectorTableHeight.constant = CGFloat(self.viewModel.businessSectorTypeArray.count * 50)
                    self.businessSectorTable.reloadData()
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
            case .Business:
                self.businessTable.isHidden = true
                self.businessTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.businessTableHeight.constant = 0
                self.businessTable.reloadData()
            case .Director:
                self.directorDetailsTable.isHidden = true
                self.directorDetailsLabelView.isHidden = true
//                self.directorDetailsTableHeight.constant = 0
                self.directorDetailsTable.reloadData()
            case .BusinessSector:
                self.businessSectorTable.isHidden = true
                self.businessSectorTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.businessSectorTableHeight.constant = 0
                self.businessSectorTable.reloadData()
            default:
                break

            }
        }, completion: nil)
    }
    
    func goNext() -> Bool {
        if (self.selectedBusinessType?.description == nil || self.selectedBusinessType?.description == "") {
            return false
        }
        if (self.selectedBusinessType?.description != nil || self.selectedBusinessType?.description != "") && self.numberOfDirectors == 0 {
            return false
        }
        if (self.selectedBusinessSectorType?.description == nil || self.selectedBusinessSectorType?.description == "") {
            return false
        }
        if (self.tradeDate == nil && selectedTrading == .Yes && self.selectedBusinessResponse == nil) {
            return false
        }
        if self.turnOverLabel.text?.trim() == "" {
            return false
        }
        if self.turnOverLabel.text?.trim() != "" {
            var text = self.turnOverLabel.text?.trim()
            if text?.toInt() ?? 0 < 0 {
                return false
            }
        }
//        if self.annualSalesLabel.text?.trim() == "" && !self.annualSalesStack.isHidden {
//            return false
//        }
//        if self.annualSalesLabel.text?.trim() != "" && !self.annualSalesStack.isHidden{
//            var text = self.annualSalesLabel.text?.trim()
//            if text?.toInt() ?? 0 < 0 {
//                return false
//            }
//        }
        if self.selectedAcceptCard == .Yes && self.annualSalesLabel.text == "" {
            return false
        }
//        if self.selectedAcceptCard == .Yes && (self.weeklyCardSalesTF.text?.toInt() ?? 0 < 1000 || self.weeklyCardSalesTF.text?.toInt() ?? 0 > 250000) {
//                return false
//            }
        if (self.selectedTrading == .none) {
            return false
        }
        if (self.selectedProfitable == .none) {
            return false
        }
        if (self.selectedAcceptCard == .none) {
            return false
        }
        for element in self.viewModel.directorNameArray {
            if element.firstName == "" || element.lastName == "" || element.title == "" {
                return false
            }
        }
        if !otherFundingPurposeStack.isHidden && (self.otherFundingPurposeTF.text == nil || self.otherFundingPurposeTF.text == "") {
            return false
        }
        return true
    }

func isValidTextFields() {
    
    if (self.selectedBusinessSectorType?.description == nil || self.selectedBusinessSectorType?.description == "") {
        self.businessSectorTypeErrStack.isHidden = false
        self.businessSectorTypeErrLabel.text = "Please select business sector type"
    }
    if (self.tradeDate == nil && selectedTrading == .Yes && self.selectedBusinessResponse == nil) {
        self.tradingDateErrStack.isHidden = false
        self.tradingDateErrLabel.text = "Please choose the date"
    }
    if self.turnOverLabel.text?.trim() == "" {
        self.annualTurnOverErrStack.isHidden = false
        self.annualTurnOverErrLabel.text = "Please enter annual TurnOver"
    }
    if self.turnOverLabel.text?.trim() != "" {
        var text = self.turnOverLabel.text?.trim()
        if text?.toInt() ?? 0 < 0 {
            self.annualTurnOverErrStack.isHidden = false
            self.annualTurnOverErrLabel.text = "Please enter annual TurnOver above 0"
        }
    }
    if self.annualSalesLabel.text?.trim() == "" && !self.annualSalesStack.isHidden {
        self.annualSalesErrStack.isHidden = false
        self.annualSalesErrLabel.text = "Please enter annual TurnOver"
    }
    if self.annualSalesLabel.text?.trim() != "" && !self.annualSalesStack.isHidden {
        var text = self.annualSalesLabel.text?.trim()
        if text?.toInt() ?? 0 < 0 {
            self.annualSalesErrStack.isHidden = false
            self.annualSalesErrLabel.text = "Please enter annual Sales above 0"
        }
    }
    if self.selectedAcceptCard == .Yes && self.annualSalesLabel.text == "" {
        self.annualSalesErrStack.isHidden = false
        self.annualSalesErrLabel.text = "Please enter Weekly card sales"
    }
//    if self.selectedAcceptCard == .Yes && (self.weeklyCardSalesTF.text?.toInt() ?? 0 < 1000 || self.weeklyCardSalesTF.text?.toInt() ?? 0 > 250000) {
//        self.annualSalesErrStack.isHidden = false
//        self.annualSalesErrLabel.text = "Please enter Weekly card sales between £1000 and £250000"
//    }
    if (self.selectedTrading == .none) {
        self.modeOfTradingErrStack.isHidden = false
        self.modeOfTradingErrLabel.text = "Please choose anyone"
    }
    if (self.selectedProfitable == .none) {
        self.modeOfProfitableErrStack.isHidden = false
        self.modeOfProfitableErrLabel.text = "Please choose anyone"
    }
    if (self.selectedAcceptCard == .none) {
        self.modeOfAcceptCardErrStack.isHidden = false
        self.modeOfAcceptCardErrLabel.text = "Please choose anyone"
    }
    self.businessTypeErrStack.isHidden = true

    for element in self.viewModel.directorNameArray {
        if element.firstName == "" || element.lastName == "" || element.title == "" {
            self.businessTypeErrStack.isHidden = false
            self.businessTypeErrLabel.text = "Please fill the details"
        }
    }
    if (self.selectedBusinessType?.description == nil || self.selectedBusinessType?.description == "") {
        self.businessTypeErrStack.isHidden = false
        self.businessTypeErrLabel.text = "Please select business type"
    }
    if (self.selectedBusinessType?.description != nil || self.selectedBusinessType?.description != "") && self.numberOfDirectors == 0 {
        self.businessTypeErrStack.isHidden = false
        self.businessTypeErrLabel.text = "Please fill the details"
    }
    if !otherFundingPurposeStack.isHidden && (self.otherFundingPurposeTF.text == nil || self.otherFundingPurposeTF.text == "") {
        self.otherfundingProcessErrStack.isHidden = false
        self.otherfundingProcessErrLabel.text = "Please fill the details"
    }
}
    func updateNumberOfDirectorsView() {
        self.businessMemberType = BusinessMemberType(rawValue: self.selectedBusinessType?.id ?? 0) ?? .none
        self.numberOfDirectorsStack.isHidden = self.businessMemberType == .SoleTrade ? true : false
        self.numberOfDirectorsTF.placeholder = self.businessMemberType == .Director ? "Number of Directors" :"Number of Partners"
        switch self.businessMemberType {
        case .SoleTrade:
            self.directorDetailsLabel.text = "Proprietor Details"
        case .Director:
            self.directorDetailsLabel.text = "Director Details"
        case .Partner:
            self.directorDetailsLabel.text = "Partner Details"
        default:
            self.directorDetailsLabel.text = "Proprietor Details"
        }
//        if self.selectedBusinessResponse == nil {
//            self.numberOfDirectorsTF.text = ""
//            self.numberOfDirectors = 0
//            if self.businessMemberType == .SoleTrade {
//    //                    self.dropdownType = .Director
//    //                    self.removeTransparentView()
//                self.numberOfDirectors = 1
//                self.viewModel.createDirectorArray(count: 1,fundingModel: GlobalFundingModelObject )
//                self.showDirectorsTable()
//            }else{
//                self.hideDirectorsTable()
//            }
//        }else {
            self.viewModel.createDirectorArray(count: self.numberOfDirectors != 0 ? self.numberOfDirectors : 1,selectedArray: self.selectedBusinessResponse?.directors ?? [SelectedDirector]())
            self.showDirectorsTable()
//        }
        
    }
}
extension FundingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch self.dropdownType {
        case .Business:
            count = self.viewModel.businessTypeArray.count
        case .Director:
            count = self.numberOfDirectors
        case .BusinessSector:
            count = self.viewModel.businessSectorTypeArray.count
        default:
            break
            
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.dropdownType == .Business {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            cell.documentLabel.text = self.viewModel.businessTypeArray.value(atSafe: indexPath.row)?.description
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.viewModel.businessTypeArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                self.businessTypeTF.text = "\(self.viewModel.businessTypeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedBusinessType = self.viewModel.businessTypeArray.value(atSafe: indexPath.row)
                self.businessTableHidden = !self.businessTableHidden
                self.dropdownType = .Business
                self.removeTransparentView()
                self.businessTypeErrStack.isHidden = true
                self.updateNumberOfDirectorsView()
            }
        }
        else if self.dropdownType == .Director && tableView == self.directorDetailsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as? NameCell else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.directorNameArray.value(atSafe: indexPath.row) else {return UITableViewCell()}
            
            if model.isExtended ?? false{
                cell.nameTable.isHidden = false
                cell.nameTableHidden = false
                cell.showHideTable()
                
            }else{
                cell.nameTable.isHidden = true
                cell.nameTableHidden = true
                cell.showHideTable()
                
            }
            cell.model = model
            cell.firstNameTF.text = indexPath.row == 0 ? (model.firstName == "" ? GlobalFundingModelObject.initial.firstName : model.firstName) : model.firstName
            cell.lastNameTF.text = indexPath.row == 0 ? (model.lastName == "" ? GlobalFundingModelObject.initial.lastName : model.lastName) : model.lastName
            cell.imageLabel.text = indexPath.row == 0 ? (model.title == "" ? GlobalFundingModelObject.initial.title : model.title) : model.title

            cell.delegate = self
            cell.imageLabel.text = model.title == "" ? "\(self.viewModel.nameArray.first?.description ?? "")" : model.title
            cell.model.title = model.title == "" ? "\(self.viewModel.nameArray.first?.description ?? "")" : model.title
            cell.imageActionView.addTapGestureRecognizer {
                cell.nameTableHidden = !cell.nameTableHidden
                guard let model = self.viewModel.directorNameArray.value(atSafe: indexPath.row) else {return}
                model.isExtended = !(model.isExtended ?? false)
                cell.showHideTable()
                self.directorDetailsTable.reloadData()
            }
            return cell
        }
        else if self.dropdownType == .BusinessSector && tableView == businessSectorTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? CellClass3 else {
                return UITableViewCell()
            }
            cell.label2.text = self.viewModel.businessSectorTypeArray.value(atSafe: indexPath.row)?.description
            cell.action2.setTitle("", for: .normal)
            cell.separator2.isHidden = (indexPath.row == self.viewModel.businessSectorTypeArray.count - 1)
            cell.action2.addTapGestureRecognizer {
                self.businessSectorTypeTF.text = "\(self.viewModel.businessSectorTypeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedBusinessSectorType = self.viewModel.businessSectorTypeArray.value(atSafe: indexPath.row)
                self.businessSectorTableHidden = !self.businessSectorTableHidden
                self.dropdownType = .BusinessSector
                self.removeTransparentView()
                if self.selectedBusinessSectorType?.description == self.viewModel.businessSectorTypeArray.value(atSafe: self.viewModel.businessSectorTypeArray.count - 1)?.description ?? "" {
                    self.otherFundingPurposeStack.isHidden = false
                }else{
                    self.otherFundingPurposeStack.isHidden = true
                }
                self.businessSectorTypeErrStack.isHidden = true
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == businessTable || tableView == businessSectorTable {
            return 50
        }else{
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    }
extension FundingViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case self.annualTurnOverTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowDecimal.rawValue)
            let result      = eTest.evaluate(with: newText)
            return result
        case self.annaulSalesTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowDecimal.rawValue)
            let result      = eTest.evaluate(with: newText)
            return result
        default: break
        }
        
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.otherFundingPurposeTF {
            self.otherfundingProcessErrStack.isHidden = true
        }
        if textField == self.weeklyCardSalesTF {
            self.annualSalesErrStack.isHidden = true
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.numberOfDirectorsTF {
            guard let count = textField.text?.toInt() else{
                return
            }
            numberOfDirectors = count
            if count >= 2 {
                self.viewModel.createDirectorArray(count: count,selectedArray: self.selectedBusinessResponse?.directors ?? [SelectedDirector]())
                self.showDirectorsTable()
                self.businessTypeErrStack.isHidden = true
            }else{
                self.businessTypeErrStack.isHidden = false
                self.businessTypeErrLabel.text = "Number of Directors must be 2 or more"
            }
        }
        if textField == self.annualTurnOverTF {
            guard let count = textField.text?.toFloat() else{
                return
            }
            self.annualTurnNew.value = Float(count)
            self.turnOverLabel.text = "£ \(Float(count))"
            if count > 0.00 {
                self.annualTurnOverErrStack.isHidden = true
            }
        }
        if textField == self.annaulSalesTF {
            guard let count = textField.text?.toFloat() else{
                return
            }
            self.salesSliderNew.value = Float(count)
            self.annualSalesLabel.text = "£ \(Float(count))"
            if count > 0.00 {
                self.annualSalesErrStack.isHidden = true
            }
        }
        if textField ==  self.otherFundingPurposeTF  {
            if (self.otherFundingPurposeTF.text == nil || self.otherFundingPurposeTF.text == "") {
                self.otherfundingProcessErrStack.isHidden = false
                self.otherfundingProcessErrLabel.text = "Please fill the details"
            }}
        if textField == self.weeklyCardSalesTF {
            if self.selectedAcceptCard == .Yes && self.weeklyCardSalesTF.text == "" {
                self.annualSalesErrStack.isHidden = false
                self.annualSalesErrLabel.text = "Please enter Weekly card sales"
            }
            else if self.selectedAcceptCard == .Yes && (self.weeklyCardSalesTF.text?.toInt() ?? 0 < 1000 || self.weeklyCardSalesTF.text?.toInt() ?? 0 > 250000) {
                self.annualSalesErrStack.isHidden = false
                self.annualSalesErrLabel.text = "Please enter Weekly card sales between £1000 and £250000"
            }
        }
    }
}
extension FundingViewController: CellDelegate{
    func reload() {
        self.directorDetailsTable.reloadData()
    }
    func particularReloadOf() {
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension FundingViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.directorDetailsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.directorDetailsTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.directorDetailsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.directorDetailsTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
extension FundingViewController : RangeUISliderDelegate {
    func rangeChangeFinished(minValueSelected: CGFloat, maxValueSelected: CGFloat, slider: RangeUISlider) {
        print(minValueSelected)
        print(maxValueSelected)
        if slider.identifier == 1 {
//            if minValueSelected.description.toInt() ?? 0 < 5000 || minValueSelected.description.toInt() ?? 0 > 100000 {
//                self.annualTurnOverErrStack.isHidden = false
//                self.annualTurnOverErrLabel.text = "Please enter annual TurnOver between 5000 and 1,00,000"
//
//            }else{
              //  self.turnOverLabel.text = "£\(minValueSelected.description.toInt()) - £\(maxValueSelected.description.toInt())"
                self.annualTurnOverErrStack.isHidden =  minValueSelected.description.toInt() >= 0 ? true : false

//            }
            
        }else{
            //self.annualSalesLabel.text = "£\(minValueSelected.description.toInt()) - £\(maxValueSelected.description.toInt())"
            self.annualSalesErrStack.isHidden = minValueSelected.description.toInt() >= 0 ? true : false

        }
    }
}
import Foundation
import CoreGraphics

/**
 A range change event.
 */
@objc public class RangeUISliderChangeEvent: NSObject {
    /// The minimum value selected.
    public let minValueSelected: CGFloat
    /// The max value selected.
    public let maxValueSelected: CGFloat
    /// The slider that generated the event
    public let slider: RangeUISlider

    init(minValueSelected: CGFloat, maxValueSelected: CGFloat, slider: RangeUISlider) {
        self.minValueSelected = minValueSelected
        self.maxValueSelected = maxValueSelected
        self.slider = slider
    }
}

/**
 A range change finished event.
 */
@objc public class RangeUISliderChangeFinishedEvent: NSObject {
    /// The minimum value selected.
    public let minValueSelected: CGFloat
    /// The max value selected.
    public let maxValueSelected: CGFloat
    /// The slider that generated the event.
    public let slider: RangeUISlider
    /// A boolean indicating if there was a user interaction.
    public let userInteraction: Bool

    init(minValueSelected: CGFloat, maxValueSelected: CGFloat, slider: RangeUISlider, userInteraction: Bool) {
        self.minValueSelected = minValueSelected
        self.maxValueSelected = maxValueSelected
        self.slider = slider
        self.userInteraction = userInteraction
    }
}
