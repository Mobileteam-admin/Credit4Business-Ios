//
//  LeadsCell.swift
//  Credit4Business
//
//  Created by MacMini on 29/04/24.
//

import UIKit

class LeadsCell: UITableViewCell {

    @IBOutlet weak var textMessage: UILabel!
    @IBOutlet weak var requestedDateLabel: UILabel!
    @IBOutlet weak var loanStatusButton: UIButton!
    @IBOutlet weak var leadsImage: UIImageView!
    @IBOutlet weak var leadsPhone: UILabel!
    @IBOutlet weak var leadsName: UILabel!
    
    @IBOutlet weak var expectedCompletionDate: UILabel!
    @IBOutlet weak var dateStack: UIView!
    @IBOutlet weak var viewButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class CreditMonitoringCell: UITableViewCell {

    @IBOutlet weak var contractIdLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastTextMessageLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class PendingRequestCell: UITableViewCell {

    @IBOutlet weak var photoIdChangeStatusLabel: UILabel!
    @IBOutlet weak var addressProofChangeStatusLabel: UILabel!
    @IBOutlet weak var profileChangeStatusLabel: UILabel!
    @IBOutlet weak var photoIdChangesStack: UIStackView!
    @IBOutlet weak var addressProofSeparator: UILabel!
    @IBOutlet weak var addressProofChangesStack: UIStackView!
    @IBOutlet weak var profileChangesSeparator: UILabel!
    @IBOutlet weak var profileChangesStack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
