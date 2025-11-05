//
//  DocumentTableViewCell.swift
//  Credit4Business
//
//  Created by MacMini on 22/04/24.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var boxView: RectangularDashedView!
    @IBOutlet weak var fileTypeLabel: UILabel!
    @IBOutlet weak var selectedViewButton: UIButton!
    @IBOutlet weak var selectedFileSize: UILabel!
    @IBOutlet weak var selectedFileName: UILabel!
    @IBOutlet weak var selectedFileView: UIStackView!
    @IBOutlet weak var uploadButtonView: UIView!
    var model = DocumentModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
