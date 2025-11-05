//
//  PersonalViewController.swift
//  Credit4Business
//
//  Created by MacMini on 27/03/24.
//

import UIKit
import StepProgressBar
import IQKeyboardManagerSwift

class PersonalViewController: BaseViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTableHeight: NSLayoutConstraint!
    @IBOutlet weak var nameTable: UITableView!
    @IBOutlet weak var nameTableArrowActionView: UIView!
    @IBOutlet weak var nameTableArrow: UIImageView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    
    
    @IBOutlet weak var dobTF: UITextField!
    var dateOfBirth = Date()
    @IBOutlet weak var dobErrLabel: UILabel!
    @IBOutlet weak var dobErrStack: UIStackView!

    @IBOutlet weak var passwordErrLabel: UILabel! //tradingstyle
    @IBOutlet weak var passwordErrStack: UIStackView!
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var pincodeTF: UITextField!
    @IBOutlet weak var pincodeTableHeight: NSLayoutConstraint!
    @IBOutlet weak var pincodeTable: UITableView!
    @IBOutlet weak var pincodeTableArrowActionView: UIView!
    @IBOutlet weak var pincodeTableArrow: UIImageView!
    @IBOutlet weak var pincodeErrLabel: UILabel!
    @IBOutlet weak var pincodeErrStack: UIStackView!

    @IBOutlet weak var cityErrLabel: UILabel! //new based on company number
    @IBOutlet weak var cityErrStack: UIStackView!
    @IBOutlet weak var cityTF: UITextField!

    @IBOutlet weak var nextButton: UIButton!
   
    @IBOutlet weak var amountView: UIStackView! //other funding process
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var amountErrLabel: UILabel!
    @IBOutlet weak var amountErrStack: UIStackView!

    @IBOutlet weak var durationView: UITextField! // funding process
    @IBOutlet weak var durationTF: UITextField!
    @IBOutlet weak var durationTableHeight: NSLayoutConstraint!
    @IBOutlet weak var durationTable: UITableView!
    @IBOutlet weak var durationTableArrowActionView: UIView!
    @IBOutlet weak var durationTableArrow: UIImageView!
    @IBOutlet weak var durationErrLabel: UILabel!
    @IBOutlet weak var durationErrStack: UIStackView!

    
    @IBOutlet weak var pendingAgreeButton: UIButton!
    @IBOutlet weak var pendingAgreementView: UIView!
    @IBOutlet weak var authorizeAgreeButton: UIButton!
    @IBOutlet weak var agreementView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var emailErrStack: UIStackView!
    @IBOutlet weak var NameErrLabel: UILabel!
    @IBOutlet weak var NameErrStack: UIStackView!
    @IBOutlet weak var phoneErrLabel: UILabel!
    @IBOutlet weak var phoneErrStack: UIStackView!
  
    @IBOutlet weak var pageControl: CustomPageControl!
    
    
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var verifiedButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var sendOTPButton: UIButton!
    


    @IBOutlet weak var agreeButton1: UIButton!
    @IBOutlet weak var agreementView1: UIStackView!
    @IBOutlet weak var agreeButton2: UIButton!
    @IBOutlet weak var agreementView2: UIStackView!
    @IBOutlet weak var ageAgreeButton1: UIButton!
    @IBOutlet weak var ageAgreeView1: UIStackView!

    
    @IBOutlet weak var weeklyInstallment: UITextField!
    @IBOutlet weak var repaymentAmountTF: UITextField!
    
    @IBOutlet weak var paymentDayTF: UITextField!
    @IBOutlet weak var paymentDayErrLabel: UILabel!
    @IBOutlet weak var paymentDayErrStack: UIStackView!
    @IBOutlet weak var paymentDayTableHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentDayTable: UITableView!
    @IBOutlet weak var paymentDayTableArrowActionView: UIView!
    @IBOutlet weak var paymentDayTableArrow: UIImageView!
    
    @IBOutlet weak var businessTypeView: UITextField!
    @IBOutlet weak var businessTypeTF: UITextField!
    @IBOutlet weak var businessTableHeight: NSLayoutConstraint!
    @IBOutlet weak var businessTable: UITableView!
    @IBOutlet weak var businessTableArrowActionView: UIView!
    @IBOutlet weak var businessTableArrow: UIImageView!
    @IBOutlet weak var businessTypeErrLabel: UILabel!
    @IBOutlet weak var businessTypeErrStack: UIStackView!

    @IBOutlet weak var tradingStyleView: UIView!
    @IBOutlet weak var tradingStyleTF: UITextField!
    @IBOutlet weak var tradingStyleErrLabel: UILabel!
    @IBOutlet weak var tradingStyleErrStack: UIStackView!

   
    @IBOutlet weak var companyNoView: UIStackView!
    @IBOutlet weak var companyNoTF: UITextField!
    @IBOutlet weak var companyNumberErrLabel: UILabel!
    @IBOutlet weak var companyNumberErrStack: UIStackView!

    @IBOutlet weak var companyNameTF: UITextField!
    @IBOutlet weak var companyNameErrLabel: UILabel!
    @IBOutlet weak var companyNameErrStack: UIStackView!
    @IBOutlet weak var companyNameTableHeight: NSLayoutConstraint!
    @IBOutlet weak var companyNameTable: UITableView!
    @IBOutlet weak var companyNameTableArrowActionView: UIView!
    @IBOutlet weak var companyNameTableArrow: UIImageView!

    
    @IBOutlet weak var fundingProcessView: UITextField!
    @IBOutlet weak var fundingProcessTF: UITextField!
    @IBOutlet weak var fundingTableHeight: NSLayoutConstraint!
    @IBOutlet weak var fundingTable: UITableView!
    @IBOutlet weak var fundingTableArrowActionView: UIView!
    @IBOutlet weak var fundingTableArrow: UIImageView!
    @IBOutlet weak var fundingProcessErrLabel: UILabel!
    @IBOutlet weak var fundingProcessErrStack: UIStackView!

    @IBOutlet weak var otherFundingPurposeStack: UIStackView!
    @IBOutlet weak var otherFundingPurposeView: UIStackView!
    @IBOutlet weak var otherFundingPurposeTF: UITextField!
    @IBOutlet weak var otherfundingProcessErrLabel: UILabel!
    @IBOutlet weak var otherfundingProcessErrStack: UIStackView!

    @IBOutlet weak var representativeImage: UIImageView!
    @IBOutlet weak var representativeView: UIView!
    @IBOutlet weak var selfImage: UIImageView!
    @IBOutlet weak var selfView: UIView!
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var representativeViewStack: UIStackView!
    @IBOutlet weak var representativeTableHeight: NSLayoutConstraint!
    @IBOutlet weak var representativeTable: UITableView!
    @IBOutlet weak var representativeTableArrowActionView: UIView!
    @IBOutlet weak var representativeTableArrow: UIImageView!
    @IBOutlet weak var representativeTypeView: UITextField!
    @IBOutlet weak var representativeTypeTF: UITextField!
    
    @IBOutlet weak var repAgreeButton1: UIButton!
    @IBOutlet weak var repAgreeButton1View: UIStackView!
    @IBOutlet weak var repAgreeButton2: UIButton!
    @IBOutlet weak var repAgreeButton2View: UIStackView!
    
    
    
    @IBOutlet weak var modeOfApplicationErrLabel: UILabel!
    @IBOutlet weak var modeOfApplicationErrStack: UIStackView!
    @IBOutlet weak var representativeErrLabel: UILabel!
    @IBOutlet weak var representativeErrStack: UIStackView!
    
    @IBOutlet weak var commentButton: UIImageView!
    //MARK: -------------------- Class Variable --------------------
    var selectedPersonalResponse : PersonalDataClass?
    var paymentDayTableHidden = true

    var cityTableHidden = true
    var companyNameTableHidden = true
    var durationTableHidden = true
    var nameTableHidden = true
    var isAuthorizeAgreed = false
    var isPendingAgreed = false
    var isAgreed1 = false
    var isAgreed2 = false
    var remainingOTPTime = 0
    var duration: TimeInterval = 200 * 60 // 200 minutes
    var isAge18Agreed = false
    let userDefaults = UserDefaults.standard
    var dropdownType : DropDownType = .none
    var viewModel = HomeVM()
    var selectedCity : String?
    var selectedCompanyName : String?
    var selectedCompanyNumber : String?
    var selectedCompanyPostalCode : String?
    var selectedCompanyAddress : String?

    var selectedDuration : Common?
    var selectedName : Common?
    var selectedMode : ModeOfApplication = .none
    var phone = ""
    var email = ""
    var isVerified = ""
    var representativeTableHidden = true
    var selectedRepresentative : Common?
    var OtpTimer : Timer?
    var customerId = ""
    var delegate : CellDelegate?
    var selectedPaymentDay : Common?
    var businessTableHidden = true
    var fundingProcessTableHidden = true
    var isRepAuthorizeAgreed = false
    var isRepPendingAgreed = false
    var selectedBusinessType : Common?
    var selectedFundingProcess : Common?
    var isEligibleCompanyLookup = true
    var loanId = ""
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.updateUI()
        self.manageActionMethods()
        if userDefaults.value(forKey: "isLogin") as? Bool == true {
            self.commentButton.isHidden = false
        }else{
            self.commentButton.isHidden = true
        }
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
        if UserDefaults.standard.value(forKey: "role") as? String != "" && isFromIncomplete {
            self.fetchPersonalDetails()
        }
        if self.selectedPersonalResponse != nil {
            self.showModelValues()
        }
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------
    
    class func initWithStory(loanId: String) -> PersonalViewController {
        let vc : PersonalViewController = UIStoryboard.Main.instantiateViewController()
        vc.loanId = loanId
        return vc
    }
    
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.pincodeTable.delegate = self
        self.pincodeTable.dataSource = self
        self.companyNameTable.delegate = self
        self.companyNameTable.dataSource = self
        self.durationTable.delegate = self
        self.durationTable.dataSource = self
        self.nameTable.delegate = self
        self.nameTable.dataSource = self
        self.dobTF.delegate = self
        self.emailTF.delegate = self
       // self.companyNoTF.delegate = self

        self.passwordTF.delegate = self
        self.cityTF.delegate = self
        self.firstNameTF.delegate = self
        self.lastNameTF.delegate = self
        self.phoneTF.delegate = self
        self.amountTF.delegate = self
        self.phoneTF.maxLength  = Validations.PhoneNumber.Minimum.rawValue
        self.durationTF.delegate = self
        self.dobTF.keyboardType = .default
        self.passwordTF.keyboardType = .default
       // self.companyNoTF.keyboardType = .numberPad
        self.pincodeTF.keyboardType = .default
        self.amountTF.keyboardType = .numberPad
        self.emailTF.keyboardType = .emailAddress
        self.firstNameTF.keyboardType = .default
        self.lastNameTF.keyboardType = .default
        self.phoneTF.keyboardType = .numberPad
        self.representativeTable.delegate = self
        self.representativeTable.dataSource = self
        self.pincodeTF.delegate = self
        self.paymentDayTable.delegate = self
        self.paymentDayTable.dataSource = self
        self.businessTable.delegate = self
        self.businessTable.dataSource = self
        self.fundingTable.delegate = self
        self.fundingTable.dataSource = self
        self.companyNameTF.delegate = self
        self.tradingStyleTF.delegate = self
        self.companyNoTF.delegate = self
        self.otherFundingPurposeTF.delegate = self
        self.representativeTypeTF.delegate = self
        self.companyNameTF.keyboardType = .default
        self.tradingStyleTF.keyboardType = .default
        self.companyNoTF.keyboardType = .numberPad

    }
    func updateUI()
    {
//        self.innerView.layer.borderWidth = 0.5
//        self.innerView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.dobView.layer.borderWidth = 0.5
//        self.dobView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.cityView.layer.borderWidth = 0.5
//        self.cityView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.passwordView.layer.borderWidth = 0.5
//        self.passwordView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.phoneView.layer.borderWidth = 0.5
//        self.phoneView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.emailView.layer.borderWidth = 0.5
//        self.emailView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.companyNoView.layer.borderWidth = 0.5
//        self.companyNoView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.firstNameView.layer.borderWidth = 0.5
//        self.firstNameView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.lastNameView.layer.borderWidth = 0.5
//        self.lastNameView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.durationView.layer.borderWidth = 0.5
//        self.durationView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.nameTableArrowActionView.layer.borderWidth = 0.5
//        self.nameTableArrowActionView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.amountView.layer.borderWidth = 0.5
//        self.amountView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
       
       
        self.titleLabel.text = self.viewModel.nameArray.first?.description
        self.selectedName = self.viewModel.nameArray.first
//        self.codeView.layer.borderWidth = 0.5
//        self.codeView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
       
//        email = self.userDefaults.value(forKey: "user_email") as? String ?? ""
//        phone = self.userDefaults.value(forKey: "user_phone") as? String ?? ""
//        isVerified = self.userDefaults.value(forKey: "isVerified") as? String ?? ""
//        if self.email != ""
//        {
//            self.emailTF.text = self.email
//            self.emailTF.isUserInteractionEnabled = false
//          
//        }
//        if self.phone != ""
//        {
//            self.phoneTF.text = self.phone
//            self.phoneTF.isUserInteractionEnabled = false
//           
//        }
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 0)
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
//        self.dobTF.placeholder = dateFormatter.string(from: date )
//        self.representativeTypeView.layer.borderWidth = 0.5
//        self.representativeTypeView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
        self.verifiedButton.isHidden = true
        self.repAgreeButton1View.isHidden = true
        self.repAgreeButton2View.isHidden = true
        self.innerView.isHidden = true
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = UIColor(named: "grayborder")?.cgColor

    }
    func calculateFees() {
        guard let funding = self.amountTF.text, let weeks = self.durationTF.text, funding != "", weeks != "" else{
            return
        }
        var merchant = 1.2
        var cost = (Double(weeks) ?? 0.00) * merchant
        var merchantPer = cost / 100
        var multiply = (1 + merchantPer)
        var repay = (Double(funding.toInt()) ) * multiply
        var installment = repay/Double(weeks.toInt())
        print(installment)
        self.repaymentAmountTF.text = "£ \(repay.description.toInt())"
        self.weeklyInstallment.text = "£ \(installment.description.toInt())"
    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }
    func manageActionMethods() {
//        self.pincodeTableArrowActionView.addTapGestureRecognizer {
//            self.dropdownType = .RegPost
//            self.cityTableHidden = !self.cityTableHidden
//            self.showHideTable()
//        }
//        self.pincodeTF.addTapGestureRecognizer {
//                    self.dropdownType = .RegPost
//                    self.cityTableHidden = !self.cityTableHidden
//                    self.showHideTable()
//        }
//        self.durationTableArrowActionView.addTapGestureRecognizer {
//            self.dropdownType = .Duration
//            self.durationTableHidden = !self.durationTableHidden
//            self.showHideTable()
//        }
//        self.durationTF.addTapGestureRecognizer {
//            self.dropdownType = .Duration
//            self.durationTableHidden = !self.durationTableHidden
//            self.showHideTable()
//        }
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanId)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.nameTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .Name
            self.nameTableHidden = !self.nameTableHidden
            self.showHideTable()
        }
        
