//
//  FundingOfferAcceptRejectVC.swift
//  Credit4Business
//
//  Created by MacMini on 11/09/24.
//

import UIKit
import IQKeyboardManagerSwift
class FundingOfferAcceptRejectVC: UIViewController {

    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var acceptButtonView: UIView!
    @IBOutlet weak var rejectButtonView: UIView!
    @IBOutlet weak var fundingTable: UITableView!
    @IBOutlet weak var fundingTableHeight: NSLayoutConstraint!
    @IBOutlet weak var dismissImage: UIImageView!
    
    //MARK: -------------------- Class Variable --------------------
    var offerData : FundingOfferData?
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
        // Do any additional setup after loading the view.
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    func setDelegates() {
        self.fundingTable.delegate = self
        self.fundingTable.dataSource = self
    }
    func manageActionMethods() {
        self.dismissImage.addTapGestureRecognizer {
            self.dismiss(animated: true)
        }
        self.acceptButtonView.addTapGestureRecognizer {
            var dict = JSON()
            dict["action"] = "true"
            dict["loan_offer_id"] = self.offerData?.id
            self.makeActionForFundingOffer(params: dict)
        }
        self.rejectButtonView.addTapGestureRecognizer {
            var dict = JSON()
            dict["action"] = "false"
            dict["loan_offer_id"] = self.offerData?.id
            self.makeActionForFundingOffer(params: dict)
        }
    }
    class func initWithStory(offerData: FundingOfferData) -> FundingOfferAcceptRejectVC {
        let vc : FundingOfferAcceptRejectVC = UIStoryboard.Login.instantiateViewController()
        vc.offerData = offerData
        return vc
    }
    func makeActionForFundingOffer(params: JSON) {
        APIService.shared.makeRequest(endpoint: APIEnums.makeActionForFundingOffer.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.dismiss(animated: true)
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
}
extension FundingOfferAcceptRejectVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == fundingTable {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "fundingOfferAcceptRejectCell", for: indexPath) as? FundingOfferAcceptRejectCell else {
                    return UITableViewCell()
                }
            guard let model = self.offerData else {return UITableViewCell()}
            cell.topofferAmountLabel.text = model.offerAmount
            cell.expiredDataLabel.text = self.convertDateFormat(inputDate: model.offerDate,outputFormat: "yyyy-MM-dd")
            cell.offerAmountLabel.text = "£" + model.offerAmount
            cell.offerWeeksLabel.text = model.offerNumberOfWeeks.description + " Weeks"
            var title = model.offerAccepted ? "Accepted" : (model.offerRejected ? "Rejected" : "No Action")
            let attributedTitle = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

            cell.statusButton.setAttributedTitle(attributedTitle, for: .normal)

            cell.expiredStackView.isHidden = !model.isExpired
            cell.appliedFundingAmountLabel.text = "£" + model.appliedLoanAmount
            cell.appliedFundingOfferWeeks.text = model.appliedFundDurationWeeks.description + " Weeks"
            return cell
           
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
//MARK: -------------------------- Observers Methods --------------------------
extension FundingOfferAcceptRejectVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.fundingTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.fundingTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.fundingTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.fundingTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
