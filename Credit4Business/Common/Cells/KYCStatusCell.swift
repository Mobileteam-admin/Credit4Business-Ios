//
//  KYCStatusCell.swift
//  Credit4Business
//
//  Created by MacMini on 25/07/24.
//

import UIKit

class KYCStatusCell: UITableViewCell {

    @IBOutlet weak var verificationStatus4: UIButton!
    @IBOutlet weak var verificationStatus3: UIButton!
    @IBOutlet weak var verificationStatus2: UIButton!
    @IBOutlet weak var verificationStatus1: UIButton!
    @IBOutlet weak var verificationStack2: UIStackView!
    @IBOutlet weak var verificationStack1: UIStackView!
    @IBOutlet weak var phoneValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var kycStatusButton: UIButton!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var viewCertificate: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