//        self.dobTF.addTapGestureRecognizer {
//            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderViewController") as! CalenderViewController
//                 popup.modalPresentationStyle = .overFullScreen
//                 popup.isForSweepIn = true
//                 self.present(popup, animated: true, completion: nil)
//                 popup.dateSelectionHandler = { [weak self] fromDate, toDate in
//                     print(fromDate)
//                     let calendar = Calendar.current
//                     guard let year = calendar.dateComponents([.year], from: toDate, to: Date()).year else { return }
//                     self?.dateOfBirth = toDate
//                     self?.dobErrStack.isHidden = true
////                     if year < 18 {
////                         self?.dobErrStack.isHidden = false
////                         self?.dobErrLabel.text = "Age should be greater than or equal to 18"
////                     }
//
//                     self?.dobTF.text = fromDate
//                     self?.dismiss(animated: true)
//                 }
//            }
        self.dobTF.addTapGestureRecognizer {
            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                 popup.modalPresentationStyle = .overFullScreen
                 popup.isReadableFormat = true
                 self.present(popup, animated: true, completion: nil)
                 popup.dateSelectionHandler = { [weak self] fromDate, toDate in
                     print(fromDate)
                     let calendar = Calendar.current
                     guard let year = calendar.dateComponents([.year], from: toDate, to: Date()).year else { return }
                     self?.dateOfBirth = toDate
                     self?.dobErrStack.isHidden = true
                     if year < 18 {
                         self?.dobErrStack.isHidden = false
                         self?.dobErrLabel.text = "Age should be greater than or equal to 18"
                     }

                     self?.dobTF.text = fromDate
                     self?.dismiss(animated: true)
                 }
            }
        self.selfView.addTapGestureRecognizer {
            self.selectedMode = .SelfMode
            self.representativeImage.image = UIImage(systemName: "circle")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
            self.selfImage.image = UIImage(systemName: "dot.circle")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
            if self.isVerified == "true" {
              //  self.verifiedLabel.isHidden = false
            }else{
             //   self.verifiedLabel.isHidden = true
            }
//            self.agreementView.isHidden = true
//            self.pendingAgreementView.isHidden = true
            self.innerView.isHidden = true
            self.modeOfApplicationErrStack.isHidden = true
        }
        self.representativeView.addTapGestureRecognizer {
            self.selectedMode = .Representative
            self.representativeImage.image = UIImage(systemName: "dot.circle")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
            self.selfImage.image = UIImage(systemName: "circle")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//            if self.isVerified == "true" {
//                self.verifiedLabel.isHidden = false
//            }else{
//                self.verifiedLabel.isHidden = true
//            }
//            self.agreementView.isHidden = false
//            self.pendingAgreementView.isHidden = false
            self.innerView.isHidden = false
            self.modeOfApplicationErrStack.isHidden = true
        }
