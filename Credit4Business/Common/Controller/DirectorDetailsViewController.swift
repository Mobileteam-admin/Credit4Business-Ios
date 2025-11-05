//
//  DirectorDetailsViewController.swift
//  Credit4Business
//
//  Created by MacMini on 14/03/24.
//

import UIKit
import StepProgressBar
import IQKeyboardManagerSwift

class DirectorDetailsViewController: BaseViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var ownPropertyYesImage: UIImageView!
    @IBOutlet weak var ownPropertyYesView: UIView!
    @IBOutlet weak var ownPropertyNoImage: UIImageView!
    @IBOutlet weak var ownPropertyNoView: UIView!
    @IBOutlet weak var ownPropertyErrLabel: UILabel!
    @IBOutlet weak var ownPropertyErrStack: UIStackView!

    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var phoneErrLabel: UILabel!
    @IBOutlet weak var phoneErrStack: UIStackView!

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var emailErrStack: UIStackView!

    @IBOutlet weak var nameView: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var NameErrLabel: UILabel!
    @IBOutlet weak var NameErrStack: UIStackView!
    @IBOutlet weak var nameTableHeight: NSLayoutConstraint!
    @IBOutlet weak var nameTable: UITableView!
    @IBOutlet weak var nameTableArrowActionView: UIView!
    @IBOutlet weak var nameTableArrow: UIImageView!
    
    @IBOutlet weak var addressTableHeight: NSLayoutConstraint!
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var addressTableErrLabel: UILabel!
    @IBOutlet weak var addressTableErrStack: UIStackView!
    @IBOutlet weak var numberOfPropertyTF: UITextField!
    @IBOutlet weak var numberOfPropertyView: UIView!
    @IBOutlet weak var numberOfPropertyStack: UIStackView!
    @IBOutlet weak var propertyTable: UITableView!
    @IBOutlet weak var propertyTableHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var commentButton: UIImageView!

    //MARK: -------------------- Class Variable --------------------
    
    var propertyTableHidden = true
    var viewModel = HomeVM()
    var dropdownType : DropDownType = .none
    var selectedOwnProperty : Option = .none
    var selectedName : String?
    var nameTableHidden = true
    var numberOfProperty = 0
    var selectedDirectorIndex = 0
    var addressCount = 1
    var selectedDirectorsResponse = [SelectedDirector]()
    var selectedDirector : SelectedDirector?
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
        IQKeyboardManager.shared.enable = true
        if self.selectedDirector != nil && customerId != "" {
            self.showModelValues()
        }else{
            self.fetchDirectorDetails()
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
    
    class func initWithStory(loanId: String) -> DirectorDetailsViewController {
        let vc : DirectorDetailsViewController = UIStoryboard.Main.instantiateViewController()
        vc.loanId = loanId
        return vc
    }
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.nameTable.delegate = self
        self.nameTable.dataSource = self
        self.emailTF.delegate = self
        self.phoneTF.delegate = self
        self.phoneTF.maxLength  = Validations.PhoneNumber.Minimum.rawValue
        self.emailTF.keyboardType = .emailAddress
        self.addressTable.delegate = self
        self.addressTable.dataSource = self
        self.propertyTable.delegate = self
        self.propertyTable.dataSource = self
        self.numberOfPropertyTF.delegate = self
    }
    func showPropertyTable() {
        self.dropdownType = .Property
        self.propertyTableHidden = false
        self.showHideTable()
    }
    func manageActionMethods() {
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanId)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.ownPropertyYesView.addTapGestureRecognizer {
            self.selectedOwnProperty = .Yes
            self.ownPropertyNoImage.image = UIImage(named: "radioUnselected")
            self.ownPropertyYesImage.image = UIImage(named: "radioSelected")
            self.ownPropertyErrStack.isHidden = true
            self.numberOfPropertyStack.isHidden = false
            self.propertyTable.isHidden = false
            self.numberOfPropertyTF.text = ""
            self.numberOfProperty = 0
            self.viewModel.propertyArray.removeAll()
            self.propertyTable.reloadData()
        }
        self.ownPropertyNoView.addTapGestureRecognizer {
            self.selectedOwnProperty = .No
            self.ownPropertyYesImage.image = UIImage(named: "radioUnselected")
            self.ownPropertyNoImage.image = UIImage(named: "radioSelected")
            self.ownPropertyErrStack.isHidden = true
            self.numberOfPropertyStack.isHidden = true
            self.propertyTable.isHidden = true
            self.numberOfPropertyTF.text = ""
            self.numberOfProperty = 0
            self.propertyTableHeight.constant = 0
            self.viewModel.propertyArray.removeAll()
            self.propertyTable.reloadData()
        }
        self.nameTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .Name
            self.nameTableHidden = !self.nameTableHidden
            self.showHideTable()
        }
        self.nextButton.addTapGestureRecognizer {
            self.checkLoanStatus(loanId: self.loanId)
            if (canEditForms && GlobalmodeOfApplication != .Representative) || self.delegate != nil {
                self.isValidTextFields()
                if self.goNext() {
                    print("go next")
                   self.updateModel()
                }
                
            }
            else{
                   self.updateModel()
                    if GlobalFundingModelObject.business.remainingDirectorArray.count == 0 {
                        let vc = ConsentViewController.initWithStory(loanId: self.loanId)
                        vc.modalPresentationStyle = .overCurrentContext
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = DirectorDetailsViewController.initWithStory(loanId: self.loanId)
                        vc.modalPresentationStyle = .overCurrentContext
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
        }
        self.backButton.addTapGestureRecognizer {
            let model = GlobalFundingModelObject.business
            
            if model.orderArray.count != 0 {
                let index = model.orderArray.last
                model.orderArray.removeLast()
                let obj = model.directorArray.filter({$0.id == index}).first as! SelectedDirector
                model.remainingDirectorArray.append(obj)
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func fetchDirectorDetailsForAgent() {
        APIService.shared.retrieveDirectorDetailsFromAgent(customerId: self.customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedDirectorsResponse = responseData.directors

                        for item in self.selectedDirectorsResponse {
                            var element = GlobalFundingModelObject.business.remainingDirectorArray.filter({$0.firstName == item.firstName && $0.lastName == item.lastName})
                            element.first?.id = item.id
                        }
                        for item in self.selectedDirectorsResponse {
                            var element = GlobalFundingModelObject.business.directorArray.filter({$0.firstName == item.firstName && $0.lastName == item.lastName})
                            element.first?.id = item.id
                        }
                        self.selectedDirectorIndex = (GlobalFundingModelObject.business.remainingDirectorArray.first?.id ?? 0)
                        dump(self.selectedDirectorsResponse.filter({$0.id == self.selectedDirectorIndex}).first)
                       // self.showModelValues()
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
    func fetchDirectorDetails() {
        APIService.shared.retrieveDirectorsFormDetails(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedDirectorsResponse = responseData.directors

                        for item in self.selectedDirectorsResponse {
                            var element = GlobalFundingModelObject.business.remainingDirectorArray.filter({$0.firstName == item.firstName && $0.lastName == item.lastName})
                            element.first?.id = item.id
                        }
                        for item in self.selectedDirectorsResponse {
                            var element = GlobalFundingModelObject.business.directorArray.filter({$0.firstName == item.firstName && $0.lastName == item.lastName})
                            element.first?.id = item.id
                        }
                        self.selectedDirectorIndex = (GlobalFundingModelObject.business.remainingDirectorArray.first?.id ?? 0)
                        dump(self.selectedDirectorsResponse.filter({$0.id == self.selectedDirectorIndex}).first)
                       // self.showModelValues()
//                        if isFromIncomplete {
                            self.selectedDirector = self.selectedDirectorsResponse.filter({$0.id == self.selectedDirectorIndex}).first
                            self.showModelValues()
//                        }
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

    func updateModel() {
        let model = GlobalFundingModelObject
        let director = model.business.directorArray.filter({$0.id == self.selectedDirectorIndex}).first
        var remaining = model.business.remainingDirectorArray
        if let index = model.business.remainingDirectorArray.firstIndex(where: {$0.id == self.selectedDirectorIndex}) {
            remaining.remove(at: index)
        }
        model.business.remainingDirectorArray = remaining
        if model.business.directorArray.count != model.business.orderArray.count {
            model.business.orderArray.append(self.selectedDirectorIndex)
        }
        var array = [Stay]()
        for element in self.viewModel.addressArray {
            var dict = [String: Any]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
            let start = dateFormatter.string(from: element.startDateObj ?? Date())
            let end = dateFormatter.string(from: element.endDateObj ?? Date())

            let obj = Stay(pincode: element.postCode ?? "", address: element.address, houseOwnership: element.houseOwnership?.description ?? "", startDate: start, endDate: end)
//            let obj = Director(title: element.title, firstName: element.firstName, lastName: element.lastName)
            array.append(obj)
        }
        var array1 = [Property]()
        if self.selectedOwnProperty == .Yes{
            for element in self.viewModel.propertyArray {
                let obj = Property(pincode: element.postCode ?? "", address: element.address)
                array1.append(obj)
            }
        }
        
        let parameters: [String: Any] = [
            "id": self.selectedDirector?.id ?? 0,
            "phone_number": self.phoneTF.text ?? "",
            "email": self.emailTF.text ?? "",
            "owns_other_property": self.selectedOwnProperty.rawValue,
            "stay": array.map { $0.dictionaryRepresentation },
            "owned_property": array1.map { $0.dictionaryRepresentation },
            "owned_property_count": array1.count
        ]
        if (canEditForms && GlobalmodeOfApplication != .Representative) || self.delegate != nil {
            self.createDirectorDetails(params: parameters)
        }else{
            
        }

    }
    func updateFilledForms(){
        var params = JSON()
        params["director_detail"] = "True"
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
    func createDirectorDetails(params: JSON) {
        var url = ""
        if self.selectedDirector != nil && !isFromIncomplete {
            url = APIEnums.updateDirector.rawValue //+ "\(self.selectedDirector?.id ?? 0)/"

        }else{
            let model = GlobalFundingModelObject
            let director = model.business.directorArray.filter({$0.id == self.selectedDirectorIndex}).first ?? SelectedDirector()
            url = APIEnums.updateDirector.rawValue //+ "\(director.id)/"

        }
        if loanId != "" {
            url = url + "\(loanId)/"
        }
//        if customerId != "" {
//            url = url + "?customer_id=\(customerId)"
//        }
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .patch,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    if GlobalFundingModelObject.business.remainingDirectorArray.count == 0 {
                        self.updateFilledForms()
                    }
//                    var vc = PremiseDetailsViewController.initWithStory()
//                    GlobalFundingModelObject.business.directorArray = self.viewModel.directorNameArray
//                    vc.modalPresentationStyle = .overCurrentContext
//                    self.navigationController?.pushViewController(vc, animated: true)
                    if self.delegate != nil {
                        self.delegate?.reload()
                        self.updateFilledForms()
                        self.dismiss(animated: true)
                    }else{
                        if GlobalFundingModelObject.business.remainingDirectorArray.count == 0 {
                            let vc = ConsentViewController.initWithStory(loanId: self.loanId)
                            vc.modalPresentationStyle = .overCurrentContext
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            let vc = DirectorDetailsViewController.initWithStory(loanId: self.loanId)
                            vc.modalPresentationStyle = .overCurrentContext
                            self.navigationController?.pushViewController(vc, animated: true)
                        }}

                }
                else if data.statusCode == 401 {
                    //self.tokenRefreshApi(params: params)
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
    func updateUI()
    {
//        self.phoneView.layer.borderWidth = 0.5
//        self.phoneView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.emailView.layer.borderWidth = 0.5
//        self.emailView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.nameTableArrowActionView.layer.borderWidth = 0.5
//        self.nameTableArrowActionView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
        self.nameTF.text = (GlobalFundingModelObject.business.remainingDirectorArray.first?.firstName ?? "") + (GlobalFundingModelObject.business.remainingDirectorArray.first?.lastName ?? "")
        self.selectedName =  (GlobalFundingModelObject.business.remainingDirectorArray.first?.firstName ?? "") + (GlobalFundingModelObject.business.remainingDirectorArray.first?.lastName ?? "")
        self.selectedDirectorIndex = (GlobalFundingModelObject.business.remainingDirectorArray.first?.id ?? 0)
//        self.codeView.layer.borderWidth = 0.5
//        self.codeView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
        self.propertyTableHidden = true
        self.numberOfPropertyStack.isHidden = true
        self.showHideTable()
//        self.numberOfPropertyView.layer.borderWidth = 0.5
//        self.numberOfPropertyView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
        self.showAddressTable()
        self.addObserverOnHeightTbl()
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 3)

    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }
    func showHideTable() {
        switch self.dropdownType {
        case .Name:
            if self.nameTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        case .Property:
            if self.propertyTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        default:
            break
        }
    }
    func showAddressTable() {
        self.addressTable.isHidden = false
//        self.addressTableHeight.constant = CGFloat(self.viewModel.addressArray.count * 400)
        self.viewModel.addressArray.removeAll()
        var model = AddressAloneModel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let fromDateString = dateFormatter.string(from: Date())
        model.endDate = fromDateString
        model.endDateObj = Date()
        self.viewModel.addressArray.append(model)
        self.addressTable.reloadData()
        self.view.layoutIfNeeded()
    }
    func showModelValues() {
        var item = self.selectedDirector
        var addressArray = [AddressAloneModel]()
        if item?.stay.count != 0 && item != nil {
            for element in item!.stay {
                var object = AddressAloneModel()
                object.address = element.address
                object.postCode = element.pincode
                object.houseOwnership = self.viewModel.houseOwnershipArray.filter({$0.description == element.houseOwnership}).first
                object.startDate = element.startDate
                object.endDate = element.endDate
                var startDate = convertDateFormaterForDate(date: element.startDate)
                var endDate = convertDateFormaterForDate(date: element.endDate)
                object.startDateObj = startDate
                object.endDateObj = endDate
                addressArray.append(object)

            }
            self.viewModel.addressArray = addressArray
        }
        var propertyArray = [PropertyAddressModel]()

        if item?.ownedPropertyCount != 0 && item != nil {
            for element in item!.ownedProperty {
                var obj = PropertyAddressModel()
                obj.address = element.address
                obj.postCode = element.pincode
                propertyArray.append(obj)
            }
            self.viewModel.propertyArray = propertyArray
        }
        self.phoneTF.text = item?.phoneNumber
        self.emailTF.text = item?.email
        self.selectedOwnProperty = item?.ownsOtherProperty == "Yes" ? Option.Yes : Option.No
        self.ownPropertyYesImage.image = self.selectedOwnProperty == .Yes ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
        self.ownPropertyNoImage.image = self.selectedOwnProperty == .No ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
        self.numberOfProperty = item?.ownedPropertyCount ?? 0
        if self.numberOfProperty > 0 && self.selectedOwnProperty == .Yes{
            self.showPropertyTable()
            self.numberOfPropertyStack.isHidden = false
            self.numberOfPropertyTF.text = self.numberOfProperty.description
        }else{
            self.dropdownType = .Property
            self.propertyTableHidden = true
            self.showHideTable()
            self.numberOfPropertyStack.isHidden = true
        }
        self.nameTF.text = (item?.firstName ?? "") + " " + (item?.lastName ?? "")
        self.selectedName = (item?.firstName ?? "") + " " + (item?.lastName ?? "")
        var selectedBusinessType = self.viewModel.businessTypeArray.filter({$0.description.contains(GlobalFundingModelObject.business.businessType)}).first

         var businessMemberType = BusinessMemberType(rawValue: selectedBusinessType?.id ?? 0) ?? .none
        var title = ""
        switch businessMemberType {
        case .SoleTrade:
            title = "Application Form - Proprietor Details"
        case .Director:
            title = "Application Form - Director Details"
        case .Partner:
            title = "Application Form - Partner Details"
        default:
            title = "Application Form - Partner Details"
        }
        let attributedTitle = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 14.0), NSAttributedString.Key.foregroundColor: UIColor.black])

        self.titleLabel.attributedText = attributedTitle
        //Application Form - Director/Proprietor Details
        self.addressTable.reloadData()
        self.propertyTable.reloadData()
    }
}
extension DirectorDetailsViewController {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                switch self.dropdownType {
                case .Name:
                    self.nameTable.isHidden = false
                    self.nameTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.nameTableHeight.constant = CGFloat(GlobalFundingModelObject.business.remainingDirectorArray.count * 50)
                    self.nameTable.reloadData()
                    self.view.layoutIfNeeded()
                case .Property:
                    self.propertyTable.isHidden = false
                   // self.propertyTableHeight.constant = CGFloat(self.numberOfProperty * 90)
                    self.propertyTable.reloadData()
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
            case .Name:
                self.nameTable.isHidden = true
                self.nameTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.nameTableHeight.constant = 0
                self.nameTable.reloadData()
            case .Property:
                self.propertyTable.isHidden = true
               // self.propertyTableHeight.constant = 0
                self.propertyTable.reloadData()
            default:
                break
                
            }
        }, completion: nil)
    }
    func goNext() -> Bool {
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            return false
        }
        //        if (self.monthTF.text == nil || self.monthTF.text == "") {
        //            return false
        //        }
        //        if (self.yearTF.text == nil || self.yearTF.text == "") {
        //            return false
        //        }
        //        if (self.addressDetailsTF.text == nil || self.addressDetailsTF.text == "") {
        //            return false
        //        }
        if !self.isValidEmail(testStr: emailTF.text ?? "") {
            return false
        }
        if (self.phoneTF.text == nil || self.phoneTF.text == "") {
            return false
        }
        if (self.selectedName?.description == nil || self.selectedName?.description == "") {
            return false
        }
        //        if (self.selectedPostcode?.description == nil || self.selectedPostcode?.description == "") {
        //            return false
        //        }
        //        if (self.selectedHouseType?.description == nil || self.selectedHouseType?.description == "") {
        //            return false
        //        }
        if (self.selectedOwnProperty == .none) {
            return false
        }
        //        for element in self.addressArray {
        //            if element.address == "" {
        //                return false
        //            }
        //        }
        if self.selectedOwnProperty == .Yes && (self.numberOfPropertyTF.text == "" || self.numberOfPropertyTF.text == nil) {
            return false
        }
        for element in self.viewModel.propertyArray {
            if element.address == ""  {
                return false
            }
        }
        for element in self.viewModel.addressArray {
            if element.address == "" || element.startDate == "" || element.endDate == "" || element.houseOwnership?.description == "" || element.postCode?.description == "" {
                return false
            }}
        return true
    }
    func addressChecking() {
        for element in self.viewModel.addressArray {
            if element.address != "" && element.startDate != "" && element.endDate != "" && element.houseOwnership?.description != "" && element.postCode?.description != "" {
                self.addressTableErrStack.isHidden = true
            }
        }
    }
    func isValidTextFields() {
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please enter the email"
        }
        //    if (self.monthTF.text == nil || self.monthTF.text == "") {
        //        self.monthErrStack.isHidden = false
        //        self.monthErrLabel.text = "Please enter the Month Of Stay"
        //    }
        //    if (self.yearTF.text == nil || self.yearTF.text == "") {
        //        self.yearErrStack.isHidden = false
        //        self.yearErrLabel.text = "Please enter the Year Of Stay"
        //    }
        //    if (self.addressDetailsTF.text == nil || self.addressDetailsTF.text == "") {
        //        self.addressDetailsErrStack.isHidden = false
        //        self.addressDetailsErrLabel.text = "Please enter the Address details"
        //    }
        if !self.isValidEmail(testStr: emailTF.text ?? "") {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please Enter Valid Email"
        }
        if (self.phoneTF.text == nil || self.phoneTF.text == "") {
            self.phoneErrStack.isHidden = false
            self.phoneErrLabel.text = "Please enter Phone number"
        }
        if (self.selectedName?.description == nil || self.selectedName?.description == "") {
            self.NameErrStack.isHidden = false
            self.NameErrLabel.text = "Please select the title"
        }
        //    if (self.selectedPostcode?.description == nil || self.selectedPostcode?.description == "") {
        //        self.postcodeTypeErrStack.isHidden = false
        //        self.postcodeTypeErrLabel.text = "Please select post code"
        //    }
        if (self.selectedOwnProperty == .none) {
            self.ownPropertyErrStack.isHidden = false
            self.ownPropertyErrLabel.text = "Please choose anyone"
        }
        if self.selectedOwnProperty == .Yes && (self.numberOfPropertyTF.text == "" || self.numberOfPropertyTF.text == nil) {
            self.ownPropertyErrStack.isHidden = false
            self.ownPropertyErrLabel.text = "Please enter Number of property value"
        }
        if(self.selectedOwnProperty != .none) && (self.selectedOwnProperty == .Yes && (self.numberOfPropertyTF.text != "")){
                self.ownPropertyErrStack.isHidden = true
            }
            
            //    if (self.selectedHouseType?.description == nil || self.selectedHouseType?.description == "") {
            //        self.houseTypeErrStack.isHidden = false
            //        self.houseTypeErrLabel.text = "Please select House Ownership type"
            //    }
            self.addressTableErrStack.isHidden = true
            for element in self.viewModel.addressArray {
                if element.address == "" || element.startDate == "" || element.endDate == "" || element.houseOwnership?.description == "" || element.postCode?.description == "" {
                    self.addressTableErrStack.isHidden = false
                    self.addressTableErrLabel.text = "Please fill the address fields"
                }
            }
//            self.ownPropertyErrStack.isHidden = self.selectedOwnProperty == .none ? false : true
            
            for element in self.viewModel.propertyArray {
                if element.address == ""  {
                    self.ownPropertyErrStack.isHidden = false
                    self.ownPropertyErrLabel.text = "Please fill the details"
                }
            }
        }
}
extension DirectorDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == addressTable {
            return self.viewModel.addressArray.count
        }
        switch self.dropdownType {
        case .Name:
            count = GlobalFundingModelObject.business.remainingDirectorArray.count
        case .Property:
            count = self.numberOfProperty
        default:
            break
            
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.dropdownType == .Name && tableView == nameTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CellClass2 else {
                return UITableViewCell()
            }
            cell.label1.text = (GlobalFundingModelObject.business.remainingDirectorArray.value(atSafe: indexPath.row)?.firstName ?? "") + (GlobalFundingModelObject.business.remainingDirectorArray.value(atSafe: indexPath.row)?.lastName ?? "")
            cell.action1.setTitle("", for: .normal)
            cell.separator1.isHidden = (indexPath.row == GlobalFundingModelObject.business.remainingDirectorArray.count - 1)
            cell.action1.addTapGestureRecognizer {
                self.nameTF.text =  (GlobalFundingModelObject.business.remainingDirectorArray.value(atSafe: indexPath.row)?.firstName ?? "") + " " + (GlobalFundingModelObject.business.remainingDirectorArray.value(atSafe: indexPath.row)?.lastName ?? "")
                self.selectedName =  (GlobalFundingModelObject.business.remainingDirectorArray.value(atSafe: indexPath.row)?.firstName ?? "") + " " + (GlobalFundingModelObject.business.remainingDirectorArray.value(atSafe: indexPath.row)?.lastName ?? "")
//                GlobalFundingModelObject.business.directorArray.filter({$0.firstName == self.titleLabel.text})
                self.selectedDirectorIndex = (GlobalFundingModelObject.business.remainingDirectorArray.value(atSafe: indexPath.row)?.id ?? 0)
                self.nameTableHidden = !self.nameTableHidden
                self.dropdownType = .Name
                self.removeTransparentView()
                self.NameErrStack.isHidden = true
            }
            return cell

        }
        else if tableView == addressTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressTableViewCell", for: indexPath) as? AddressTableViewCell else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return UITableViewCell()}
            if model.isHouseExtended{
                cell.houseTable.isHidden = false
                cell.houseTypeTableHidden = false
                cell.dropdownType = .House
                cell.showHideTable()
            }else{
                cell.houseTable.isHidden = true
                cell.houseTypeTableHidden = true
                cell.dropdownType = .House
                cell.showHideTable()
            }
            if model.isPostcodeExtended{
                if cell.postcodeTable.isHidden == true {
                    
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        
                        cell.postcodeTable.isHidden = false
                        cell.postcodeTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                        cell.postcodeTable.reloadData()
                        cell.layoutIfNeeded()
                    }, completion: nil)
                }

            }else{
                cell.postcodeTable.isHidden = true
                //cell.postcodeTable.reloadData()
                if cell.postcodeTable.isHidden == false {
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        cell.postcodeTable.isHidden = true
                        cell.postcodeTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
            //                self.postcodeTableHeight.constant = 0
                        cell.postcodeTable.reloadData()
                        }, completion: nil)
                }


            }
            cell.model = model
            cell.addressDetailsTF.text = self.viewModel.addressArray.value(atSafe: indexPath.row)?.address
            cell.postcodeTypeTF.text = self.viewModel.addressArray.value(atSafe: indexPath.row)?.postCode?.description
            cell.startDateTF.text = model.startDate != nil ? model.startDate?.description : "startdate"
            cell.endDateTF.text = model.endDate != nil ? model.endDate?.description : "enddate"
            cell.houseTypeTF.text = self.viewModel.addressArray.value(atSafe: indexPath.row)?.houseOwnership?.description
            cell.viewModel = self.viewModel
            cell.delegate = self
