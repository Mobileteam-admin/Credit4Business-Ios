//
//  ServicesCollectionViewCell.swift
//  Credit4Business
//
//  Created by MacMini on 05/03/24.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
class StatusCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var expectedCompletionDate: UILabel!
    @IBOutlet weak var loanStatusButton: UIButton!

    @IBOutlet weak var companyNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