//        self.representativeTableArrowActionView.addTapGestureRecognizer {
//            self.dropdownType = .Representative
//            self.representativeTableHidden = !self.representativeTableHidden
//            self.showHideTable()
//        }
//        self.representativeTypeTF.addTapGestureRecognizer {
//            self.dropdownType = .Representative
//            self.representativeTableHidden = !self.representativeTableHidden
//            self.showHideTable()
//        }
        self.sendOTPButton.addTapGestureRecognizer {
            self.isValidSignupFields()
            if self.goSignup() {
                    var dicts = JSON()
                    dicts["phone_number"] = String(format:"%@",self.phoneTF.text!)
                if self.sendOTPButton.titleLabel?.text?.lowercased() as! String == "send" {
                    dicts["email"] = String(format:"%@",self.emailTF.text!)
                    self.callSignupAPI(parms: dicts)
                }else{
                    self.callResendOTPAPI(parms: dicts)
                }
            }
        }
        self.verifyButton.addTapGestureRecognizer {
            self.isValidSignupFields()
            if self.goSignup() {
//                if self.passwordTF.text != "000000"
//                {
//                    self.modeOfApplicationErrStack.isHidden = false
//                    self.modeOfApplicationErrLabel.text = "Invalid OTP"
//                }
//                else {
                    var dicts = JSON()
                    dicts["phone_number"] = String(format:"%@",self.phoneTF.text!)
                    dicts["otp"] = String(format:"%@",self.passwordTF.text!)
                    self.callOTPVerificationAPI(parms: dicts)
//                }
            }
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
        self.fundingTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .Funding
            self.fundingProcessTableHidden = !self.fundingProcessTableHidden
            self.showHideTable()
        }
        self.fundingProcessTF.addTapGestureRecognizer {
            self.dropdownType = .Funding
            self.fundingProcessTableHidden = !self.fundingProcessTableHidden
            self.showHideTable()
        }
      
        self.selfView.addTapGestureRecognizer {
            self.selectedMode = .SelfMode
//            self.representativeImage.image = UIImage(systemName: "circle")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//            self.selfImage.image = UIImage(systemName: "dot.circle")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//            if self.isVerified == "true" {
//                self.verifiedLabel.isHidden = false
//            }else{
//                self.verifiedLabel.isHidden = true
//                self.otpStackView.isHidden = false
//                self.otpStack.isHidden = false
//            }
            self.representativeImage.image = UIImage.init(named: "radioUnselected")
            self.selfImage.image = UIImage.init(named: "radioSelected")

            self.repAgreeButton1View.isHidden = true
            self.repAgreeButton2View.isHidden = true
            self.innerView.isHidden = true
            self.modeOfApplicationErrStack.isHidden = true
        }
        self.representativeView.addTapGestureRecognizer {
            self.selectedMode = .Representative
            self.selfImage.image = UIImage.init(named: "radioUnselected")
            self.representativeImage.image = UIImage.init(named: "radioSelected")
//            if self.isVerified == "true" {
//                self.verifiedLabel.isHidden = false
//            }else{
//                self.verifiedLabel.isHidden = true
//                self.otpStackView.isHidden = false
//                self.otpStack.isHidden = false
//            }
            self.repAgreeButton1View.isHidden = false
            self.repAgreeButton2View.isHidden = false
            self.innerView.isHidden = false
            self.modeOfApplicationErrStack.isHidden = true
        }
        self.nextButton.addTapGestureRecognizer {
            self.checkLoanStatus(loanId: self.loanId)
            if canEditForms {//&& GlobalmodeOfApplication != .Representative{
                self.isValidTextFields()
                if self.goNext() {
                    self.updateModel()
                    print("go next")
                }}else{
                    //self.updateModel()
                    var vc = FundingViewController.initWithStory(loanId: self.loanId)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            
        }
        self.paymentDayTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .PaymentDay
            self.paymentDayTableHidden = !self.paymentDayTableHidden
            self.showHideTable()
        }
        self.paymentDayTF.addTapGestureRecognizer {
            self.dropdownType = .PaymentDay
            self.paymentDayTableHidden = !self.paymentDayTableHidden
            self.showHideTable()
        }
       
    }
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", hours, minutes)
    }

    func startOTPTimer(){
        self.remainingOTPTime = 30

        if #available(iOS 10.0, *) {
           OtpTimer =  Timer.scheduledTimer(withTimeInterval: 1,
                                 repeats: true) { (timer) in
                self.handleRemainingOTPtime()
                self.remainingOTPTime -= 1
                self.duration = TimeInterval(self.remainingOTPTime * 60) // 200 minutes

                if self.remainingOTPTime <= 0 {//time reached
                    timer.invalidate()
                    self.canSendOTP()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    func canSendOTP(){
        self.timerButton.isHidden = true
        self.sendOTPButton.setTitle("Resend", for: .normal)
        self.sendOTPButton.isUserInteractionEnabled = true
    }
    func handleRemainingOTPtime() {
        self.timerButton.isHidden = false
        self.timerButton.setTitle(self.timeString(time: self.duration), for: .normal)
        self.sendOTPButton.isUserInteractionEnabled = false
    }
    func showModelValues() {
        guard let model = self.selectedPersonalResponse else {return}
        self.titleLabel.text = model.title
        self.firstNameTF.text = model.firstName
        self.lastNameTF.text = model.lastName
        self.emailTF.text =  model.email
        self.paymentDayTF.text = model.repaymentDayOfWeek
       // self.dobTF.text = model.dob
        self.pincodeTF.text = model.pincode
        self.cityTF.text = model.address
        self.phoneTF.text = model.phoneNumber
        self.amountTF.text = model.fundRequestAmount.toInt().description
        self.durationTF.text = model.fundRequestDurationWeeks.description
        self.verifyButton.isHidden = true
        self.verifiedButton.isHidden = false
        self.pendingAgreeButton.setImage(UIImage(named: "checkboxSelected"), for: .normal)
        self.isPendingAgreed = true
        self.isAuthorizeAgreed = true
        self.authorizeAgreeButton.setImage(UIImage(named: "checkboxSelected"), for: .normal)
        self.ageAgreeButton1.setImage(UIImage(named: "checkboxSelected"), for: .normal)
        self.isPendingAgreed = true
        self.isAge18Agreed = true
        self.calculateFees()
        self.companyNameTF.text = model.company.companyName
        self.selectedCompanyAddress = model.company.companyAddress.addressLine
        self.selectedCompanyPostalCode = model.company.companyAddress.postCode
        self.businessTypeTF.text = model.company.businessType
//        self.selectedBusinessType = self.viewModel.businessTypeArray.filter({$0.description == initial.businessType}).first
        self.selectedBusinessType = self.viewModel.businessTypeArray.filter({$0.description.contains(model.company.businessType)}).first
        print()
        self.businessTypeTF.text = self.selectedBusinessType?.description
        if self.selectedBusinessType?.description == "Limited Company"{
                    self.companyNoView.isHidden = false
                }else{
                    self.companyNoView.isHidden = true
                }
        self.tradingStyleTF.text = model.company.tradingStyle
        self.companyNoTF.text = model.company.companyNumber
        self.fundingProcessTF.text = model.company.fundingPurpose
        self.selectedFundingProcess = self.viewModel.fundingPurposeArray.filter({$0.description == model.company.fundingPurpose}).first

        self.otherFundingPurposeTF.text = model.company.otherFundingPurpose
        self.selectedMode = model.modeOfApplication == "Representative" ? .Representative : .SelfMode
        GlobalmodeOfApplication = self.selectedMode
        self.showSelectedModeValues()
        if model.representatives != nil {
//            self.selectedRepresentative = self.viewModel.representativeArray.value(atSafe: initial.representatives ?? 0)
            self.representativeTypeTF.text = model.representatives

            self.isRepPendingAgreed = true
            self.isRepAuthorizeAgreed = true
            self.repAgreeButton1.setImage(UIImage(named: "checkboxSelected"), for: .normal)
            self.repAgreeButton2.setImage(UIImage(named: "checkboxSelected"), for: .normal)

        }
    }
    func showSelectedModeValues() {
        if selectedMode == .SelfMode {
            self.representativeImage.image = UIImage.init(named: "radioUnselected")
            self.selfImage.image = UIImage.init(named: "radioSelected")

            self.repAgreeButton1View.isHidden = true
            self.repAgreeButton2View.isHidden = true
            self.innerView.isHidden = true
            self.modeOfApplicationErrStack.isHidden = true
        }else if selectedMode == .Representative {
            self.selectedMode = .Representative
            self.selfImage.image = UIImage.init(named: "radioUnselected")
            self.representativeImage.image = UIImage.init(named: "radioSelected")
//            if self.isVerified == "true" {
//                self.verifiedLabel.isHidden = false
//            }else{
//                self.verifiedLabel.isHidden = true
//                self.otpStackView.isHidden = false
//                self.otpStack.isHidden = false
//            }
            self.repAgreeButton1View.isHidden = false
            self.repAgreeButton2View.isHidden = false
            self.innerView.isHidden = false
            self.modeOfApplicationErrStack.isHidden = true
        }
    }
    func updateModel() {
        let model = GlobalFundingModelObject
        var initial = InitialModel()
        initial.companyName = self.companyNameTF.text ?? ""
        initial.businessType = self.selectedBusinessType
        initial.email = self.emailTF.text ?? ""
        initial.tradingStyle = self.tradingStyleTF.text ?? ""
        initial.companyNumber = self.companyNoTF.text ?? ""
        initial.firstName = self.firstNameTF.text ?? ""
        initial.lastName = self.lastNameTF.text ?? ""
        initial.title = self.titleLabel.text ?? ""
        initial.phone = self.phoneTF.text ?? ""
        initial.fundRequest = self.amountTF.text ?? ""
        initial.duration = self.durationTF.text ?? ""
        initial.fundingProcess = self.fundingProcessTF.text ?? ""
        initial.otherFunding = self.otherFundingPurposeTF.text ?? ""
        initial.modeOfApplication = self.selectedMode.rawValue
        initial.repaymentDay = paymentDayTF.text ?? ""
        initial.representative = self.representativeTypeTF.text ?? ""
        GlobalmodeOfApplication = self.selectedMode

        model.initial = initial
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
        let fromDateString = dateFormatter.string(from: dateOfBirth ?? Date())
        var dict2 = JSON()
//        dict2["company_name"] = initial.companyName
//        dict2["business_type"] = initial.businessType?.description
//        dict2["trading_style"] = initial.tradingStyle
//        dict2["company_number"] = initial.companyNumber
        dict2["title"] = initial.title
        dict2["first_name"] = initial.firstName
        dict2["last_name"] = initial.lastName
        dict2["email"] = initial.email
        dict2["is_major"] = isAge18Agreed ? "Yes" : "No"
        dict2["pincode"] = self.pincodeTF.text ?? ""
        dict2["address"] = self.cityTF.text ?? ""
        dict2["phone_number"] = initial.phone
        dict2["fund_request_amount"] = initial.fundRequest
        dict2["fund_request_duration_weeks"] = initial.duration
        dict2["is_otp_verified"] = true
        dict2["agree_terms_and_conditions"] = true
        dict2["agree_communication_authorization"] = true
        dict2["apply_for_funding_assisted"] = false
        dict2["repayment_day_of_week"] = initial.repaymentDay
        //dict2["company_name"] = initial.companyName
      //  dict2["business_type"] = initial.businessType?.description == "Limited Partnership (LLP)" ? "Limited Partnership" : initial.businessType?.description
//        dict2["email"] = initial.email
        //dict2["trading_style"] = initial.tradingStyle
    //    dict2["company_number"] = initial.companyNumber
//        dict2["title"] = initial.title
//        dict2["first_name"] = initial.firstName
//        dict2["phone_number"] = initial.phone
//        dict2["last_name"] = initial.lastName
       
       // dict2["other_purpose_purpose"] = self.otherFundingPurposeTF.text ?? ""
//        dict2["fund_request_amount"] = initial.fundRequest
//        dict2["fund_request_duration_weeks"] = initial.duration
        dict2["agree_authorization"] = true
        dict2["is_pending_threatened_or_recently"] = true
        dict2["mode_of_application"] = initial.modeOfApplication == "SelfMode" ? "Self" : "Representative"
//        dict2["is_otp_verified"] = true
        if initial.modeOfApplication != "SelfMode" {
            dict2["representatives"] = initial.representative
        }
        var dict3 = JSON()
        dict3["company_name"] = initial.companyName//"new name\(arc4random())"
        dict3["company_status"] = "Active"
        dict3["business_type"] = initial.businessType?.description == "Limited Partnership (LLP)" ? "Limited Partnership" : initial.businessType?.description
        dict3["trading_style"] = initial.tradingStyle
        dict3["company_number"] = initial.companyNumber
        if initial.fundingProcess == "Other (Please Specify)" {
            dict3["funding_purpose"] = "Other (please specify)"
        }else{
            dict3["funding_purpose"] = initial.fundingProcess
        }
        dict3["other_funding_purpose"] = self.otherFundingPurposeTF.text ?? ""
        
        if initial.businessType?.description == "Limited Company"{
            var dict = JSON()
            dict["address_line"] = self.selectedCompanyAddress//self.selectedPersonalResponse?.company.companyAddress.addressLine
            dict["post_code"] = self.selectedCompanyPostalCode//self.selectedPersonalResponse?.company.companyAddress.postCode
            dict3["company_address"] = dict
        }
        dict2["company"] = dict3
    
        var dict5 = JSON()
        dict5["description"] = "instant pay i missed due"
        dict5["amount"] = 600
        dict5["currency"] = "GBP"
        //self.instantPay(Dict: dict5)

        self.createPersonalDetals(Dict: dict2)

    }
    func updateFilledForms(){
        var params = JSON()
        params["complete_personal_detail"] = "True"
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
    func createPersonalDetals(Dict: JSON){
        var url = APIEnums.createPersonal.rawValue
        if loanId != "" {
            url = url + "\(loanId)/"
        }
        if customerId != "" {
            url = url + "?customer_id=\(customerId)"
        }
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: Dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.updateFilledForms()
                    if self.delegate != nil {
                        self.delegate?.reload()
                        self.dismiss(animated: true)
                    }else{
                        
                        if (GlobalmodeOfApplication == .Representative) {
                            var (loanStatus,upcomingStatus) = self.fetchLoanIdStatus(loanId: self.loanId)
                            if loanStatus.lowercased() != "inprogress" && loanStatus.lowercased() != ""{
                                var vc = FundingViewController.initWithStory(loanId: self.loanId)
                                self.navigationController?.pushViewController(vc, animated: true)

                            }else{
//                                var vc = TabBarController()
//                                self.navigationController?.pushViewController(vc, animated: true)
                                self.showAlertWithAction(title: "Notice", message: "Once assigned to an agent, you can no longer continue with the application. Only the agent has the ability to fill out the form")
                            }
                        }else{
                            var vc = FundingViewController.initWithStory(loanId: self.loanId)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                       
                    }
                    
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(params: Dict)
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
    func showAlertWithAction(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default,handler: { okay in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alertController, animated: true)
    }
    func instantPay(Dict: JSON){
        var url = APIEnums.createInstantPay.rawValue
        if loanId != "" {
            url = url + "\(loanId)/" + "?request_from=web"
        }
        APIService.shared.InstantPayRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: Dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    print(data)
                    var vc = WebViewController.initWithStory()
                    vc.strPageTitle = ""
                    vc.isToRedirect = true
                    vc.strWebUrl = data.data.authorisationURL
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(params: Dict)
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

                    self.createPersonalDetals(Dict: params)
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
    func fetchPersonalDetails() {
        APIService.shared.retrievePersonalFormDetails(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedPersonalResponse = responseData
                        self.showModelValues()
                    }
                    catch {
                        
                    }
                }
                else {
                    //self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    @IBAction func repAgreeButton1Action(_ sender: Any) {
        self.isRepPendingAgreed = !self.isRepPendingAgreed
        if !self.isRepPendingAgreed{
            self.repAgreeButton1.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        }else{
          //  self.modeOfApplicationErrLabel.text = "Please choose the Mode of application"

           // self.modeOfApplicationErrStack.isHidden = self.isAuthorizeAgreed ? true : false
            self.repAgreeButton1.setImage(UIImage(named: "checkboxSelected"), for: .normal)
        }
    }
    @IBAction func repAgreeButton2Action(_ sender: Any) {
        self.isRepAuthorizeAgreed = !self.isRepAuthorizeAgreed
        if !self.isRepAuthorizeAgreed{
            self.repAgreeButton2.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        }
        else{
            //self.modeOfApplicationErrLabel.text = "Please choose the Mode of application"

            //self.modeOfApplicationErrStack.isHidden = self.isPendingAgreed ? true : false
            self.repAgreeButton2.setImage(UIImage(named: "checkboxSelected"), for: .normal)
        }
    }
    @IBAction func ageAgreeAction(_ sender: Any) {
        self.isAge18Agreed = !self.isAge18Agreed
        if !self.isAge18Agreed{
            self.ageAgreeButton1.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        }else{
            self.ageAgreeButton1.setImage(UIImage(named: "checkboxSelected"), for: .normal)
            self.dobErrLabel.text = "Please agree the user has above 18 age or not"
            self.dobErrStack.isHidden = true
        }
    }
    @IBAction func pendingAgreeAction(_ sender: Any) {
        self.isPendingAgreed = !self.isPendingAgreed
        if !self.isPendingAgreed{
            self.pendingAgreeButton.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        }else{
            self.pendingAgreeButton.setImage(UIImage(named: "checkboxSelected"), for: .normal)
//            self.modeOfApplicationErrLabel.text = "Please agree the terms and conditions"
//            self.modeOfApplicationErrStack.isHidden = true
        }
    }
    @IBAction func authorizeAgreeAction(_ sender: Any) {
        self.isAuthorizeAgreed = !self.isAuthorizeAgreed
        if !self.isAuthorizeAgreed{
            self.authorizeAgreeButton.setImage(UIImage(named: "checkboxUnselected"), for: .normal)

        }
        else{
            self.authorizeAgreeButton.setImage(UIImage(named: "checkboxSelected"), for: .normal)
//            self.modeOfApplicationErrLabel.text = "Please agree the terms and conditions"
//
//            self.modeOfApplicationErrStack.isHidden = true
        }
    }
    @IBAction func AgreeAction1(_ sender: Any) {
        self.isAgreed1 = !self.isAgreed1
        if !self.isAgreed1{
            self.agreeButton1.setImage(UIImage(systemName: "square")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue), for: .normal)
        }else{
            self.agreeButton1.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue), for: .normal)
        }
    }
    @IBAction func AgreeAction2(_ sender: Any) {
        self.isAgreed2 = !self.isAgreed2
        if !self.isAgreed2{
            self.agreeButton2.setImage(UIImage(systemName: "square")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue), for: .normal)
        }
        else{
            self.agreeButton2.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue), for: .normal)
        }
    }
    //---------------------------------------
    // MARK: - WS Function
    //---------------------------------------
    
    func callOTPVerificationAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .OTPVerificationApicall(parms: parms){(result) in
                switch result{
                case .success(let model):
                    self.loanId = model.loan.id
                    self.userDefaults.set("true", forKey:"isVerified")
                    self.verifyButton.isHidden = true
                    self.verifiedButton.isHidden = false
                    self.modeOfApplicationErrStack.isHidden = true
                    self.timerButton.isHidden = true
                    self.OtpTimer?.invalidate()
                    var dicts = [String: Any]()
                    dicts["password"] = String(format:"%@",self.passwordTF.text!)
                    dicts["username"] = String(format:"%@",self.emailTF.text!)
                    self.callSigninAPI(parms: dicts)
                    self.userDefaults.set(self.emailTF.text, forKey:"user_email")
                case .failure(let error):
                    self.showAlert(title: "Info", message: error.localizedDescription)
                    break
                }
            }
    }
    func callSigninAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .SigninApicall(parms: parms){(result) in
                switch result{
                case .success(let json):
//                    self.sendOTPTapped()
                    //self.showAlert(title: "Info", message: "Login successfully")
                    self.commentButton.isHidden = false
                    self.userDefaults.set(json.access, forKey:"access")
                    self.userDefaults.set(json.refresh, forKey:"refresh")
                    self.userDefaults.set(json.role, forKey:"role")
                    self.userDefaults.set(1, forKey:"isLogin")
                    self.userDefaults.set(json.username, forKey:"email")
                    self.userDefaults.set(json.fullName, forKey:"name")
                    self.userDefaults.set(json.image, forKey:"image")
                    self.userDefaults.set(json.address, forKey:"address")
//                    let vc = TabBarController()
//                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .failure(let error):
                   // self.showAlert(title: "Info", message: error.localizedDescription)
                    break
                }
            }
    }
    func callResendOTPAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .ResendOTPApicall(parms: parms){(result) in
                switch result{
                case .success:
                    self.showAlert(title: "Info", message: "OTP Sent successfully")
                    self.startOTPTimer()
                    break
                case .failure(let error):
                    self.showAlert(title: "Info", message: error.localizedDescription)
                    break
                }
            }
    }
    func callSignupAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .SignupApicall(parms: parms){(result) in
                switch result{
                case .success:
//                    self.sendOTPTapped()
                    self.showAlert(title: "Info", message: "OTP Sent successfully")
                    self.startOTPTimer()
                    break
                case .failure(let error):
                    self.showAlert(title: "Info", message: error.localizedDescription)
                    break
                }
            }
    }
    func callPostcodeLookupAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .PostcodeLookupApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.postalLookupArray.removeAll()
                    self.viewModel.postalLookupArray = responseDict.data.Results.Items
                    self.dropdownType = .RegPost
                    self.cityTableHidden = false
                    self.showHideTable()
                    break
                case .failure(let error):
                    break
                }
            }
    }
    func callPostcodeLookupSidAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .PostcodeLookupSidApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.postalLookupArray.removeAll()
                    self.viewModel.postalLookupArray = responseDict.data.Results.Items
                    self.pincodeTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                    self.pincodeTable.reloadData()
                    self.view.layoutIfNeeded()
                    break
                case .failure(let error):
                    break
                }
            }
    }
    func callCompanyPostcodeLookupAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .CompanyPostcodeLookupApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.companyPostalLookupArray.removeAll()
                    self.viewModel.companyPostalLookupArray = responseDict.data
                    self.dropdownType = .companyName
                    self.companyNameTableHidden = false
                    self.showHideTable()
                    break
                case .failure(let error):
                    break
                }
            }
    }
    func callCompanyPostcodeLookupSidAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .CompanyPostcodeLookupSidApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.companyPostalLookupArray.removeAll()
                    self.viewModel.companyPostalLookupArray = responseDict.data
                    self.companyNameTableHeight.constant = CGFloat(self.viewModel.companyPostalLookupArray.count * 50)
                    self.companyNameTable.reloadData()
                    self.view.layoutIfNeeded()
                    break
                case .failure(let error):
                    self.showAlert(title: "Info", message: error.localizedDescription)
                    self.companyNameTF.text = ""
                    self.companyNoTF.text = ""
                    self.dropdownType = .companyName
                    self.companyNameTableHidden = true
                    self.showHideTable()
                    break
                }
            }
    }
    
    func showHideTable() {
        switch self.dropdownType {
        case .PaymentDay:
            if self.paymentDayTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .RegPost:
            if self.cityTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .companyName:
            if self.companyNameTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .Duration:
            if self.durationTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        case .Name:
            if self.nameTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        case .Representative:
            if self.representativeTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        case .Business:
            if self.businessTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .Funding:
            if self.fundingProcessTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        case .Name:
            if self.nameTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        case .Duration:
            if self.durationTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        default:
            break
        }
        
    }
}
extension PersonalViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        self.setPagNumber(currentPage: Int(scrollPos) )
    }
}

