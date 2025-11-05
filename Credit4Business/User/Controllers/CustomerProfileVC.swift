//
//  CustomerProfileVC.swift
//  Credit4Business
//
//  Created by MacMini on 23/05/24.
//

import UIKit
import Photos
import MobileCoreServices
import UniformTypeIdentifiers

class CustomerProfileVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var headersCollection: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitButtonView: UIView!
    
    @IBOutlet weak var customerPhoneLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerNameHeader: UILabel!
    
    @IBOutlet weak var identityVerificationResentBtn: UIButton!
    @IBOutlet weak var identityVerificationView: UIView!
    @IBOutlet weak var identityVerificationSendBtn: UIButton!
    @IBOutlet weak var identityVerificationFailView: UIView!
    @IBOutlet weak var directorsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var directorsTable: UITableView!
    @IBOutlet weak var directorKycStatusLabel: UILabel!
    @IBOutlet weak var identityVerificationSuccessView: UIStackView!
    //MARK: -------------------- Class Variable --------------------
    var customerId = ""
    var customerName = ""
    var customerPhone = ""
    var selectedLoanId = 0

    var viewModel = HomeVM()
//    var menuItems = ["Personal Details","Funding Details","Units","Identity Verification","Pending Approvals"]
    var menuItems = ["Personal Details","Funding Details","Units","Identity Verification","Contract Summary"]

    var selectedIndex = 0
    var selectedDocumentIndex = 0
    var selectedPhotoIdResponse : PhotoIDDataClass?
    var selectedAddressProofResponse : AddressProofDataClass?
    var selectedOtherResponse : OtherData?
    var selectedBankStatementResponse : BankStatementData?
    var paymentArray = [FundingPayment]()
    var historyArray = [FundingPaymentHistory]()
    
    var personalKVArray = [MenuModel]()
    var currentUnitPageIndex = 1{
           didSet {
               print(currentUnitPageIndex.description)
           }
       }
       var totalUnitPages = 1{
           didSet {
               print(totalUnitPages.description)
           }
       }
       var HittedUnitPageIndex = 0
       var oneTimeForUnitHit : Bool = true
    var companyList = [CompanyList]()
    var companyObject : CompanyListModel?
    var selectedIdentityVerificationResponse: IdentityVerificationStatusModelForCustomer?
    var pendingApprovalData = [ProfileChange]()
    var loanModel : LoanModel?
    var summaryModel: SummaryDataClass?

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if let tabbar = self.parent?.parent as? TabBarController {
            if let navigationController = tabbar.parent as? UINavigationController {
                navigationController.isNavigationBarHidden = true
            }
        }