//            cell.postcodeTableArrowActionView.addTapGestureRecognizer {
//                cell.dropdownType = .RegPost
//                cell.postcodeTableHidden = !cell.postcodeTableHidden
//                guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return}
//                model.isPostcodeExtended = !model.isPostcodeExtended
//                cell.showHideTable()
//                self.addressTable.reloadData()
//            }
//            cell.postcodeTypeTF.addTapGestureRecognizer {
//                cell.dropdownType = .RegPost
//                cell.postcodeTableHidden = !cell.postcodeTableHidden
//                guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return}
//                model.isPostcodeExtended = !model.isPostcodeExtended
//                cell.showHideTable()
//                self.addressTable.reloadData()
//            }
//            cell.houseTableArrowActionView.addTapGestureRecognizer {
//                cell.dropdownType = .House
//                cell.houseTypeTableHidden = !cell.houseTypeTableHidden
//                guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return}
//                model.isHouseExtended = !model.isHouseExtended
//                cell.showHideTable()
//                self.addressTable.reloadData()
//            }
            cell.houseTypeTF.addTapGestureRecognizer {
                cell.dropdownType = .House
                cell.houseTypeTableHidden = !cell.houseTypeTableHidden
                guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return}
                model.isHouseExtended = !model.isHouseExtended
                cell.showHideTable()
                self.addressTable.reloadData()
            }
            cell.startDateTF.addTapGestureRecognizer {
                let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                     popup.modalPresentationStyle = .overFullScreen
                     popup.isReadableFormat = true
                popup.stayMaxDate = model.endDateObj
                popup.stayCollectionRestriction = true
                     self.present(popup, animated: true, completion: nil)
                     popup.dateSelectionHandler = { [weak self] fromDate, DateObj in
    //                     self?.dateSelectionHandler?(fromDate, toDate, "\(fromDate) - \(toDate ?? "")")
    //                     self?.removeAnimate()
                         if cell.model.endDateObj != nil {
                             if DateObj.compare(cell.model.endDateObj ?? Date()) == .orderedAscending {
                             }else if DateObj.compare(cell.model.endDateObj ?? Date()) == .orderedSame {
                             }else{
                                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                     self?.showAlert(title: "Info", message: "Start date should be earlier than End Date")
                                 }
                                 self?.dismiss(animated: true)
                                 return
                             }
                         }
                         print(fromDate)
                         cell.startDateTF.text = fromDate
                         selectedStartDate = DateObj
                         cell.model.startDate = fromDate
                         cell.model.startDateObj = DateObj
                         cell.validatingDates()
                         self?.dismiss(animated: true)
                     }
                }
            cell.endDateTF.isUserInteractionEnabled = false