extension PersonalViewController {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                switch self.dropdownType {
                case .PaymentDay:
                    self.paymentDayTable.isHidden = false
                    self.paymentDayTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.paymentDayTableHeight.constant = CGFloat(self.viewModel.paymentDayArray.count * 50)
                    self.paymentDayTable.reloadData()
                    self.view.layoutIfNeeded()

                case .RegPost:
                    self.pincodeTable.isHidden = false
                    self.pincodeTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.pincodeTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                    self.pincodeTable.reloadData()
                    self.view.layoutIfNeeded()
                case .companyName:
                    self.companyNameTable.isHidden = false
                    self.companyNameTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.companyNameTableHeight.constant = CGFloat(self.viewModel.companyPostalLookupArray.count * 50)
                    self.companyNameTable.reloadData()
                    self.view.layoutIfNeeded()
                case .Duration:
                    self.durationTable.isHidden = false
                    self.durationTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.durationTableHeight.constant = CGFloat(self.viewModel.durationArray.count * 50)
                    self.durationTable.reloadData()
                    self.view.layoutIfNeeded()
                    
                case .Name:
                    self.nameTable.isHidden = false
                    self.nameTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.nameTableHeight.constant = CGFloat(self.viewModel.nameArray.count * 50)
                    self.nameTable.reloadData()
                    self.view.layoutIfNeeded()
                
