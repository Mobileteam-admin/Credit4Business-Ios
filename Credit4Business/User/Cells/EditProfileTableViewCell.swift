//
//  EditProfileTableViewCell.swift
//  Credit4Business
//
//  Created by MacMini on 16/05/24.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var femaleImage: UIImageView!
    @IBOutlet weak var maleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileTextField: UITextField!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var errStackView: UIStackView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var genderView: UIStackView!
    var model : MenuModel?
    var delegate : CellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension EditProfileTableViewCell : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.profileTextField {
            self.model?.error = ""
            self.model?.isError = false
        }
        
       
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.profileTextField:
            if (self.profileTextField.text == nil || self.profileTextField.text == "") {
                self.model?.error = "Please enter \(self.titleLabel.text ?? "")"
                self.model?.isError = true
                self.delegate?.reload()
            }else{
                self.model?.value = textField.text ?? ""
                self.model?.isError = false
                self.model?.error = ""
                self.delegate?.reload()
            }
       
        default:
            break
        }
    }
}
