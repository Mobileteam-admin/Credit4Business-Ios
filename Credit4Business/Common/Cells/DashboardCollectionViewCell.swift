//
//  DashboardCollectionViewCell.swift
//  Credit4Business
//
//  Created by MacMini on 05/09/24.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var makePaymentView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var makePaymentBtn: UIButton!
    @IBOutlet weak var dueView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var remainingInstallmentLabel: UILabel!
    @IBOutlet weak var installmentPaidLabel: UILabel!
    @IBOutlet weak var fundingAmountLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var paymentAmountLabel: UILabel!
    @IBOutlet weak var paymentTitleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var totalInstallmentValueLabel: UILabel!
    @IBOutlet weak var loanStatusButton: UIButton!
    
    @IBOutlet weak var expectedCompletionDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.outerView.layer.borderWidth = 0.5
//        self.outerView.layer.borderColor = UIColor(named: "separator")?.cgColor
    }
}