                case .Representative:
                    self.representativeTable.isHidden = false
                    self.representativeTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.representativeTableHeight.constant = CGFloat(self.viewModel.representativeArray.count * 50)
                    self.representativeTable.reloadData()
                    self.view.layoutIfNeeded()
                case .Business:
                    self.businessTable.isHidden = false
                    self.businessTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.businessTableHeight.constant = CGFloat(self.viewModel.businessTypeArray.count * 50)
                    self.businessTable.reloadData()
                    self.view.layoutIfNeeded()

                case .Funding:
                    self.fundingTable.isHidden = false
                    self.fundingTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.fundingTableHeight.constant = CGFloat(self.viewModel.fundingPurposeArray.count * 50)
                    self.fundingTable.reloadData()
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
            case .PaymentDay:
                self.paymentDayTable.isHidden = true
                self.paymentDayTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.paymentDayTableHeight.constant = 0
                self.paymentDayTable.reloadData()
            case .RegPost:
                self.pincodeTable.isHidden = true
                self.pincodeTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.pincodeTableHeight.constant = 0
                self.pincodeTable.reloadData()
            case .companyName:
                self.companyNameTable.isHidden = true
                self.companyNameTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.companyNameTableHeight.constant = 0
                self.companyNameTable.reloadData()
            case .Duration:
                self.durationTable.isHidden = true
                self.durationTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.durationTableHeight.constant = 0
                self.durationTable.reloadData()
            case .Name:
                self.nameTable.isHidden = true
                self.nameTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.nameTableHeight.constant = 0
                self.nameTable.reloadData()
            case .Representative:
                self.representativeTable.isHidden = true
                self.representativeTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.representativeTableHeight.constant = 0
                self.representativeTable.reloadData()
            case .Business:
                self.businessTable.isHidden = true
                self.businessTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.businessTableHeight.constant = 0
                self.businessTable.reloadData()
            case .Funding:
                self.fundingTable.isHidden = true
                self.fundingTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.fundingTableHeight.constant = 0
                self.fundingTable.reloadData()
            default:
                break
                
            }
        }, completion: nil)
    }
}
extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch self.dropdownType {
        case .PaymentDay:
            count = self.viewModel.paymentDayArray.count
        case .RegPost:
            count = self.viewModel.postalLookupArray.count
        case .companyName:
            count = self.viewModel.companyPostalLookupArray.count
        case .Duration:
            count = self.viewModel.durationArray.count
        case .Name:
            count = self.viewModel.nameArray.count
        case .Representative:
            count = self.viewModel.representativeArray.count
        case .Business:
            count = self.viewModel.businessTypeArray.count
        case .Funding:
            count = self.viewModel.fundingPurposeArray.count
        default:
            break
            
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.dropdownType == .RegPost && tableView == pincodeTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                return cell
            }
            var modelText = model.ItemText
            var address = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
            cell.documentLabel.text = (modelText == "" && self.viewModel.postalLookupArray.count == 1) ? address : modelText
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.viewModel.postalLookupArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                    return
                }
                if model.Selected == "true" && self.viewModel.postalLookupArray.count == 1{
                    self.selectedCity = self.viewModel.postalLookupArray.value(atSafe: indexPath.row)?.Sid ?? ""
                    self.cityTF.text = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
                    self.cityErrStack.isHidden = true
//                    self.pincodeTF.text = model.Label5
                    self.cityTableHidden = !self.cityTableHidden
                    self.dropdownType = .RegPost
                    self.removeTransparentView()
                    self.pincodeErrStack.isHidden = true
                }else{
                    self.callPostcodeLookupSidAPI(parms: ["address_sid": model.Sid ?? ""])

                }
                
            }
            return cell
        }
        
        else if self.dropdownType == .companyName && tableView == companyNameTable {
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row) else{
                return cell2
            }
            var modelText = model.companyName
            var address = model.companyName
            cell2.documentLabel.text = (modelText == "" && self.viewModel.companyPostalLookupArray.count == 1) ? address : modelText

//            cell2.documentLabel.text = self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row)?.ItemText ?? ""
            cell2.documentSelectAction.setTitle("", for: .normal)
            cell2.separatorLabel.isHidden = (indexPath.row == self.viewModel.companyPostalLookupArray.count - 1)
            cell2.documentSelectAction.addTapGestureRecognizer {
                guard let model = self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row) else{
                    return
                }
