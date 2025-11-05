//
//  MarketingTableViewCell.swift
//  Credit4Business
//
//  Created by MacMini on 27/05/24.
//

import UIKit

class MarketingTableViewCell: UITableViewCell {

    @IBOutlet weak var option5Image: UIImageView!
    @IBOutlet weak var option4Image: UIImageView!
    @IBOutlet weak var option3Image: UIImageView!
    @IBOutlet weak var option2Image: UIImageView!
    @IBOutlet weak var option1Image: UIImageView!
    @IBOutlet weak var consentTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
