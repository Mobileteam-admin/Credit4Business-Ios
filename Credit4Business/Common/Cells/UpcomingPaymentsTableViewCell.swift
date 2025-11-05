//
//  UpcomingPaymentsTableViewCell.swift
//  Credit4Business
//
//  Created by MacMini on 19/06/24.
//

import UIKit

class UpcomingPaymentsTableViewCell: UITableViewCell {

    @IBOutlet weak var makePaymentView: UIView!
    @IBOutlet weak var dueView: UIView!
    @IBOutlet weak var makePaymentBtn: UIButton!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var remainingInstallmentLabel: UILabel!
    @IBOutlet weak var installmentPaidLabel: UILabel!
    @IBOutlet weak var fundingAmountLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var paymentAmountLabel: UILabel!
    @IBOutlet weak var paymentTitleLabel: UILabel!
    
    @IBOutlet weak var missedEMIValueLabel: UILabel!
    @IBOutlet weak var missedEMILabel: UILabel!
    @IBOutlet weak var loanNumberValueLabel: UILabel!
    @IBOutlet weak var loanNumberLabel: UILabel!
    @IBOutlet weak var totalInstallmentValueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outerView.layer.borderWidth = 0.5
        self.outerView.layer.borderColor = UIColor(named: "separator")?.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class SummaryCell: UICollectionViewCell{
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outerView.layer.borderWidth = 0.5
        self.outerView.layer.borderColor = UIColor(named: "separator")?.cgColor
        self.outerView.layer.cornerRadius = 10
    }
}
class SummaryInnerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loanNumberLabel: UILabel!
}
class SummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var innerTableHeight: NSLayoutConstraint!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var imageActionView: UIView!
    @IBOutlet weak var innerTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loanNumberLabel: UILabel!
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var paidInstallmentsLabel: UILabel!
    @IBOutlet weak var remainingInstallmentsLabel: UILabel!
    @IBOutlet weak var totalInstallmentsLabel: UILabel!
    @IBOutlet weak var gocardlessMissedEmisLabel: UILabel!
    
    
    @IBOutlet weak var historyTableHeight: NSLayoutConstraint!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var historyDropdownImage: UIImageView!
    @IBOutlet weak var historyImageLabel: UILabel!
    @IBOutlet weak var historyImageActionView: UIView!
    
    var model: SummaryClass?
    var innerTableHidden = true
    var delegate : SummaryCellDelegate!
    var isExtended = false
    var loanModel: SummaryDataClass?
    var historyTableHidden = true
    var ishistoryExtended = false
    var historyArray = [FundingPaymentHistory]()
    var dropdownType : DropDownType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setDelegates()
        self.outerView.layer.borderWidth = 0.5
        self.outerView.layer.borderColor = UIColor(named: "separator")?.cgColor
    }
    func setDelegates() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.innerTableView.delegate = self
        self.innerTableView.dataSource = self
        self.historyTable.delegate = self
        self.historyTable.dataSource = self
        self.addObserverOnHeightTbl()
    }
    func showHideTable() {
        switch self.dropdownType {
        case .history:
            if self.historyTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .loanNumber:
            if self.innerTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        default:
            break
        }
    }
    
}
extension SummaryTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return 5
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "summaryCell", for: indexPath) as? SummaryCell else {
                return UICollectionViewCell()
            }
            var title = ""
            var description = 0
            switch indexPath.row {
            case 0:
                title = "Total Number of Loans"
                description = self.model?.totalLoans ?? 0
            case 1:
                title = "Total Loan Amount"
                description = self.model?.totalAmount ?? 0
            case 2:
                title = "Total Number of Installments"
                description = self.model?.totalInstallments ?? 0
            case 3:
                title = "Remaining Installments"
                description = self.model?.totalRemainingInstallments ?? 0
            case 4:
                title = "Gocardless missed Installments"
                description = self.model?.totalGocardlessMissedInstallments ?? 0
            default:
                break
            }
            cell.titleLabel.text = title
            cell.valueLabel.text = description.description
           
            return cell
        }
        return UICollectionViewCell()
    }
}
extension SummaryTableViewCell {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                switch self.dropdownType {
                case .history:
                    self.historyTable.isHidden = false
                    self.historyDropdownImage.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.historyTable.reloadData()
                    self.layoutIfNeeded()
                case .loanNumber:
                    self.innerTableView.isHidden = false
                    self.iconImage.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.innerTableView.reloadData()
                    self.layoutIfNeeded()
                default:
                    break
                
            }
            }, completion: nil)
        }
        
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            switch self.dropdownType {
            case .history:
                self.historyTable.isHidden = true
                self.historyDropdownImage.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.historyTable.reloadData()
                self.layoutIfNeeded()
            case .loanNumber:
                self.innerTableView.isHidden = true
                self.iconImage.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.innerTableView.reloadData()
                self.layoutIfNeeded()
            default:
                break
            
        }
        }, completion: nil)
    }
}
extension SummaryTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == innerTableView{
            count = self.loanModel?.loans.count ?? 0
        }else if tableView == historyTable{
            count = self.historyArray.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == innerTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "summaryInnerTableViewCell", for: indexPath) as? SummaryInnerTableViewCell else {
                return UITableViewCell()
            }
                var modelObj = self.loanModel?.loans.value(atSafe: indexPath.row)
            cell.loanNumberLabel.text = modelObj!.loanNumber.description
            return cell
        }
        else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as? PaymentCell else {
                return UITableViewCell()
            }
            var modelObj = self.historyArray.value(atSafe: indexPath.row)
            cell.descriptionLabel.text = modelObj?.description
            cell.amountLabel.text = modelObj?.amount
            cell.dateLabel.text = modelObj?.date
                if modelObj?.description == "Payment Failed" {
                    cell.amountLabel.textColor = .red
                   // cell.galleryLabel.font = UIFont(name: "Poppins-Medium", size: 14)
                }else{
                    cell.amountLabel.textColor = .black
                }
            return cell
            }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == innerTableView {
            return 30

        }else{
            return 50

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == innerTableView {
            self.innerTableHidden = !self.innerTableHidden
    //                    guard let model = self.viewModel.paymentArray.value(atSafe: indexPath.row) else {return}
            self.isExtended = !self.isExtended
            self.showHideTable()
            self.delegate.selectedLoanId(id: self.loanModel?.loans.value(atSafe: indexPath.row)?.loanNumber ?? 0)
        }
       

    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension SummaryTableViewCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.innerTableView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.innerTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.historyTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.historyTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.innerTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.historyTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.innerTableView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView2 = self.historyTable else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