//                if model.Selected == "true" && self.viewModel.companyPostalLookupArray.count == 1{
//                    if self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row)?.companyStatus?.lowercased() == "dissolved" {
//                        self.showAlert(title: "Sorry, you are not eligible for this funding submission!", message: "Unfortunately, you do not meet the eligiblity criteria for this funding submission.")
//                        self.isEligibleCompanyLookup = false
//                    }else {
//                        self.isEligibleCompanyLookup = true
//                        self.selectedCompanyName = self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row)?.companyName ?? ""
//                        self.selectedCompanyNumber = self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row)?.companyNumber ?? ""
//
//                        self.companyNoTF.text = self.selectedCompanyNumber
//                        self.companyNumberErrStack.isHidden = true
//                        self.companyNameTF.text = self.selectedCompanyName
//                        self.companyNameErrStack.isHidden = true
//    //                    self.pincodeTF.text = model.Label5
//                        self.companyNameTableHidden = !self.companyNameTableHidden
//                        self.dropdownType = .companyName
//                        self.removeTransparentView()
//                        self.companyNameErrStack.isHidden = true
//                    }
//                }else{
//                    self.callCompanyPostcodeLookupSidAPI(parms: ["address_sid": model.Sid ?? ""])
//
//                }
                if model.companyStatus == "active" {
                    self.isEligibleCompanyLookup = true
                    self.selectedCompanyName = self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row)?.companyName ?? ""
                    self.selectedCompanyNumber = self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row)?.companyNumber ?? ""
                    self.selectedCompanyAddress = self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row)?.companyAddress.addressLine ?? ""
                    self.selectedCompanyPostalCode = self.viewModel.companyPostalLookupArray.value(atSafe: indexPath.row)?.companyAddress.postCode ?? ""

                    self.companyNoTF.text = self.selectedCompanyNumber
                    self.companyNumberErrStack.isHidden = true
                    self.companyNameTF.text = self.selectedCompanyName
                    self.companyNameErrStack.isHidden = true
