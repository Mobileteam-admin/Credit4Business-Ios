//
//  UnitDetailsVC.swift
//  Credit4Business
//
//  Created by MacMini on 20/08/24.
//

import UIKit

class UnitDetailsVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var detailTableHeight: NSLayoutConstraint!
    @IBOutlet weak var leadsImage: UIImageView!
    @IBOutlet weak var loanStatusButton: UIButton!
    @IBOutlet weak var leadPhone: UILabel!
    @IBOutlet weak var leadName: UILabel!
    @IBOutlet weak var leadsNameHeader: UILabel!
    @IBOutlet weak var headersCollection: UICollectionView!
    //MARK: -------------------- Class Variable --------------------
    var companyDetails : CompanyList?
    var viewModel = HomeVM()
    var companyKVArray = [MenuModel]()
    var menuItems = ["Unit Profile", "Customers Linked","Funding","Photo ID","Address Proof","Other Files", "Bank Statements"]
    var selectedIndex = 0
    var selectedDocumentIndex = 0
    var selectedPhotoIdResponse : PhotoIDDataClass?
    var selectedAddressProofResponse : AddressProofDataClass?
    var selectedOtherResponse : OtherData?
    var selectedBankStatementResponse : BankStatementData?
    var leadsModel = [LeadsData]()
    var searchList = [LeadsData]()
    var leadsObject : LeadsModel?
    var loanModel : LoanModel?
    var currentTripPageIndex = 1{
        didSet {
            print(currentTripPageIndex.description)
        }
    }
    var totalTripPages = 1{
        didSet {
            print(totalTripPages.description)
        }
    }
    var HittedTripPageIndex = 0
    var oneTimeForHistory : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
      //  self.addObserverOnHeightTbl()
        self.manageActionMethods()
        self.createModelArrayForCompany()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if let tabbar = self.parent?.parent as? TabBarController {
            if let navigationController = tabbar.parent as? UINavigationController {
                navigationController.isNavigationBarHidden = true
            }
        }

//        self.tabBarController?.tabBar.isHidden = true
    }
    func setDelegates() {
        self.headersCollection.delegate = self
        self.headersCollection.dataSource = self
        self.detailsTable.delegate = self
        self.detailsTable.dataSource = self
        self.leadsNameHeader.text = self.companyDetails?.companyName
        self.leadName.text = self.companyDetails?.companyName
        self.leadPhone.text = "+44 " + (self.companyDetails?.companyNumber ?? "")
//        self.leadsImage.sd_setImage(with: URL(string: self.companyDetails?.image ?? ""))

    }
    func manageActionMethods() {
        self.backBtn.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory(companyDetails: CompanyList) -> UnitDetailsVC {
        let vc : UnitDetailsVC = UIStoryboard.Login.instantiateViewController()
        vc.companyDetails = companyDetails
        return vc
    }
    func createModelArrayForCompany() {
        self.companyKVArray.removeAll()
        let name = MenuModel.init(title: "Company Name", value: self.companyDetails?.companyName ?? "", apiKey: "")
        let id = MenuModel.init(title: "ID", value: self.companyDetails?.id ?? "", apiKey: "")
        let status = MenuModel.init(title: "Company Status", value: self.companyDetails?.companyStatus ?? "", apiKey: "")
        let number = MenuModel.init(title: "Company Number", value: self.companyDetails?.companyNumber ?? "", apiKey: "")
        let businessType = MenuModel.init(title: "Business Type", value: self.companyDetails?.businessType ?? "", apiKey: "")
        let tradingStyle = MenuModel.init(title: "Business / Shop Name", value: self.companyDetails?.tradingStyle ?? "", apiKey: "")
        let fundingPurpose = MenuModel.init(title: "Funding Purpose", value: self.companyDetails?.fundingPurpose ?? "", apiKey: "")
        let otherPurpose = MenuModel.init(title: "Other Funding Purpose", value: self.companyDetails?.otherFundingPurpose ?? "", apiKey: "")


        self.companyKVArray.append(name)
        self.companyKVArray.append(id)
        self.companyKVArray.append(status)
        self.companyKVArray.append(number)
        self.companyKVArray.append(businessType)
        self.companyKVArray.append(tradingStyle)
        self.companyKVArray.append(fundingPurpose)
        if self.companyDetails?.otherFundingPurpose != "" {
            self.companyKVArray.append(otherPurpose)
        }
        self.detailsTable.reloadData()
    }
}
extension UnitDetailsVC : UICollectionViewDelegate,UICollectionViewDataSource{
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
            self.detailsTable.reloadData()
            self.detailsTable.isHidden = false
            switch self.selectedIndex {
            case 0:
                break
            case 1:
                self.currentTripPageIndex = 0
                self.HittedTripPageIndex = 0
                self.leadsModel.removeAll()
                self.searchList.removeAll()
                self.fetchLeadDetails()
            case 2:
                self.fetchLoanDetails()
            case 3:
                self.fetchPhotoIDDetails()
                break
            case 4:
                self.fetchAddressProofDetails()
                break
            case 5:
                self.fetchOtherFilesDetails()
                break
            case 6:
                self.fetchBankStatementDetails()
                break
        default:
                  break
            }

        }
        return cell
    }
}
extension UnitDetailsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.detailsTable {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.selectedIndex {
        case 0:
            return self.companyKVArray.count
        case 1:
            return self.searchList.count
        case 2:
            return self.loanModel?.data.count ?? 0
        case 3:
            return self.viewModel.documentArray.count
        case 4:
            return self.viewModel.documentArray2.count
        case 5:
            return self.viewModel.otherArray.count
        case 6:
            return self.viewModel.statementArray.count
        default:
            return 0
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == detailsTable {
            if self.selectedIndex == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsDetailsCell", for: indexPath) as? LeadsDetailsCell else {
                    return UITableViewCell()
                }
                var array = self.companyKVArray
                    cell.titleLabel.text = array.value(atSafe: indexPath.row)?.title
                    cell.valueLabel.text = array.value(atSafe: indexPath.row)?.value

