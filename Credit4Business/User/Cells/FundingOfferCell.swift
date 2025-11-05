//
//  FundingOfferCell.swift
//  Credit4Business
//
//  Created by MacMini on 10/09/24.
//

import UIKit

class FundingOfferCell: UITableViewCell {

    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var offerWeeksLabel: UILabel!
    @IBOutlet weak var offerAmountLabel: UILabel!
    @IBOutlet weak var expiredButton: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