//                    self.pincodeTF.text = model.Label5
                    self.companyNameTableHidden = !self.companyNameTableHidden
                    self.dropdownType = .companyName
                    self.removeTransparentView()
                    self.companyNameErrStack.isHidden = true

                    
                }else {
                    self.isEligibleCompanyLookup = false

                self.showAlert(title: "Info", message: "Selected company is not active")

                }
            }
            return cell2
        }
        else if self.dropdownType == .PaymentDay {
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? CellClass3 else {
                return UITableViewCell()
            }
            cell3.label2.text = self.viewModel.paymentDayArray.value(atSafe: indexPath.row)?.description
            cell3.action2.setTitle("", for: .normal)
            cell3.separator2.isHidden = (indexPath.row == self.viewModel.paymentDayArray.count - 1)
            cell3.action2.addTapGestureRecognizer {
                self.paymentDayTF.text = "\(self.viewModel.paymentDayArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedPaymentDay = self.viewModel.paymentDayArray.value(atSafe: indexPath.row)
                self.paymentDayTableHidden = !self.paymentDayTableHidden
                self.dropdownType = .PaymentDay
                self.removeTransparentView()
                self.paymentDayErrStack.isHidden = true
            }
            return cell3
        }
        else if self.dropdownType == .Duration {
            guard let cell4 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? CellClass3 else {
                return UITableViewCell()
            }
            cell4.label2.text = self.viewModel.durationArray.value(atSafe: indexPath.row)?.description
            cell4.action2.setTitle("", for: .normal)
            cell4.separator2.isHidden = (indexPath.row == self.viewModel.durationArray.count - 1)
            cell4.action2.addTapGestureRecognizer {
                self.durationTF.text = "\(self.viewModel.durationArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedDuration = self.viewModel.durationArray.value(atSafe: indexPath.row)
                self.calculateFees()
                self.durationTableHidden = !self.durationTableHidden
                self.dropdownType = .Duration
                self.removeTransparentView()
                self.durationErrStack.isHidden = true
            }
            return cell4
        }
        else if self.dropdownType == .Name {
            guard let cell5 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CellClass2 else {
                return UITableViewCell()
            }
            cell5.label1.text = self.viewModel.nameArray.value(atSafe: indexPath.row)?.description
            cell5.action1.setTitle("", for: .normal)
            cell5.separator1.isHidden = (indexPath.row == self.viewModel.nameArray.count - 1)
            cell5.action1.addTapGestureRecognizer {
                self.titleLabel.text = "\(self.viewModel.nameArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedName = self.viewModel.nameArray.value(atSafe: indexPath.row)
                self.nameTableHidden = !self.nameTableHidden
                self.dropdownType = .Name
                self.removeTransparentView()
                self.NameErrStack.isHidden = true
            }
            return cell5
        }
        else if self.dropdownType == .Business {
            guard let cell6 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            cell6.documentLabel.text = self.viewModel.businessTypeArray.value(atSafe: indexPath.row)?.description
            cell6.documentSelectAction.setTitle("", for: .normal)
            cell6.separatorLabel.isHidden = (indexPath.row == self.viewModel.businessTypeArray.count - 1)
            cell6.documentSelectAction.addTapGestureRecognizer {
                self.businessTypeTF.text = "\(self.viewModel.businessTypeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedCompanyNumber = ""
                self.selectedCompanyName = ""
                self.companyNoTF.text = self.selectedCompanyNumber
                self.companyNameTF.text = self.selectedCompanyName

                self.selectedBusinessType = self.viewModel.businessTypeArray.value(atSafe: indexPath.row)
                if self.selectedBusinessType?.description == "Limited Company"{
                    self.companyNoView.isHidden = false
                }else{
                    self.companyNoView.isHidden = true
                }
                self.businessTableHidden = !self.businessTableHidden
                self.dropdownType = .Business
                self.removeTransparentView()
                self.businessTypeErrStack.isHidden = true
            }
            return cell6
        }
        else if self.dropdownType == .Funding {
            guard let cell7 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? CellClass3 else {
                return UITableViewCell()
            }
            cell7.label2.text = self.viewModel.fundingPurposeArray.value(atSafe: indexPath.row)?.description
            cell7.action2.setTitle("", for: .normal)
            cell7.separator2.isHidden = (indexPath.row == self.viewModel.fundingPurposeArray.count - 1)
            cell7.action2.addTapGestureRecognizer {
                self.fundingProcessTF.text = "\(self.viewModel.fundingPurposeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedFundingProcess = self.viewModel.fundingPurposeArray.value(atSafe: indexPath.row)
                self.fundingProcessTableHidden = !self.fundingProcessTableHidden
                self.dropdownType = .Funding
                self.removeTransparentView()
                if self.selectedFundingProcess?.description == self.viewModel.fundingPurposeArray.value(atSafe: self.viewModel.fundingPurposeArray.count - 1)?.description ?? "" {
                    self.otherFundingPurposeStack.isHidden = false
                }else{
                    self.otherFundingPurposeStack.isHidden = true
                }
                self.fundingProcessErrStack.isHidden = true
            }
            return cell7
        }
        
        else if self.dropdownType == .Representative {
            guard let cell8 = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as? CellClass5 else {
                return UITableViewCell()
            }
            cell8.label4.text = self.viewModel.representativeArray.value(atSafe: indexPath.row)?.description
            cell8.action4.setTitle("", for: .normal)
            cell8.separator4.isHidden = (indexPath.row == self.viewModel.representativeArray.count - 1)
            cell8.action4.addTapGestureRecognizer {
                self.representativeTypeTF.text = "\(self.viewModel.representativeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedRepresentative = self.viewModel.representativeArray.value(atSafe: indexPath.row)
                self.representativeTableHidden = !self.representativeTableHidden
                self.dropdownType = .Representative
                self.removeTransparentView()
                self.modeOfApplicationErrStack.isHidden = true
            }
            return cell8
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == pincodeTable {
//            return UITableView.automaticDimension
//        }else{
            return 50
//        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension PersonalViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case self.amountTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowAmount.rawValue)
            let result      = eTest.evaluate(with: newText)
            return result
        case self.pincodeTF:
            self.cityTF.text = ""
            self.selectedCity = ""
//        case self.companyNameTF:
//            self.companyNameTF.text = ""
//            self.selectedCompanyName = ""
//            self.selectedCompanyNumber = ""
        case self.phoneTF:
            let mobileNo = self.phoneTF.text?.fullTrim()
            guard !newText.isEmpty else {
                self.phoneTF.text = ""
                self.phoneErrStack.isHidden = true
                self.updateProceedButtonUI(enabled: false)
                return false
            }
            if newText.fullTrim().count <= Validations.PhoneNumber.Minimum.rawValue {
                //  self.phoneTF.text = newText
            }
            
            //Check for the validations
            if newText.fullTrim().count < Validations.PhoneNumber.Minimum.rawValue {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Mobile number should be at least \(Validations.PhoneNumber.Minimum.rawValue) characters"
                self.updateProceedButtonUI(enabled: false)
            }
            else if newText.fullTrim().isDummyNumber() {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Mobile Number should begin with 6, 7, 8 or 9"
                self.updateProceedButtonUI(enabled: false)
            }
            else if newText.fullTrim().isFakeNumber() {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Mobile Number should not contain repetitive digits"
                self.updateProceedButtonUI(enabled: false)
            }
            else if newText.fullTrim().count < Validations.PhoneNumber.Minimum.rawValue  {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Mobile Number should contain 10 digits"
                self.updateProceedButtonUI(enabled: false)
            }
            else if !newText.fullTrim().isValidPhone() {
                if newText.fullTrim().count >= Validations.PhoneNumber.Minimum.rawValue && ((mobileNo?.isValidPhone()) != nil) {
                    self.phoneErrStack.isHidden = true
                    self.updateProceedButtonUI(enabled: true)
                }else{
                    self.phoneErrStack.isHidden = false
                    self.phoneErrLabel.text = "Invalid Mobile Number"
                    self.updateProceedButtonUI(enabled: false)
                }
            }
            else {
                self.phoneErrStack.isHidden = true
                self.updateProceedButtonUI(enabled: true)
                OtpTimer?.invalidate()
                self.timerButton.isHidden = true
                self.sendOTPButton.isUserInteractionEnabled = true
            }
            
        default: break
        }
        
        return true
    }
    
    func updateProceedButtonUI(enabled: Bool) {
        self.nextButton.isUserInteractionEnabled = enabled
        //        self.nextButton.backgroundColor = enabled ? UIColor.init(named: "blue") :  UIColor.init(named: "grayborder")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == self.cityTF {
//            self.cityErrStack.isHidden = true
//        }
        if textField == self.emailTF {
            self.emailErrStack.isHidden = true
        }
        
        if textField == self.passwordTF {
            self.passwordErrStack.isHidden = true
        }
        if textField == self.amountTF {
            self.amountErrStack.isHidden = true
        }
        if textField == self.cityTF {
            self.cityErrStack.isHidden = true
        }
        if textField == self.firstNameTF {
            self.NameErrStack.isHidden = true
        }
        if textField == self.lastNameTF {
            self.NameErrStack.isHidden = true
        }
        if textField == self.phoneTF {
            self.phoneErrStack.isHidden = true
        }
        if textField == self.dobTF {
            self.dobErrStack.isHidden = true
        }
        if textField == self.amountTF {
            self.amountErrStack.isHidden = true
        }
        if textField == self.durationTF {
            self.durationErrStack.isHidden = true
        }
        if textField == self.companyNameTF {
            self.companyNameErrStack.isHidden = true
        }
        
        if textField == self.tradingStyleTF {
            self.tradingStyleErrStack.isHidden = true
        }
        if textField == self.companyNoTF {
            self.companyNumberErrStack.isHidden = true
        }
      
        if textField == self.otherFundingPurposeTF {
            self.otherfundingProcessErrStack.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.amountTF {
            if self.amountTF.text?.trim() == "" {
                self.amountErrStack.isHidden = false
                self.amountErrLabel.text = "Amount is compulsory"
            }
            else if self.amountTF.text?.trim() != "" {
                let text = self.amountTF.text?.trim()
                if text?.toInt() ?? 0 > 50000 {
                    self.amountErrStack.isHidden = false
                    self.amountErrLabel.text = "Please enter amount below 50000"
                }
                else{
                    self.amountErrStack.isHidden = true
                    guard let val = self.amountTF.text?.toInt(), let duration = self.durationTF.text?.toInt() , duration >= 5 && duration <= 40 else{
                        return
                    }
                    var per = val / duration
                    if self.durationTF.text?.toInt() != 0 {
                       // self.repaymentLabel.text = "Repayment Per Week: \(per)"
                    }
                    self.calculateFees()
                }
            }

        }
        switch textField {
        case self.dobTF:
            if (self.dobTF.text == nil || self.dobTF.text == "") {
                self.dobErrStack.isHidden = false
                self.dobErrLabel.text = "Please enter Date of Birth"
            }
        case self.emailTF:
            if (self.emailTF.text == nil || self.emailTF.text == "") {
                self.emailErrStack.isHidden = false
                self.emailErrLabel.text = "Please enter the email"
            }
            if !self.isValidEmail(testStr: emailTF.text ?? "") {
                self.emailErrStack.isHidden = false
                self.emailErrLabel.text = "Please Enter Valid Email"
            }else{
//                self.loginEmailTF.text = self.emailTF.text
            }
       
        case self.passwordTF:
            if (self.passwordTF.text == nil || self.passwordTF.text == "") {
                self.passwordErrStack.isHidden = false
                self.passwordErrLabel.text = "Please enter OTP"
            }
//            if self.passwordTF.text != "000000"
//            {
//                self.modeOfApplicationErrStack.isHidden = false
//                self.modeOfApplicationErrLabel.text = "Invalid OTP"
//            }else{
                self.passwordErrStack.isHidden = true
//            }
        case self.cityTF:
            if (self.cityTF.text == nil || self.cityTF.text == "") {
                self.cityErrStack.isHidden = false
                self.cityErrLabel.text = "Please enter Address"
            }
        case self.firstNameTF:
            if (self.firstNameTF.text == nil || self.firstNameTF.text == "") {
                self.NameErrStack.isHidden = false
                self.NameErrLabel.text = "Please enter First Name"
            }
            
        case self.lastNameTF:
            if (self.lastNameTF.text == nil || self.lastNameTF.text == "") {
                self.NameErrStack.isHidden = false
                self.NameErrLabel.text = "Please enter Last Name"
            }
        case self.phoneTF:
            if (self.phoneTF.text == nil || self.phoneTF.text == "") {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Please enter Phone number"
            }
            else{
//                self.loginPhoneTF.text = self.phoneTF.text
            }
        case self.pincodeTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
            let result      = eTest.evaluate(with: self.pincodeTF.text?.trim())

            if (self.pincodeTF.text == nil || self.pincodeTF.text == "") {
                self.pincodeErrStack.isHidden = false
                self.pincodeErrLabel.text = "Please enter the Postcode"

                self.dropdownType = .RegPost
                self.cityTableHidden = true
                self.showHideTable()
            }
            else if result == false {
                self.pincodeErrStack.isHidden = false
                self.pincodeErrLabel.text = "Valid UK Postcode is required"
                self.dropdownType = .RegPost
                self.cityTableHidden = true
                self.showHideTable()
            }
            else{
                self.cityTF.text = ""
                self.selectedCity = ""
                self.pincodeErrStack.isHidden = true
                self.callPostcodeLookupAPI(parms: ["address": self.pincodeTF.text?.trim() ?? ""])
            }
        case self.companyNameTF:
//            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
//            let result      = eTest.evaluate(with: self.pincodeTF.text)

            if (self.companyNameTF.text == nil || self.companyNameTF.text == "") {
                self.companyNameErrStack.isHidden = false
                self.companyNameErrLabel.text = "Please enter Company Name"
                self.dropdownType = .companyName
                self.companyNameTableHidden = true
                self.showHideTable()

            }
            else if self.selectedBusinessType?.description == "Limited Company"{
               // self.companyNameTF.text = ""
                self.selectedCompanyName = ""
                self.selectedCompanyNumber = ""
                self.companyNameErrStack.isHidden = true
                self.callCompanyPostcodeLookupAPI(parms: ["query": self.companyNameTF.text?.trim() ?? ""])
            }else{
                
            }
        case self.durationTF:
            if (self.durationTF.text == nil || self.durationTF.text == "") {
                self.durationErrStack.isHidden = false
                self.durationErrLabel.text = "Please enter Duration"
            }
            else if self.durationTF.text?.toInt() ?? 0 < 10 || self.durationTF.text?.toInt() ?? 0 > 30 {
                self.durationErrStack.isHidden = false
                self.durationErrLabel.text = "Please enter Duration between 10 to 30"
            }
            else{
                self.calculateFees()
                self.durationErrStack.isHidden = true
            }
        case self.companyNameTF:
            if (self.companyNameTF.text == nil || self.companyNameTF.text == "") {
                self.companyNameErrStack.isHidden = false
                self.companyNameErrLabel.text = "Please enter company Name"
            }
        
        case self.tradingStyleTF:
            if (self.tradingStyleTF.text == nil || self.tradingStyleTF.text == "") {
                self.tradingStyleErrStack.isHidden = false
                self.tradingStyleErrLabel.text = "Please enter Business / Shop Name"
            }
        case self.companyNoTF:
            if (self.companyNoTF.text == nil || self.companyNoTF.text == "") {
                self.companyNumberErrStack.isHidden = false
                self.companyNumberErrLabel.text = "Please enter company Number"
            }
       
        case self.otherFundingPurposeTF:
            if (self.otherFundingPurposeTF.text == nil || self.otherFundingPurposeTF.text == "") && !self.otherFundingPurposeTF.isHidden {
                self.otherfundingProcessErrStack.isHidden = false
                self.otherfundingProcessErrLabel.text = "Please fill the details"
            }
        default:
            break
        }
        //        self.updateNextButton()
    }
    func goNext() -> Bool {
//        if (self.dobTF.text == nil || self.dobTF.text == "") {
//            return false
//        }
//        let calendar = Calendar.current
//        let year = calendar.dateComponents([.year], from: self.dateOfBirth, to: Date()).year ?? 0
//        
//        if year < 18 && self.dobTF.text != "" && self.selectedPersonalResponse == nil {
//            return false
//        }
        if !self.isEligibleCompanyLookup {
            return false
        }

        if (self.cityTF.text == nil || self.cityTF.text == "") {
            return false
        }
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            return false
        }
        if !self.isValidEmail(testStr: emailTF.text ?? "") {
            return false
        }
       
        if (self.passwordTF.text == nil || self.passwordTF.text == "") && self.selectedPersonalResponse == nil {
            return false
        }
//        if (self.companyNoTF.text == nil || self.companyNoTF.text == "") {
//            return false
//        }
        if (self.pincodeTF.text == nil || self.pincodeTF.text == "") {
            return false
        }
       
        let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
        let result      = eTest.evaluate(with: self.pincodeTF.text?.trim())
        if result == false && (self.pincodeTF.text != "") {
            return false
        }
        if (self.firstNameTF.text == nil || self.firstNameTF.text == "") {
            return false
        }
        if (self.lastNameTF.text == nil || self.lastNameTF.text == "") {
            return false
        }
        if (self.phoneTF.text == nil || self.phoneTF.text == "") {
            return false
        }
        if (self.amountTF.text == nil || self.amountTF.text == "") {
            return false
        }
        if (self.amountTF.text?.toInt() ?? 0 < 3000 || self.amountTF.text?.toInt() ?? 0 > 50000) && self.amountTF.text != "" {
            return false

        }
        if (self.selectedName?.description == nil || self.selectedName?.description == "") {
            return false
        }
        if (self.durationTF.text == nil || self.durationTF.text == "") {
            return false
        }
        if self.durationTF.text?.toInt() ?? 0 < 10 || self.durationTF.text?.toInt() ?? 0 > 40 {
            return false
        }
//        if (self.selectedMode == .none) {
//            return false
//        }
//        if ((self.selectedRepresentative?.description == nil || self.selectedRepresentative?.description == "") && self.selectedMode == .Representative) {
//            return false
//
//        }
//        if (!isAgreed1 || !isAgreed2) && self.selectedMode == .Representative {
//            return false
//        }
        if (!isPendingAgreed || !isAuthorizeAgreed || !isAge18Agreed) {
            return false
        }
        if verifiedButton.isHidden == true {
            return false
        }
        if (self.paymentDayTF.text == nil || self.paymentDayTF.text == "") {
            return false
        }
        if (self.companyNameTF.text == nil || self.companyNameTF.text == "") {
            return false
        }
        if (self.selectedBusinessType?.description == nil || self.selectedBusinessType?.description == "") {
            return false
        }
        if (self.tradingStyleTF.text == nil || self.tradingStyleTF.text == "") {
            return false
        }
        if ((self.companyNoTF.text == nil || self.companyNoTF.text == "") && self.selectedBusinessType?.description == "Limited Company"){
            return false
        }
        if (self.selectedFundingProcess?.description == nil || self.selectedFundingProcess?.description == "") {
            return false
        }
//
        if !otherFundingPurposeStack.isHidden && (self.otherFundingPurposeTF.text == nil || self.otherFundingPurposeTF.text == "") {
            return false
        }
        if (self.selectedMode == .none) {
            return false
        }
        if ((self.representativeTypeTF.text == nil || self.representativeTypeTF.text == "") && self.selectedMode == .Representative) {
            return false

        }
        if (!isRepPendingAgreed || !isRepAuthorizeAgreed) && self.selectedMode == .Representative {
            return false
        }
        return true
    }
    func isValidSignupFields() {
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please enter the email"
        }
        if !self.isValidEmail(testStr: emailTF.text ?? ""){
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please Enter Valid Email"
        }
        if (self.phoneTF.text == nil || self.phoneTF.text == "") {
            self.phoneErrStack.isHidden = false
            self.phoneErrLabel.text = "Please enter Phone number"
        }
    }
    func goSignup() -> Bool {
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            return false
        }
        if !self.isValidEmail(testStr: emailTF.text ?? "") {
            return false
        }
        if (self.phoneTF.text == nil || self.phoneTF.text == "") {
            return false
        }
        return true
    }
    func isValidTextFields() {
//        if (self.dobTF.text == nil || self.dobTF.text == "") {
//            self.dobErrStack.isHidden = false
//            self.dobErrLabel.text = "Please enter Date of Birth"
//        }
//        let calendar = Calendar.current
//       let year = calendar.dateComponents([.year], from: self.dateOfBirth, to: Date()).year ?? 0
//
//        if year < 18 && self.dobTF.text != "" && self.selectedPersonalResponse == nil{
//            self.dobErrStack.isHidden = false
//            self.dobErrLabel.text = "Age should be greater than or equal to 18"
//        }
        if !self.isEligibleCompanyLookup {
            self.showAlert(title: "Sorry, you are not eligible for this funding submission!", message: "Unfortunately, you do not meet the eligiblity criteria for this funding submission.")
        }
        if (self.cityTF.text == nil || self.cityTF.text == "") {
            self.cityErrStack.isHidden = false
            self.cityErrLabel.text = "Please enter Address"
        }
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please enter the email"
        }
        if !self.isValidEmail(testStr: emailTF.text ?? "") {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please Enter Valid Email"
        }
       
        if (self.passwordTF.text == nil || self.passwordTF.text == "") && self.selectedPersonalResponse == nil {
            self.passwordErrStack.isHidden = false
            self.passwordErrLabel.text = "Please enter OTP"
        }
