//
//  CreditMonitorVC.swift
//  Credit4Business
//
//  Created by MacMini on 19/08/24.
//

import UIKit

class CreditMonitorVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var leadsTable: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    
    //MARK: -------------------- Class Variable --------------------
    var viewModel = HomeVM()
    var creditMonitoringData = [CreditMonitoring]()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.fetchCreditMonitoringListDetails()
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
    class func initWithStory() -> CreditMonitorVC {
        let vc : CreditMonitorVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
    func fetchCreditMonitoringListDetails() {
        APIService.shared.retrieveCreditMonitoringList() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.creditMonitoringData = responseData
                        self.leadsTable.reloadData()
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

}
extension CreditMonitorVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditMonitoringData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leadsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "creditMonitoringCell", for: indexPath) as? CreditMonitoringCell else {
                return UITableViewCell()
            }
            var model = self.creditMonitoringData.value(atSafe: indexPath.row)
            cell.companyNameLabel.text = model?.company
            cell.amountLabel.text = model?.amount
            cell.roleLabel.text = model?.previousComment?.createdBy.role
            cell.lastTextMessageLabel.text = model?.previousComment?.comment
            cell.dateLabel.text = model?.previousComment?.createdOn != "" ? self.convertDateFormat(inputDate: model?.previousComment?.createdOn ?? "",outputFormat: "dd-MM-yyyy h:mm a") : ""
            cell.contractIdLabel.text = model?.customerLoan
            var color = "yellow"
            if model?.loanStatus.currentStatus == "Admin_Cash_Disbursed" {
                color = "green"
            }else if model?.loanStatus.currentStatus.lowercased().contains("rejected") ?? false || model?.loanStatus.currentStatus.lowercased().contains("returned") ?? false {
                color = "red"
            }
            cell.statusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)
            if model?.loanStatus.currentStatus != "" {
                let attributedTitle = NSMutableAttributedString(string: model?.loanStatus.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])

                cell.statusButton.setAttributedTitle(attributedTitle, for: .normal)
            }
            cell.contentView.addTapGestureRecognizer {
                let vc = CreditMonitoringCommentsVC.initWithStory()
                vc.loanId = model?.customerLoan ?? ""
                vc.mandateId = model?.mandate.id ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
