//
//  LoansVC.swift
//  Credit4Business
//
//  Created by MacMini on 05/08/24.
//

import UIKit
import SDWebImage

class LoansVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var leadsTable: UITableView!
    @IBOutlet weak var headerLabel: UILabel!

    //MARK: -------------------- Class Variable --------------------
    var viewModel = HomeVM()
    var leadData : LeadsData!
    var customerData : CustomerData!
    var isLead = false
    var withLoanData = false
    var loanModel : LoanModel?

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        if !self.withLoanData {
            self.fetchLoanDetails()
        }
        self.setDelegates()
        self.manageActionMethods()
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
        self.leadsTable.delegate = self
        self.leadsTable.dataSource = self
       // self.backBtn.isHidden = true
    }
    func manageActionMethods() {
        self.backBtn.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory(leadsData: LeadsData) -> LoansVC {
        let vc : LoansVC = UIStoryboard.Login.instantiateViewController()
        vc.leadData = leadsData
        vc.isLead = true
        vc.withLoanData = true
        return vc
    }
    class func initWithStory(customerData: CustomerData) -> LoansVC {
        let vc : LoansVC = UIStoryboard.Login.instantiateViewController()
        vc.customerData = customerData
        vc.isLead = false
        vc.withLoanData = true
        return vc
    }
    class func initWithStory() -> LoansVC {
        let vc : LoansVC = UIStoryboard.Login.instantiateViewController()
        vc.withLoanData = false
        return vc
    }
    func fetchLoanDetails() {
        APIService.shared.retrieveLoanDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.loanModel = responseData
                        globalLoanModel = self.loanModel
                        self.leadsTable.reloadData()
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
extension LoansVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.withLoanData ? (self.isLead ? self.leadData.loanStatus.count : self.customerData.loanStatus.count) : self.loanModel?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leadsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell2", for: indexPath) as? LeadsCell else {
                return UITableViewCell()
            }
            if self.withLoanData {
                
                if self.isLead {
                    var model = self.leadData.loanStatus.value(atSafe: indexPath.row)
                    cell.leadsName.text = self.leadData.companyName
                    cell.loanStatusButton.setTitle(model?.currentStatus ?? "", for: .normal)
                    var color = "yellow"
                    if model?.currentStatus == "Admin_Cash_Disbursed" {
                        color = "green"
                    }else if model?.currentStatus.lowercased().contains("rejected") ?? false || model?.currentStatus.lowercased().contains("returned") ?? false {
                        color = "red"
                    }
                    cell.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)
                    if model?.currentStatus != "" {
                        // cell.loanStatusButton.isHidden = false
                        let attributedTitle = NSMutableAttributedString(string: model?.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])
                        
                        cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                    }else{
                        //cell.loanStatusButton.isHidden = true
                    }
                    
                    //cell.requestedDateLabel.text = "23-08-2024"//model?.appliedDate ?? ""
                    cell.dateStack.isHidden = true

                    cell.leadsName.accessibilityHint = model?.loanID ?? ""
                    return cell
                }
                else{
                    var model = self.customerData.loanStatus.value(atSafe: indexPath.row)
                    cell.leadsName.text = self.customerData.companyName
                    cell.loanStatusButton.setTitle(model?.currentStatus ?? "", for: .normal)
                    var color = "yellow"
                    if model?.currentStatus == "Admin_Cash_Disbursed" {
                        color = "green"
                    }else if model?.currentStatus.lowercased().contains("rejected") ?? false || model?.currentStatus.lowercased().contains("returned") ?? false {
                        color = "red"
                    }
                    cell.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)
                    if model?.currentStatus != "" {
                        // cell.loanStatusButton.isHidden = false
                        let attributedTitle = NSMutableAttributedString(string: model?.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])
                        
                        cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                    }else{
                        //cell.loanStatusButton.isHidden = true
                    }
                    cell.dateStack.isHidden = true
                   // cell.requestedDateLabel.text = "23-08-2024"//model?.appliedDate ?? ""
                    cell.leadsName.accessibilityHint = model?.loanID ?? ""
                    return cell
                }}
            else{
                guard let model = self.loanModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
                cell.leadsName.text = model.customer.companyName
                var color = "yellow"
                if model.customer.loanDetails.filter({$0.loanID == model.id}).first?.currentStatus == "Admin_Cash_Disbursed" {
                    color = "green"
                }else if model.customer.loanDetails.filter({$0.loanID == model.id}).first?.currentStatus.lowercased().contains("rejected") ?? false || model.customer.loanDetails.filter({$0.loanID == model.id}).first?.currentStatus.lowercased().contains("returned") ?? false {
                    color = "red"
                }
                cell.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)
                if model.customer.loanDetails.filter({$0.loanID == model.id}).first?.currentStatus != "" {
                    // cell.loanStatusButton.isHidden = false
                    let attributedTitle = NSMutableAttributedString(string: model.customer.loanDetails.filter({$0.loanID == model.id}).first?.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])
                    
                    cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                }else{
                    //cell.loanStatusButton.isHidden = true
                }
                
                //cell.requestedDateLabel.text = "23-08-2024"//model?.appliedDate ?? ""
                cell.dateStack.isHidden = true

                cell.leadsName.accessibilityHint = model.id ?? ""
                return cell
            }
            
            return cell
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.withLoanData{
            if self.isLead{
                guard let model = self.leadData else{
                    return
                }
                guard let loanModel = self.leadData.loanStatus.value(atSafe: indexPath.row) else{
                    return
                }
                let vc = LeadsDetailsVC.initWithStory(customerId: model.id, customerName: model.firstName + " " + model.lastName, customerPhone: model.phoneNumber, customerImage: model.image)
                vc.loanID = loanModel.loanID
                vc.loanStatus = loanModel.currentStatus
                vc.loanUpcomingStatus = loanModel.upcomingStatus
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                guard let model = self.customerData else{
                    return
                }
                let vc = CustomerProfileVC.initWithStory(customerId: model.id,customerName: model.firstName,customerPhone: model.phoneNumber)
                self.navigationController?.pushViewController(vc, animated: true)
            }}
        else{
            guard let model = self.loanModel?.data.value(atSafe: indexPath.row) else{
                return
            }
            let vc = LeadsDetailsVC.initWithStory(customerId: model.customer.id, customerName: model.customer.firstName + " " + model.customer.lastName, customerPhone: model.customer.phoneNumber, customerImage: model.customer.image)
            vc.loanID = model.id
            vc.loanStatus = model.customer.loanDetails.filter({$0.loanID == model.id}).first?.currentStatus ?? "" //first?.currentStatus ?? ""
            vc.loanUpcomingStatus = model.customer.loanDetails.filter({$0.loanID == model.id}).first?.upcomingStatus ?? ""//first?.upcomingStatus ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