//            cell.endDateTF.addTapGestureRecognizer {
//                let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
//                     popup.modalPresentationStyle = .overFullScreen
//                     popup.isReadableFormat = true
//                     self.present(popup, animated: true, completion: nil)
//                     popup.dateSelectionHandler = { [weak self] fromDate, DateObj in
//    //                     self?.dateSelectionHandler?(fromDate, toDate, "\(fromDate) - \(toDate ?? "")")
//    //                     self?.removeAnimate()
//                         print(fromDate)
//                         if cell.model.startDateObj?.compare(DateObj ?? Date()) == .orderedAscending {
//                         }else if cell.model.startDateObj?.compare(DateObj ?? Date()) == .orderedSame {
//                         }else{
//                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                 self?.showAlert(title: "Info", message: "Start date should be earlier than End Date")
//                             }
//                             self?.dismiss(animated: true)
//                             return
//                         }
//                         cell.endDateTF.text = fromDate
//                         selectedEndDate = DateObj
//                         cell.model.endDateObj = DateObj
//                         cell.model.endDate = fromDate
//                         cell.validatingDates()
//                         self?.dismiss(animated: true)
//                     }
//                }
            return cell
        }
        else if self.dropdownType == .Property && tableView == propertyTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell2", for: indexPath) as? AddressCell else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.propertyArray.value(atSafe: indexPath.row) else {return UITableViewCell()}
            
            cell.model = model
            cell.viewModel = self.viewModel
            cell.addressTF.text = model.address
            cell.delegate = self
            if model.isExtended {
                cell.cityTable.isHidden = false
                cell.cityTableHidden = false
                cell.showHideTable()
            }else{
                cell.cityTable.isHidden = true
                cell.cityTableHidden = true
                cell.showHideTable()
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == addressTable {
            return UITableView.automaticDimension
        } else if tableView == propertyTable {
            return UITableView.automaticDimension
        }else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
extension DirectorDetailsViewController: CellDelegate{
    func reload() {
        
            self.propertyTable.reloadData()
    }
    func particularReloadOf()
    {
        self.propertyTable.reloadData() //reloadRows(at: [propertyTextFieldIndexPath], with: .none)
    }
}
extension DirectorDetailsViewController: AddressCellDelegate {
    func addressReload() {
        self.addressChecking()
        self.addressTable.reloadData()
    }
    func increaseAddressField() {
        if self.viewModel.addressArray.count >= 1 {
            var new = self.viewModel.addressArray.last
            var lastDate = new?.startDateObj
            let newDate = Calendar.current.date(byAdding: .day, value: -1, to: lastDate ?? Date()) ?? Date()
            var model = AddressAloneModel()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let fromDateString = dateFormatter.string(from: newDate)
            model.endDate = fromDateString
            model.endDateObj = newDate
            self.viewModel.addressArray.append(model)
        }else{
            var model = AddressAloneModel()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let fromDateString = dateFormatter.string(from: Date())
            model.endDate = fromDateString
            model.endDateObj = Date()
            self.viewModel.addressArray.append(model)
        }
        self.addressChecking()
        self.addressTable.reloadData()
    }
    func particularReload(){
        self.addressChecking()
        if textFieldIndexPath.count != 0 {
            self.addressTable.reloadRows(at: [textFieldIndexPath], with: .none)
        }else{
            self.addressTable.reloadData()
        }
    }
    func showAlertForCell(title: String) {
        self.showAlert(title: "Info", message: title)
    }
}
//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension DirectorDetailsViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        switch textField {
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
            }
        default: break
        }
        
        return true
    }
    
    func updateProceedButtonUI(enabled: Bool) {
                self.nextButton.isUserInteractionEnabled = enabled
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.emailTF {
            self.emailErrStack.isHidden = true
        }
        if textField == self.phoneTF {
            self.phoneErrStack.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case self.emailTF:
            if (self.emailTF.text == nil || self.emailTF.text == "") {
                self.emailErrStack.isHidden = false
                self.emailErrLabel.text = "Please enter the email"
            }
            if !self.isValidEmail(testStr: emailTF.text ?? "") {
                self.emailErrStack.isHidden = false
                self.emailErrLabel.text = "Please Enter Valid Email"
            }

//        case self.yearTF:
//            if (self.yearTF.text == nil || self.yearTF.text == "") {
//                self.yearErrStack.isHidden = false
//                self.yearErrLabel.text = "Please enter the Year Of Stay"
//            }
//            if self.yearTF.text?.toInt() ?? 0 < 3 {
//                self.infoView.isHidden = false
//                self.addressTable.isHidden = false
//                self.addressCount = 0
//                self.addressTableHeight.constant = 0
//                self.addressTable.reloadData()
//            }else{
//                self.infoView.isHidden = true
//                self.addressTable.isHidden = true
//                self.addressCount = 0
//                self.addressArray.removeAll()
//            }
        case self.phoneTF:
            if (self.phoneTF.text == nil || self.phoneTF.text == "") {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Please enter Phone number"
            }
        case self.numberOfPropertyTF:
            guard let count = textField.text?.toInt() else{
                return
            }
            numberOfProperty = count
            if count > 0 {
                self.viewModel.createPropertyArray(count: count)
                self.showPropertyTable()
                self.ownPropertyErrStack.isHidden = true
            }
        default:
            break
        }
        //        self.updateNextButton()
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension DirectorDetailsViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.addressTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.addressTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.propertyTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.propertyTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.addressTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.propertyTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.addressTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView = self.propertyTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