//        self.fetchPhotoIDDetails()
//        self.fetchAddressProofDetails()
//        self.fetchPaymentDetails()
//        self.fetchOtherFilesDetails()
//        self.fetchBankStatementDetails()
        self.companyList.removeAll()
        self.createModelArrayForPersonal()
        self.fetchLoanDetails()
        self.currentUnitPageIndex = 0
        self.HittedUnitPageIndex = 0
        self.fetchCompanyListDetails()
        self.identityVerificationView.isHidden = true
        self.identityVerificationSuccessView.isHidden = true
        self.directorKycStatusLabel.isHidden = true

    }
    func setDelegates() {
        self.headersCollection.delegate = self
        self.headersCollection.dataSource = self
        self.detailsTable.delegate = self
        self.detailsTable.dataSource = self
        self.directorsTable.delegate = self
        self.directorsTable.dataSource = self
        self.addObserverOnHeightTbl()
        self.customerNameHeader.text = self.customerName
        self.customerNameLabel.text = self.customerName
        self.customerPhoneLabel.text = "+44 " + self.customerPhone
    }
    func manageActionMethods() {
        self.backBtn.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        self.identityVerificationSendBtn.addTapGestureRecognizer {
            self.createIdentityDetails()
            self.identityVerificationSendBtn.isHidden = true
            self.identityVerificationResentBtn.isHidden = false
        }
        self.identityVerificationResentBtn.addTapGestureRecognizer {
            self.createIdentityDetails()
        }
    }
    @objc func submitAction() {
        var dataArray = [String: Any]()
        for element in self.viewModel.documentArray {

            dataArray["\(element.apiKey)"] = UploadDocumentModel(data: element.fileData ?? Data(), fileName: element.fileName, mimeType: element.mimeType, fileType: element.fileType)
        }
//            for element in self.viewModel.documentArray {
//                fileNames.append(element.fileName)
//            }
        self.createDocumentDetails(api: self.selectedIndex == 2 ? (APIEnums.createPhotoId.rawValue + "?customer_id=\(customerId)"): APIEnums.createAddressProof.rawValue + "?customer_id=\(customerId)" ,paramDict: JSON(), dataArray: dataArray)
    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory(customerId: String,customerName: String,customerPhone: String) -> CustomerProfileVC {
        let vc : CustomerProfileVC = UIStoryboard.Login.instantiateViewController()
        vc.customerId = customerId
        vc.customerName = customerName
        vc.customerPhone = customerPhone
        return vc
    }
}
extension CustomerProfileVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollectionViewCell",
                                                      for: indexPath) as! ProfileCollectionViewCell
        cell.titleLabel.text = self.menuItems.value(atSafe: indexPath.row)
        cell.separatorLabel.isHidden = self.selectedIndex == indexPath.row ? false : true

        cell.addTapGestureRecognizer {
            self.selectedIndex = indexPath.row
            self.headersCollection.reloadData()
            
            //            switch self.selectedIndex {
            
            if cell.titleLabel.text == "Personal Details" ||  cell.titleLabel.text == "Funding Details" || cell.titleLabel.text == "Units" {
                
                self.detailsTable.isHidden = false
                self.identityVerificationView.isHidden = true

                if cell.titleLabel.text == "Funding Details" {
                    self.fetchLoanDetails()
                }
                self.detailsTable.reloadData()
            }
            else if cell.titleLabel.text == "Identity Verification" {
                self.detailsTable.isHidden = true
                self.identityVerificationView.isHidden = false
                self.identityVerificationSendBtn.isHidden = false
                self.identityVerificationResentBtn.isHidden = true
                self.fetchIdentityVerificationStatus()
            }
            else if cell.titleLabel.text == "Pending Approvals" {
                self.detailsTable.isHidden = true
                self.identityVerificationView.isHidden = true
                self.fetchPendingApprovalDetails()
            }
            else if cell.titleLabel.text == "Contract Summary" {
                self.detailsTable.isHidden = false
                self.identityVerificationView.isHidden = true
                self.fetchCashDisburshedDetails()
            }
            
        }
        return cell
    }
}
extension CustomerProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case detailsTable:
            switch self.selectedIndex {
            case 0:
                return self.personalKVArray.count
            case 1:
                return self.loanModel?.data.count ?? 0
            case 2:
                return self.companyList.count
            case 4:
                return 1
            default:
                return 0
            }
        case directorsTable:
            return self.selectedIdentityVerificationResponse != nil ? 1 : 0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == detailsTable {
                
            if self.selectedIndex == 0 {
                guard let cellnew = tableView.dequeueReusableCell(withIdentifier: "leadsDetailsCell2", for: indexPath) as? LeadsDetailsCell else {
                    return UITableViewCell()
                }
                cellnew.titleLabel.text = self.personalKVArray.value(atSafe: indexPath.row)?.title
                cellnew.valueLabel.text = self.personalKVArray.value(atSafe: indexPath.row)?.value
                return cellnew
            }
            else if self.selectedIndex == 4 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "summaryTableViewCell", for: indexPath) as? SummaryTableViewCell else {
                    return UITableViewCell()
                }
                if cell.isExtended{
                    cell.innerTableView.isHidden = false
                    cell.innerTableHidden = false
                    cell.showHideTable()
                    
                }else{
                    cell.innerTableView.isHidden = true
                    cell.innerTableHidden = true
                    cell.showHideTable()
                    
                }
                if cell.ishistoryExtended{
                    cell.historyTable.isHidden = false
                    cell.historyTableHidden = false
                    cell.showHideTable()
                    
                }else{
                    cell.historyTable.isHidden = true
                    cell.historyTableHidden = true
                    cell.showHideTable()
                    
                }
                var model = self.summaryModel?.loans.first(where: {$0.loanNumber == self.selectedLoanId})//self.summaryModel?.loans.value(atSafe: indexPath.row)

                cell.model = summaryModel?.summary
                cell.historyArray = self.historyArray
                cell.delegate = self
                cell.loanModel = summaryModel
                cell.imageActionView.addTapGestureRecognizer {
                    cell.dropdownType = .loanNumber
                    cell.innerTableHidden = !cell.innerTableHidden
//                    guard let model = self.viewModel.paymentArray.value(atSafe: indexPath.row) else {return}
                    cell.isExtended = !cell.isExtended
                    cell.showHideTable()
                    self.detailsTable.reloadData()
                }
                cell.historyImageActionView.addTapGestureRecognizer {
                    cell.dropdownType = .history
                    cell.historyTableHidden = !cell.historyTableHidden
//                    guard let model = self.viewModel.paymentArray.value(atSafe: indexPath.row) else {return}
                    cell.ishistoryExtended = !cell.ishistoryExtended
                    cell.showHideTable()
                    self.detailsTable.reloadData()
                }
                cell.loanNumberLabel.text = "Loan Number :  " + "\(model?.loanNumber.description ?? "")"
                cell.amountLabel.text = model?.loanAmount.description ?? ""
                cell.remainingInstallmentsLabel.text = model?.remainingInstalment.description ?? ""
                cell.totalInstallmentsLabel.text = model?.totalInstalment.description ?? ""
                cell.paidInstallmentsLabel.text = model?.instalmentPaid.description ?? ""
                cell.gocardlessMissedEmisLabel.text = model?.gocardlessMissedEmis.description ?? ""
                return cell

            }
            else if self.selectedIndex == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell2", for: indexPath) as? LeadsCell else {
                    return UITableViewCell()
                }
                var model = self.loanModel?.data.value(atSafe: indexPath.row)
                cell.leadsName.text = model?.customer.companyName
              //  cell.loanStatusButton.setTitle(model?.customer.loanDetails.first?.currentStatus ?? "", for: .normal)
                if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus != "" {
                    // cell.loanStatusButton.isHidden = false
                    var color = "yellow"
                    if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus == "Admin_Cash_Disbursed" {
                        color = "green"
                    }else if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus.lowercased().contains("rejected") ?? false || model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus.lowercased().contains("returned") ?? false {
                        color = "red"
                    }
                    cell.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)

                    let attributedTitle = NSMutableAttributedString(string: model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])
                    
                    cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                }else{
                    //cell.loanStatusButton.isHidden = true
                }
                
               // cell.requestedDateLabel.text = "23-08-2024"//model?.appliedDate ?? ""
                cell.dateStack.isHidden = true

                cell.leadsName.accessibilityHint = model?.id ?? ""
                return cell
            }
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell", for: indexPath) as? LeadsCell else {
                    return UITableViewCell()
                }

                var model = self.companyList.value(atSafe: indexPath.row)
                cell.leadsName.text = (self.companyList.value(atSafe: indexPath.row)?.companyName ?? "")
                cell.loanStatusButton.setTitle(model?.companyStatus ?? "", for: .normal)
                if model?.companyStatus != "" {
                    let attributedTitle = NSMutableAttributedString(string: model?.companyStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                    cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                }
                
                cell.leadsName.accessibilityHint = model?.id ?? ""

                return cell
            }
            
            return UITableViewCell()
            }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "kycStatusCell", for: indexPath) as? KYCStatusCell else {
                return UITableViewCell()
            }
            var model = self.selectedIdentityVerificationResponse?.data//.value(atSafe: indexPath.row)
            cell.emailValueLabel.text = model?.customer.email
            cell.nameValueLabel.text = (model?.customer.firstName ?? "") + " " + (model?.customer.lastName ?? "")
            cell.phoneValueLabel.text = model?.customer.phoneNumber
            if model?.customer != nil {
                let attributedTitle = NSMutableAttributedString(string: model?.kycStatus == true ? "Completed" : "Inprogress", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0) ?? .boldSystemFont(ofSize: 10.0), NSAttributedString.Key.foregroundColor: UIColor(named: "green") ?? .green])

                    cell.kycStatusButton.setAttributedTitle(attributedTitle, for: .normal)
            }
           
            return cell
        }
        return UITableViewCell()
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return getfooterView()
//    }

    func getfooterView() -> UIView
    {
        let Header = UIView(frame: CGRect(x: 0, y: 0, width: Double(self.detailsTable.frame.size.width), height: 60))
        Header.backgroundColor = UIColor(named: "#2AF8AC")
        let button = UIButton()
         button.frame = CGRect(x: 10, y: 10, width: Header.frame.size.width - 20, height: Header.frame.size.height - 20)
        button.backgroundColor = UIColor(named: "blue")
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 18.0)
        button.addTarget(self, action: #selector(submitAction), for: UIControl.Event.touchUpInside)

        Header.addSubview(button)
        Header.bringSubviewToFront(button)
        return Header
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if selectedIndex == 2 || selectedIndex == 3 {
//            return 80
//        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == detailsTable {
            if self.selectedIndex == 1 {
                guard let model = self.loanModel?.data.value(atSafe: indexPath.row) else{
                    return
                }
                let vc = ProfileDetailsVC.initWithStory(loanData: model,index: indexPath.row)
                self.navigationController?.pushViewController(vc, animated: true)

                
            }
            else if self.selectedIndex == 2 {
                guard let model = self.companyList.value(atSafe: indexPath.row) else{
                    return
                }
                let vc = UnitDetailsVC.initWithStory(companyDetails: model)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == detailsTable && self.selectedIndex == 1 {
            return 130
        }
        else if tableView == detailsTable && self.selectedIndex == 2 {
            return 75
        }
        
        return UITableView.automaticDimension
    }
}
extension CustomerProfileVC {
    func fetchCashDisburshedDetails() {
        APIService.shared.retrieveCashDisbursedDetails(customerId: self.customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.summaryModel = responseData
                        self.selectedLoanId = self.summaryModel?.loans.first?.loanNumber ?? 0
                        var loanmodel = self.summaryModel?.loans.first(where: {$0.loanNumber == self.selectedLoanId})
                        self.historyArray = loanmodel?.fundingPaymentHistory ?? [FundingPaymentHistory]()
                        for data in loanmodel!.gocardlessMissedEmiDates {
                            self.historyArray.append(FundingPaymentHistory(id: data.id, date: data.emiDate, amount: data.amount, description:"Payment Failed"))
                        }

//                        self.paymentArray = responseData.fundingPayments
//                        self.historyArray = responseData.fundingPaymentHistory
                        self.detailsTable.reloadData()
                    }
                    catch {
                        
                    }
                    self.detailsTable.reloadData()
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
    func fetchPendingApprovalDetails() {
        APIService.shared.retrievePendingApprovalDetails(type: "customer_profile", customerId: self.customerId ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.pendingApprovalData = responseData.data
                        //self.createModelArrayForLoan()
                    }
                    catch {
                        
                    }
                }
                else {
                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func fetchLoanDetails() {
        APIService.shared.retrieveLoanDetailsWithCustomerID(customerId: self.customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.loanModel = responseData
                        globalLoanModel = self.loanModel
                        self.detailsTable.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func createModelArrayForPersonal() {
        self.personalKVArray.removeAll()
//        let email = MenuModel.init(title: "Email", value: self.selectedPersonalResponse?.email ?? "", apiKey: "")
//        let title = self.selectedPersonalResponse?.title ?? ""
//        let fname = self.selectedPersonalResponse?.firstName ?? ""
//        let lname = self.selectedPersonalResponse?.lastName ?? ""
//        let fullname = fname + " " + lname

        let name = MenuModel.init(title: "Name", value: self.customerName, apiKey: "")
//        let dob = MenuModel.init(title: "Is User 18+ ?", value: self.selectedPersonalResponse?.isMajor.description ?? "", apiKey: "")
//        let pincode = MenuModel.init(title: "Pincode", value: self.selectedPersonalResponse?.pincode ?? "", apiKey: "")
//        let address = MenuModel.init(title: "Address", value: self.selectedPersonalResponse?.address ?? "", apiKey: "")
        
        let phone = MenuModel.init(title: "Phone Number", value: self.customerPhone, apiKey: "")
//        let amount = MenuModel.init(title: "Amount you Need", value: self.selectedPersonalResponse?.fundRequestAmount ?? "", apiKey: "")
//        let duration = MenuModel.init(title: "Duration (In weeks)", value: self.selectedPersonalResponse?.fundRequestDurationWeeks.description ?? "", apiKey: "")
//        self.personalKVArray.append(email)
        self.personalKVArray.append(name)
//        self.personalKVArray.append(dob)
//        self.personalKVArray.append(pincode)
//        self.personalKVArray.append(address)
        self.personalKVArray.append(phone)
//        self.personalKVArray.append(amount)
//        self.personalKVArray.append(duration)
        let id = MenuModel.init(title: "Id", value: self.customerId, apiKey: "")
        self.personalKVArray.append(id)
    }
    func fetchCompanyListDetails() {
        var page = self.currentUnitPageIndex+1
              guard  self.HittedUnitPageIndex != self.currentUnitPageIndex + 1 else {
                  return
              }
        
        var urlStr = APIEnums.retrieveCompanies.rawValue + "?customer_id=\(self.customerId)"
        if page != 1 {
            urlStr = urlStr + "?page=\(page)"
        }
        APIService.shared.retrieveCompanyListDetails(url: urlStr) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.companyObject = data
                        self.companyList.append(contentsOf: responseData)
                        let next = self.getQueryItems(data.next)
                        let last = self.getQueryItems(data.last)
                        let Lastitem = last.filter({$0.key == "page"}).first?.value
                        let currentItem = next.filter({$0.key == "page"}).first?.value

                        self.totalUnitPages = (Lastitem?.toInt() ?? 0)
                        self.currentUnitPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.HittedUnitPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.detailsTable.reloadData()                    }
                    catch {
                        
                    }
                    self.oneTimeForUnitHit = true
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func createIdentityDetails() {
        APIService.shared.makeRequest(endpoint: APIEnums.createIdentityFromCustomer.rawValue + "\(self.customerId ?? "")/",
                                      withLoader: true,
                                      method: .post,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.fetchIdentityVerificationStatus()
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
    func fetchIdentityVerificationStatus() {
        APIService.shared.retrieveIdentityVerificationStatus(customerId: self.customerId ?? "" ) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedIdentityVerificationResponse = data
                        if self.selectedIdentityVerificationResponse?.data.kycStatus == true {
                            self.identityVerificationFailView.isHidden = true
                            self.identityVerificationSuccessView.isHidden = false
                            self.directorsTable.isHidden = false
                            self.directorKycStatusLabel.isHidden = false
                            self.directorsTable.reloadData()
                        }else{
                            self.identityVerificationFailView.isHidden = false
                            self.identityVerificationSuccessView.isHidden = true
                            self.directorsTable.isHidden = true
                            self.directorKycStatusLabel.isHidden = true
                        }
//                        if self.selectedIdentityVerificationResponse?.data.kycStatus == true {
//                            self.identityVerificationFailView.isHidden = true
//                            self.identityVerificationSuccessView.isHidden = false
//                            self.directorsTable.isHidden = false
//                            self.directorKycStatusLabel.isHidden = false
//                            self.directorsTable.reloadData()
//                        }else{
//                            self.identityVerificationFailView.isHidden = false
//                            self.identityVerificationSuccessView.isHidden = true
//                            self.directorsTable.isHidden = true
//                            self.directorKycStatusLabel.isHidden = true
//                        }
                    }
                    catch {
                        
                    }
                }
                else {
                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func fetchOtherFilesDetails() {
        APIService.shared.retrieveOtherFilesDetailsFromAgent(customerId: self.customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedOtherResponse = responseData
                        self.viewModel.otherArray.removeAll()
                        if self.selectedOtherResponse?.otherFiles.count != 0 {
                            for item in self.selectedOtherResponse?.otherFiles ?? [MultipleDocumentsDataClass]() {
                                let model = DocumentModel()
                                model.isSelected = true
                                model.type =  "Other Files"
                                model.apiKey = "other_files"
                                model.fileName = URL(fileURLWithPath: item.file ?? "").deletingPathExtension().lastPathComponent
                                model.fileURL = item.file ?? ""
                                self.viewModel.otherArray.append(model)
                            }
                        }
                    }
                    catch {
                        
                    }
                    self.detailsTable.reloadData()
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchBankStatementDetails() {
        APIService.shared.retrieveBankStatementDetailsFromAgent(customerId: self.customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedBankStatementResponse = responseData
                        self.viewModel.statementArray.removeAll()
                        if self.selectedBankStatementResponse?.businessAccountStatement.count != 0 {
                            for item in self.selectedBankStatementResponse?.businessAccountStatement ?? [MultipleDocumentsDataClass]() {
                                let model = DocumentModel()
                                model.isSelected = true
                                model.type =  "Bank Statement"
                                model.apiKey = "business_account_statements"
                                model.fileName = URL(fileURLWithPath: item.file ?? "").deletingPathExtension().lastPathComponent
                                model.fileURL = item.file ?? ""
                                self.viewModel.statementArray.append(model)
                            }
                        }
                    }
                    catch {
                        
                    }
                    self.detailsTable.reloadData()
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchPaymentDetails() {
        APIService.shared.retrievePaymentDetailsFromAgent(customerId: self.customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.paymentArray = responseData.fundingPayments
                        self.historyArray = responseData.fundingPaymentHistory
                        self.detailsTable.reloadData()
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
    func fetchPhotoIDDetails() {
        APIService.shared.retrievePhotoIDDetailsFromAgent(customerId: self.customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedPhotoIdResponse = responseData
                        //self.deletePhotoIDDetails()
                        self.viewModel.documentArray.removeAll()
                        if self.selectedPhotoIdResponse?.photo != "" && self.selectedPhotoIdResponse?.photo != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Photo"
                            model.apiKey = "photo"
                            model.fileName = URL(fileURLWithPath: self.selectedPhotoIdResponse?.photo ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedPhotoIdResponse?.photo ?? ""
                            self.viewModel.documentArray.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Photo"
//                            model.apiKey = "photo"
//                            self.viewModel.documentArray.append(model)
//                        }
                        if self.selectedPhotoIdResponse?.passport != "" && self.selectedPhotoIdResponse?.passport != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Passport"
                            model.apiKey = "passport"
                            model.fileName = URL(fileURLWithPath: self.selectedPhotoIdResponse?.passport ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedPhotoIdResponse?.passport ?? ""

                            self.viewModel.documentArray.append(model)
                        }
                        if self.selectedPhotoIdResponse?.drivingLicense != "" && self.selectedPhotoIdResponse?.drivingLicense != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Driving License"
                            model.apiKey = "driving_license"
                            model.fileName = URL(fileURLWithPath: self.selectedPhotoIdResponse?.drivingLicense ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedPhotoIdResponse?.drivingLicense ?? ""
                            self.viewModel.documentArray.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Passport Or Driving License"
//                            model.apiKey = "passport_or_driving_license"
//                            self.viewModel.documentArray.append(model)
//                        }
                        self.detailsTable.reloadData()

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
    func fetchAddressProofDetails() {
        APIService.shared.retrieveAddressProofDetailsFromAgent(customerId: self.customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedAddressProofResponse = responseData
                        //self.deleteAddressProofDetails()
                        self.viewModel.documentArray2.removeAll()
                        if self.selectedAddressProofResponse?.councilTax != "" && self.selectedAddressProofResponse?.councilTax != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Council Tax"
                            model.apiKey = "council_tax"
                            model.fileName = URL(fileURLWithPath: self.selectedAddressProofResponse?.councilTax ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedAddressProofResponse?.councilTax ?? ""
                            self.viewModel.documentArray2.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Council Tax"
//                            model.apiKey = "council_tax"
//                            self.viewModel.documentArray2.append(model)
//                        }
                        if self.selectedAddressProofResponse?.utilityBill != "" && self.selectedAddressProofResponse?.utilityBill != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Utility Bill"
                            model.apiKey = "utility_bill"
                            model.fileName = URL(fileURLWithPath: self.selectedAddressProofResponse?.utilityBill ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedAddressProofResponse?.utilityBill ?? ""

                            self.viewModel.documentArray2.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Utility Bill"
//                            model.apiKey = "utility_bill"
//                            self.viewModel.documentArray2.append(model)
//                        }
                        if self.selectedAddressProofResponse?.leaseDeed != "" && self.selectedAddressProofResponse?.leaseDeed != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Lease Deed"
                            model.apiKey = "lease_deed"
                            model.fileName = URL(fileURLWithPath: self.selectedAddressProofResponse?.leaseDeed ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedAddressProofResponse?.leaseDeed ?? ""

                            self.viewModel.documentArray2.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Lease Deed"
//                            model.apiKey = "lease_deed"
//                            self.viewModel.documentArray2.append(model)
//                        }
                        self.detailsTable.reloadData()

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
    func deleteAddressProofDetails() {
        APIService.shared.deletePhotoIDDetailsApi(endpoint: APIEnums.retrieveAddressProof.rawValue,
                                      withLoader: true,
                                      method: .delete,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode.description.toInt() == 200 {
                    let responseData = data.statusMessage
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
    func deletePhotoIDDetails() {
        APIService.shared.deletePhotoIDDetailsApi(endpoint: APIEnums.retrievePhotoId.rawValue,
                                      withLoader: true,
                                      method: .delete,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode.description.toInt() == 200 {
                    let responseData = data.statusMessage
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
    func createDocumentDetails(api: String,paramDict: JSON,dataArray: [String: Any]) {
        ConnectionHandler().uploadDocuments(wsMethod: api, paramDict: JSON(), dataArray: dataArray, viewController: self, isToShowProgress: true, isToStopInteraction: true) { response in
            if response.status_code == 201 {
                print(response)

            }
            else if response.status_code == 401 {
                self.tokenRefreshApi(paramDict: JSON(), dataArray: dataArray)
            }
            else{
                print(response)
            }
        }
    }
    func tokenRefreshApi(paramDict: JSON,dataArray: [String: Any]) {
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

                    self.createDocumentDetails(api: self.selectedIndex == 2 ? APIEnums.createPhotoId.rawValue + "customer_id=\(self.customerId)" : APIEnums.createAddressProof.rawValue + "customer_id=\(self.customerId)", paramDict: paramDict, dataArray: dataArray)
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
}
//MARK: -------------------------- Observers Methods --------------------------
extension CustomerProfileVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.detailsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            //self.menuTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.directorsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
          //  self.directorsTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.detailsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.directorsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.detailsTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView2 = self.directorsTable else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
extension CustomerProfileVC: CellDelegate{
    func reload() {
        self.detailsTable.reloadData()
    }
    func particularReloadOf() {
    }
}
extension CustomerProfileVC: SummaryCellDelegate {
    func summaryreload() {
        self.detailsTable.reloadData()
    }
    func summaryparticularReloadOf() {
    }
    func selectedLoanId(id: Int) {
        self.selectedLoanId = id
        var loanmodel = self.summaryModel?.loans.first(where: {$0.loanNumber == self.selectedLoanId})
        self.historyArray = loanmodel?.fundingPaymentHistory ?? [FundingPaymentHistory]()
        for data in loanmodel!.gocardlessMissedEmiDates {
            self.historyArray.append(FundingPaymentHistory(id: data.id, date: data.emiDate, amount: data.amount, description:"Payment Failed"))
        }

        self.detailsTable.reloadData()
    }
}
extension CustomerProfileVC {
    func redirectToImageChooseVC()
    {
        let types: [String] = [kUTTypePDF as String,kUTTypeJPEG as String,kUTTypePNG as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
        }
}
extension CustomerProfileVC : UIDocumentPickerDelegate {
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
        
        self.dismiss(animated: true, completion: nil)
    }
    func fileChecking(url:URL){
        var sizeKB = self.sizePerKB(url: url)
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
            let fileMIMEType = self.mimeTypeForPath(fileType: fileType)

            print(fileName)
            print(fileType)
            do {
                let fileData = try Data.init(contentsOf: url)
                let fileStream:String = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
                guard let selectedModel = self.viewModel.documentArray.value(atSafe: self.selectedDocumentIndex) else {return}
                selectedModel.fileName = fileName + "." + fileType
                selectedModel.isSelected = true
                selectedModel.fileString = fileStream
                selectedModel.fileSize = sizeKB.description.toInt().description + "KB"
                selectedModel.fileData = fileData
                selectedModel.fileType = fileType
                selectedModel.mimeType = fileMIMEType
                self.detailsTable.reloadData()
            }
            catch { }}
    }
}
extension CustomerProfileVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = detailsTable.visibleCells.last as? LeadsCell
        guard ((cell?.leadsName.text) != nil),
              (self.companyList.last != nil), self.selectedIndex == 2 else {return}
        if cell?.leadsName.accessibilityHint == (self.companyList.last?.id) &&
            self.companyObject?.next != "" && self.currentUnitPageIndex != self.totalUnitPages && oneTimeForUnitHit {
            self.fetchCompanyListDetails()
            self.oneTimeForUnitHit = !self.oneTimeForUnitHit
        }
    }
}
