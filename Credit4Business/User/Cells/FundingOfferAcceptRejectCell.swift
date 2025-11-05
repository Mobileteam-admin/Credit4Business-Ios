//
//  FundingOfferAcceptRejectCell.swift
//  Credit4Business
//
//  Created by MacMini on 11/09/24.
//

import UIKit

class FundingOfferAcceptRejectCell: UITableViewCell {

    @IBOutlet weak var expiredDataLabel: UILabel!
    @IBOutlet weak var expiredStackView: UIStackView!
    @IBOutlet weak var offerWeeksLabel: UILabel!
    @IBOutlet weak var offerAmountLabel: UILabel!
    @IBOutlet weak var appliedFundingOfferWeeks: UILabel!
    @IBOutlet weak var appliedFundingAmountLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var topofferAmountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