//        if (self.companyNoTF.text == nil || self.companyNoTF.text == "") {
//            self.companyNumberErrStack.isHidden = false
//            self.companyNumberErrLabel.text = "Please enter company Number"
//        }
        if (self.pincodeTF.text == nil || self.pincodeTF.text == "") {
            self.pincodeErrStack.isHidden = false
            self.pincodeErrLabel.text = "Please enter Postcode"
        }
        let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
        let result      = eTest.evaluate(with: self.pincodeTF.text?.trim())
        if result == false && (self.pincodeTF.text != "") {
            self.pincodeErrStack.isHidden = false
            self.pincodeErrLabel.text = "Valid UK Postcode is required"
        }
        if (self.firstNameTF.text == nil || self.firstNameTF.text == "") {
            self.NameErrStack.isHidden = false
            self.NameErrLabel.text = "Please enter First Name"
        }
        if (self.lastNameTF.text == nil || self.lastNameTF.text == "") {
            self.NameErrStack.isHidden = false
            self.NameErrLabel.text = "Please enter Last Name"
        }
        if (self.phoneTF.text == nil || self.phoneTF.text == "") {
            self.phoneErrStack.isHidden = false
            self.phoneErrLabel.text = "Please enter Phone number"
        }
        if (self.amountTF.text == nil || self.amountTF.text == "") {
            self.amountErrStack.isHidden = false
            self.amountErrLabel.text = "Please enter Amount"
        }
        if (self.amountTF.text?.toInt() ?? 0 < 3000 || self.amountTF.text?.toInt() ?? 0 > 50000) && self.amountTF.text != "" {
            self.amountErrStack.isHidden = false
            self.amountErrLabel.text = "Please enter Amount between 3000 to 50000"
        }
        if (self.selectedName?.description == nil || self.selectedName?.description == "") {
            self.NameErrStack.isHidden = false
            self.NameErrLabel.text = "Please select the title"
        }
//        if (self.selectedDuration?.description == nil || self.selectedDuration?.description == "") {
//            self.durationErrStack.isHidden = false
//            self.durationErrLabel.text = "Please select Duration"
//        }
        if (self.durationTF.text == nil || self.durationTF.text == "") {
            self.durationErrStack.isHidden = false
            self.durationErrLabel.text = "Please enter Duration"
        }
        if (self.durationTF.text?.toInt() ?? 0 < 10 || self.durationTF.text?.toInt() ?? 0 > 30) && self.durationTF.text != "" {
            self.durationErrStack.isHidden = false
            self.durationErrLabel.text = "Please enter Duration between 10 to 30"
        }
//        if (self.selectedMode == .none) {
//            self.modeOfApplicationErrStack.isHidden = false
//            self.modeOfApplicationErrLabel.text = "Please choose the Mode of application"
//        }
//        if ((self.selectedRepresentative?.description == nil || self.selectedRepresentative?.description == "") && self.selectedMode == .Representative) {
//            self.modeOfApplicationErrStack.isHidden = false
//            self.modeOfApplicationErrLabel.text = "Please choose Representative"
//        }
//        if (!isAgreed1 || !isAgreed2) && self.selectedMode == .Representative {
//            self.modeOfApplicationErrStack.isHidden = false
//            self.modeOfApplicationErrLabel.text = "Please agree the terms and conditions"
//        }
        if (!isPendingAgreed || !isAuthorizeAgreed) {
            self.modeOfApplicationErrStack.isHidden = false
            self.modeOfApplicationErrLabel.text = "Please agree the terms and conditions"
        }
        if (!isAge18Agreed) {
            self.dobErrStack.isHidden = false
            self.dobErrLabel.text = "Please agree the user has above 18 age or not"
        }
        if verifiedButton.isHidden == true {
            self.modeOfApplicationErrStack.isHidden = false
            self.modeOfApplicationErrLabel.text = "Proceed OTP Validation"

        }
        if (self.paymentDayTF.text == nil || self.paymentDayTF.text == "") {
            self.paymentDayErrStack.isHidden = false
            self.paymentDayErrLabel.text = "Please select payment day"
        }
        if (self.companyNameTF.text == nil || self.companyNameTF.text == "") {
            self.companyNameErrStack.isHidden = false
            self.companyNameErrLabel.text = "Please enter company Name"
        }
        if (self.selectedBusinessType?.description == nil || self.selectedBusinessType?.description == "") {
            self.businessTypeErrStack.isHidden = false
            self.businessTypeErrLabel.text = "Please select business type"
        }
        if (self.tradingStyleTF.text == nil || self.tradingStyleTF.text == "") {
            self.tradingStyleErrStack.isHidden = false
            self.tradingStyleErrLabel.text = "Please enter Business / Shop Name"
        }
        if ((self.companyNoTF.text == nil || self.companyNoTF.text == "") && self.selectedBusinessType?.description == "Limited Company"){
            self.companyNumberErrStack.isHidden = false
            self.companyNumberErrLabel.text = "Please enter company Number"
        }
        if !otherFundingPurposeStack.isHidden && (self.otherFundingPurposeTF.text == nil || self.otherFundingPurposeTF.text == "") {
            self.otherfundingProcessErrStack.isHidden = false
            self.otherfundingProcessErrLabel.text = "Please fill the details"
        }

        if (self.selectedFundingProcess?.description == nil || self.selectedFundingProcess?.description == "") {
            self.fundingProcessErrStack.isHidden = false
            self.fundingProcessErrLabel.text = "Please select Funding Process"
        }

        if (self.selectedMode == .none) {
            self.modeOfApplicationErrStack.isHidden = false
            self.modeOfApplicationErrLabel.text = "Please choose the Mode of application"
        }
        if ((self.representativeTypeTF.text == nil || self.representativeTypeTF.text == "") && self.selectedMode == .Representative) {
            self.modeOfApplicationErrStack.isHidden = false
            self.modeOfApplicationErrLabel.text = "Please enter Representative"
        }
        if (!isRepPendingAgreed || !isRepAuthorizeAgreed) && self.selectedMode == .Representative {
            self.modeOfApplicationErrStack.isHidden = false
            self.modeOfApplicationErrLabel.text = "Please agree the terms and conditions"
        }
        

    }
    //    func updateNextButton() {
    //        if !isValidTextFields() {
    //            self.updateProceedButtonUI(enabled: false)
    //        }
    //        else{
    //            self.updateProceedButtonUI(enabled: true)
    //        }
    //    }
}