                    return cell

            }
            else if self.selectedIndex == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell", for: indexPath) as? LeadsCell else {
                    return UITableViewCell()
                }
                var model = self.searchList.value(atSafe: indexPath.row)
                cell.leadsName.text = (self.searchList.value(atSafe: indexPath.row)?.firstName ?? "") + " " + (self.searchList.value(atSafe: indexPath.row)?.lastName ?? "")
                cell.leadsPhone.text = self.searchList.value(atSafe: indexPath.row)?.phoneNumber
                cell.leadsImage.sd_setImage(with: URL(string: model?.image ?? ""))
                cell.leadsName.accessibilityHint = model?.id ?? ""
                cell.viewButton.isHidden = true
                return cell
            }
            else if self.selectedIndex == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell2", for: indexPath) as? LeadsCell else {
                    return UITableViewCell()
                }
                var model = self.loanModel?.data.value(atSafe: indexPath.row)
                cell.leadsName.text = model?.customer.companyName
                
                var color = "yellow"
                if model?.customer.loanDetails.value(atSafe: indexPath.row)?.currentStatus == "Admin_Cash_Disbursed" {
                    color = "green"
                }else if model?.customer.loanDetails.value(atSafe: indexPath.row)?.currentStatus.lowercased().contains("rejected") ?? false || model?.customer.loanDetails.value(atSafe: indexPath.row)?.currentStatus.lowercased().contains("returned") ?? false {
                    color = "red"
                }
                cell.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)
                
                if model?.customer.loanDetails.value(atSafe: indexPath.row)?.currentStatus != "" {
                    // cell.loanStatusButton.isHidden = false
                    let attributedTitle = NSMutableAttributedString(string: model?.customer.loanDetails.value(atSafe: indexPath.row)?.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])
                    
                    cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                }else{
                    //cell.loanStatusButton.isHidden = true
                }
                
                //cell.requestedDateLabel.text = "23-08-2024"//model?.appliedDate ?? ""
                cell.dateStack.isHidden = true

                cell.leadsName.accessibilityHint = model?.id ?? ""
                return cell

            }
            else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "documentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
                    return UITableViewCell()
                }
                var array : DocumentModel!
                        
                        switch self.selectedIndex {
                        case 3:
                            array = self.viewModel.documentArray.value(atSafe: indexPath.row)
                        case 4:
                            array = self.viewModel.documentArray2.value(atSafe: indexPath.row)
                        case 5:
                            array = self.viewModel.otherArray.value(atSafe: indexPath.row)
                        case 6:
                            array = self.viewModel.statementArray.value(atSafe: indexPath.row)
                        default:
                            break
                        }
                guard let model = array else {return UITableViewCell()}

                if model.isSelected{
                    cell.selectedFileView.isHidden = false
                    cell.uploadView.isHidden = true
                }else{
                    cell.selectedFileView.isHidden = true
                    cell.uploadView.isHidden = false
                }
                cell.selectedViewButton.addTapGestureRecognizer {
                    if model.fileURL != "" {
                        var vc = WebViewController.initWithStory()
                        vc.strPageTitle = "Document"
                        vc.strWebUrl = model.fileURL ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.showAlert(title: "Info", message: "Selected file document URL is invalid")
                    }
                    
                }
                cell.model = model
                cell.fileTypeLabel.text = ((self.selectedIndex == 4 && indexPath.row != 0) || (self.selectedIndex == 5 && indexPath.row != 0 ) ) ? "" : model.type
                cell.selectedFileName.text = model.fileName
                cell.selectedFileSize.text = model.fileSize
                cell.boxView.addTapGestureRecognizer {
                    self.selectedDocumentIndex = indexPath.row
                 //   self.redirectToImageChooseVC()
                }

                return cell
            }
            }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex == 2 {
           return 100
        }
            return UITableView.automaticDimension
    }
}
extension UnitDetailsVC {
    func fetchOtherFilesDetails() {
        APIService.shared.retrieveOtherFilesDetailsFromAgent(unitId: self.companyDetails?.id ?? "") { result in
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
        APIService.shared.retrieveBankStatementDetailsFromAgent(unitId: self.companyDetails?.id ?? "") { result in
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

    func fetchPhotoIDDetails() {
        APIService.shared.retrievePhotoIDDetailsFromAgent(unitId: self.companyDetails?.id ?? "") { result in
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
        APIService.shared.retrieveAddressProofDetailsFromAgent(unitId: self.companyDetails?.id ?? "") { result in
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
    func fetchLeadDetails() {
        var page = self.currentTripPageIndex+1
        guard  self.HittedTripPageIndex != self.currentTripPageIndex + 1 else {
            return
        }
        var urlStr = APIEnums.leadCustomerList.rawValue + "?company_id=\(self.companyDetails?.id ?? "")"
        if page != 1 {
            urlStr = urlStr + "?page=\(page)"
        }
        APIService.shared.retrieveLeadsDetails(url: urlStr) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.leadsObject = data
                        self.leadsModel.append(contentsOf: responseData)
                        self.searchList.append(contentsOf: responseData)
                        var next = self.getQueryItems(data.next)
                        var last = self.getQueryItems(data.last)
                        var Lastitem = last.filter({$0.key == "page"}).first?.value
                        var currentItem = next.filter({$0.key == "page"}).first?.value

                        self.totalTripPages = (Lastitem?.toInt() ?? 0)
                        self.currentTripPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.HittedTripPageIndex = (currentItem?.toInt() ?? 0) - 1

                      //  self.searchList = self.searchList.sorted(by: {$0.firstName < $1.firstName })

                        self.detailsTable.reloadData()
                    }
                    catch {
                        
                    }
                    self.oneTimeForHistory = true
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchLoanDetails() {
        APIService.shared.retrieveLoanDetailsFromAgent(unitId: self.companyDetails?.id ?? "") { result in
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
}
//MARK: -------------------------- Observers Methods --------------------------
extension UnitDetailsVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.detailsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
          //  self.detailTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.detailsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.detailsTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
extension UnitDetailsVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = detailsTable.visibleCells.last as? LeadsCell
        guard ((cell?.leadsName.text) != nil),
              (self.searchList.last != nil) else {return}
        if cell?.leadsName.accessibilityHint == (self.searchList.last?.id) &&
            self.leadsObject?.next != "" && self.currentTripPageIndex != self.totalTripPages && oneTimeForHistory {
            self.fetchLeadDetails()
            self.oneTimeForHistory = !self.oneTimeForHistory
        }
    }
}
