//
//  GocardStatementCell.swift
//  Credit4Business
//
//  Created by MacMini on 29/08/24.
//

import UIKit

class GocardStatementCell: UITableViewCell {

    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var totalPeriods: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var bankName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
